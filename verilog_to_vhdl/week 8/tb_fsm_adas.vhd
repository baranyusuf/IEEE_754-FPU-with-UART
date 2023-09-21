    library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_fsm_adas is
end tb_fsm_adas;

architecture testbench of tb_fsm_adas is
    signal clk             : std_logic := '0';
    signal rst_n           : std_logic := '1'; 
    signal timer_tick_i    : std_logic;
    signal mod_i           : std_logic;
    signal kirmizi_isik_i  : std_logic_vector(1 downto 0);
    signal yaya_gecidi_i   : std_logic_vector(1 downto 0);
    
    
    signal gaz_o           : std_logic;
    signal fren_o          : std_logic;
    signal kirmizi_isik_o  : std_logic;
    signal yaya_gecidi_o   : std_logic;
    signal takip_mesafe_o  : std_logic;
    
    constant CLK_PERIOD    : time := 10 ns; 
    
    
    component fsm_adas
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
    end component;

begin
    
    dut: fsm_adas
        port map (
            clk               => clk,
            rst_n             => rst_n,
            timer_tick_i      => timer_tick_i,
            mod_i             => mod_i,
            kirmizi_isik_i    => kirmizi_isik_i,
            yaya_gecidi_i     => yaya_gecidi_i,
            mesafe_olcum_lidar_i => (others => '0'), 
            mesafe_olcum_kamera_i => (others => '0'), 
            mesafe_giris_i    => (others => '0'),
            hiz_olcum_i       => (others => '0'), 
            hiz_giris_i       => (others => '0'), 
            gaz_o             => gaz_o,
            fren_o            => fren_o,
            kirmizi_isik_o    => kirmizi_isik_o,
            yaya_gecidi_o     => yaya_gecidi_o,
            takip_mesafe_o    => takip_mesafe_o
        );

    
    clk_process: process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    
    stimulus_process: process
    begin
        
        timer_tick_i   <= '0';
        mod_i          <= '0';
        kirmizi_isik_i <= "00";
        yaya_gecidi_i  <= "00";
        
        rst_n <= '0';
        wait for CLK_PERIOD;
        rst_n <= '1';
        wait for CLK_PERIOD;
        
        
         assert false
            report "SIM DONE"
            severity failure;   
    
    end process;

end testbench;
