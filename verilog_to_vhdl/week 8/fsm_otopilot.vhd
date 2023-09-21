library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_otopilot is 

    Port (
        clk                   : in  STD_LOGIC;
        rst_n                 : in  STD_LOGIC;
        gnss_i                : in  STD_LOGIC_VECTOR(15 downto 0);
        altimetre_i           : in  STD_LOGIC_VECTOR(15 downto 0);
        hedef_yukseklik_i     : in  STD_LOGIC_VECTOR(7 downto 0);
        yukseklik_bilgisi_i   : in  STD_LOGIC;
        motor_o               : out STD_LOGIC;
        yesil_led_o           : out STD_LOGIC;
        kirmizi_led_o         : out STD_LOGIC
    );
end fsm_otopilot;

architecture Behavioral of fsm_otopilot is
    
    constant S_YUKSEKLIK_BEKLE : std_logic_vector(1 downto 0) := "00";
    constant S_ACIL_DURUS      : std_logic_vector(1 downto 0) := "01";
    constant S_UCUS            : std_logic_vector(1 downto 0) := "10";

    
    signal hedef_yukseklik_hata : std_logic;
    signal motor_ac            : std_logic;
    signal sensor_fark         : std_logic_vector(15 downto 0);
    signal sensor_ortalama     : std_logic_vector(15 downto 0);

    
    signal state               : std_logic_vector(1 downto 0);
    signal hata_sayaci         : std_logic_vector(1 downto 0);
    signal atanan_yukseklik    : std_logic_vector(7 downto 0);
    signal yesil_led           : std_logic;
    signal kirmizi_led         : std_logic;
    signal motor               : std_logic;
    signal input_vector : std_logic_vector(15 downto 0);
signal shifted_vector : std_logic_vector(15 downto 0);

begin
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            state           <= S_YUKSEKLIK_BEKLE;
            hata_sayaci     <= "00";
            atanan_yukseklik <= (others => '0');
            yesil_led       <= '0';
            kirmizi_led     <= '0';
            motor           <= '0';
        elsif rising_edge(clk) then
            if (hedef_yukseklik_i < "001010" or hedef_yukseklik_i > "1100100") then
                hedef_yukseklik_hata <= '1';
            else
                hedef_yukseklik_hata <= '0';
            end if;

            if gnss_i > altimetre_i then
                sensor_fark <= gnss_i - altimetre_i;
            else
                sensor_fark <= altimetre_i - gnss_i;
            end if;

            if sensor_fark > "0000000000001001" then
                sensor_ortalama <= gnss_i;
            else 
            	input_vector <= altimetre_i;
            	shifted_vector <= "000000000" & input_vector(7 downto 1);
            	
            	
                sensor_ortalama <= (gnss_i) + (shifted_vector);


            end if;

            motor_ac <= '0';
            if state = S_UCUS then
                if unsigned(sensor_ortalama) >= unsigned(atanan_yukseklik) then
                    motor_ac <= '0';
                else
                    motor_ac <= '1';
                end if;
            end if;
        end if;
    end process;

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            
        elsif rising_edge(clk) then
            case state is
                when S_YUKSEKLIK_BEKLE =>
                    if yukseklik_bilgisi_i = '1' then
                        if hedef_yukseklik_hata = '0' then
                            atanan_yukseklik <= hedef_yukseklik_i;
                            state <= S_UCUS;
                        else
                            if hata_sayaci = "10" then
                                state <= S_ACIL_DURUS;
                                kirmizi_led <= '1';
                            else
                                hata_sayaci <= hata_sayaci + 1;
                                state <= S_YUKSEKLIK_BEKLE;
                            end if;
                        end if;
                    else
                        state <= S_YUKSEKLIK_BEKLE;
                    end if;

                when S_ACIL_DURUS =>
                    

                when S_UCUS =>
                    if motor_ac = '1' then
                        motor <= '1';
                    else
                        motor <= '0';
                        yesil_led <= '1';
                    end if;

                when others =>
                    state <= S_YUKSEKLIK_BEKLE;
            end case;
        end if;
    end process;

    motor_o     <= motor;
    yesil_led_o <= yesil_led;
    kirmizi_led_o <= kirmizi_led;

end Behavioral;