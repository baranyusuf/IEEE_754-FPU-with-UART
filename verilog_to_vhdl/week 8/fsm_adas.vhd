library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_adas is
    Port (
        clk               : in  STD_LOGIC;
        rst_n             : in  STD_LOGIC;
        timer_tick_i      : in  STD_LOGIC;
        mod_i             : in  STD_LOGIC;
        kirmizi_isik_i    : in  STD_LOGIC_VECTOR(1 downto 0);
        yaya_gecidi_i     : in  STD_LOGIC_VECTOR(1 downto 0);
        mesafe_olcum_lidar_i : in  STD_LOGIC_VECTOR(7 downto 0);
        mesafe_olcum_kamera_i : in  STD_LOGIC_VECTOR(7 downto 0);
        mesafe_giris_i    : in  STD_LOGIC_VECTOR(7 downto 0);
        hiz_olcum_i       : in  STD_LOGIC_VECTOR(7 downto 0);
        hiz_giris_i       : in  STD_LOGIC_VECTOR(7 downto 0);
        gaz_o             : out STD_LOGIC;
        fren_o            : out STD_LOGIC;
        kirmizi_isik_o    : out STD_LOGIC;
        yaya_gecidi_o     : out STD_LOGIC;
        takip_mesafe_o    : out STD_LOGIC
    );
end fsm_adas;

architecture Behavioral of fsm_adas is  
	type std_logic_vector_array is array (0 to 2) of std_logic_vector(7 downto 0);
    type state_type is (ASSISTANCE, TRANSITION, OTONOM);
    signal state : state_type;
    signal olcum_buffer : std_logic_vector_array;
    signal takip_mesafe_kaydedilen, hiz_kaydedilen : std_logic_vector(7 downto 0);

    signal kirmizi_isik_var, yaya_gecidi_var : std_logic;
    signal mesafe_fark : std_logic_vector(7 downto 0);
    signal yeni_mesafe_olcum : std_logic_vector(8 downto 0);
    signal olcum_ortalama : std_logic_vector(9 downto 0);
    signal gaz, fren, kirmizi_isik, yaya_gecidi, takip_mesafe : std_logic;

begin
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            state <= ASSISTANCE;
            takip_mesafe_kaydedilen <= "00110010"; 
            hiz_kaydedilen <= "11001000"; 
            olcum_buffer <= (others => (others => '0'));
        elsif rising_edge(clk) then
            olcum_buffer(2) <= olcum_buffer(1);
			olcum_buffer(1) <= olcum_buffer(0);
			olcum_buffer(0)(7 downto 0) <= olcum_ortalama(7 downto 0);
            
            case state is
                when ASSISTANCE =>
                    if timer_tick_i = '1' then
                        kirmizi_isik <= '0';
                        if kirmizi_isik_i = "11" then
                            kirmizi_isik <= '1';
                        end if;
                        
                        yaya_gecidi <= '0';
                        if yaya_gecidi_i = "11" then
                            yaya_gecidi <= '1';
                        end if;
                        
                        takip_mesafe <= '0';
                        if olcum_ortalama < takip_mesafe_kaydedilen then
                            takip_mesafe <= '1';
                        end if;
                        
                        if mod_i = '1' then
                            kirmizi_isik <= '0';
                            yaya_gecidi <= '0';
                            takip_mesafe <= '0';
                            state <= TRANSITION;
                        end if;
                    end if;
                    
                when TRANSITION =>
                    if timer_tick_i = '1' then
                        takip_mesafe_kaydedilen <= mesafe_giris_i;
                        hiz_kaydedilen <= hiz_giris_i;
                        state <= OTONOM;
                    end if;
                    
                when OTONOM =>
                    if timer_tick_i = '1' then
                        if mod_i = '0' then
                            fren <= '0';
                            gaz <= '0';
                            state <= ASSISTANCE;
                        else
                            if olcum_ortalama < takip_mesafe_kaydedilen then
                                fren <= '1';
                                gaz <= '0';
                            else
                                if hiz_olcum_i < hiz_kaydedilen then
                                    fren <= '0';
                                    gaz <= '1';
                                elsif hiz_olcum_i = hiz_kaydedilen then
                                    fren <= '0';
                                    gaz <= '0';
                                else
                                    fren <= '1';
                                    gaz <= '0';
                                end if;
                            end if;
                            
                            if yaya_gecidi_var = '1' then
                                if hiz_olcum_i > "00010100" then
                                    fren <= '1';
                                    gaz <= '0';
                                else
                                    fren <= '0';
                                    gaz <= '0';
                                end if;
                            end if;
                            
                            if kirmizi_isik_var = '1' then
                                fren <= '1';
                                gaz <= '0';
                            end if;
                        end if;
                    end if;
                    
                when others =>
                    state <= ASSISTANCE;
            end case;
        end if;
    end process;

    gaz_o <= gaz;
    fren_o <= fren;
    kirmizi_isik_o <= kirmizi_isik;
    yaya_gecidi_o <= yaya_gecidi;
    takip_mesafe_o <= takip_mesafe;

end Behavioral;
