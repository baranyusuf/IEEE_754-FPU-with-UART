library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fsm_ornek1 is
end tb_fsm_ornek1;

architecture sim of tb_fsm_ornek1 is
    signal clk      : STD_LOGIC := '0';
    signal rst_n    : STD_LOGIC := '0';
    signal anahtar_i: STD_LOGIC := '0';
    signal kirmizi_o: STD_LOGIC;
    signal yesil_o  : STD_LOGIC;

    constant clk_period : time := 10 ns; 

    component fsm_ornek1
        Port (
            clk       : in  STD_LOGIC;
            rst_n     : in  STD_LOGIC;
            anahtar_i : in  STD_LOGIC;
            kirmizi_o : out STD_LOGIC;
            yesil_o   : out STD_LOGIC
        );
    end component;

begin
    uut: fsm_ornek1
        port map (
            clk       => clk,
            rst_n     => rst_n,
            anahtar_i => anahtar_i,
            kirmizi_o => kirmizi_o,
            yesil_o   => yesil_o
        );

    clk_process: process begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;

    end process;

    sim_process: process
    begin  
    anahtar_i <= '0';
    wait for clk_period; 
    wait for clk_period;
    anahtar_i <= '1';
    wait for clk_period;
    wait for clk_period;
    wait for clk_period;
    rst_n <= '1';
    wait for clk_period;
    rst_n <= '0';
    wait for clk_period;
    wait for clk_period;
    anahtar_i <= '1';
    wait for clk_period;
    wait for clk_period;
    
    

   assert false
            report "SIM DONE"
            severity failure;   
    end process;

end sim;