library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_fsm_otopilot is
end tb_fsm_otopilot;

architecture testbench of tb_fsm_otopilot is
    signal clk                  : std_logic := '0';
    signal rst_n                : std_logic := '1'; 
    signal gnss_i               : std_logic_vector(15 downto 0);
    signal altimetre_i          : std_logic_vector(15 downto 0);
    signal hedef_yukseklik_i    : std_logic_vector(7 downto 0);
    signal yukseklik_bilgisi_i  : std_logic;
    signal motor_o              : std_logic;
    signal yesil_led_o          : std_logic;
    signal kirmizi_led_o        : std_logic;

    constant CLK_PERIOD    : time := 10 ns; 
    
    
    component fsm_otopilot
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
    end component;

begin
    
    dut: fsm_otopilot
        port map (
            clk                   => clk,
            rst_n                 => rst_n,
            gnss_i                => gnss_i,
            altimetre_i           => altimetre_i,
            hedef_yukseklik_i     => hedef_yukseklik_i,
            yukseklik_bilgisi_i   => yukseklik_bilgisi_i,
            motor_o               => motor_o,
            yesil_led_o           => yesil_led_o,
            kirmizi_led_o         => kirmizi_led_o
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
        
        gnss_i              <= (others => '0');
        altimetre_i         <= (others => '0');
        hedef_yukseklik_i   <= "00000000";
        yukseklik_bilgisi_i <= '0';
        
        
        rst_n <= '0';
        wait for CLK_PERIOD;
        rst_n <= '1';
        wait for CLK_PERIOD;
        
        
        
        assert false
            report "SIM DONE"
            severity failure;   
    end process;

end testbench;
