library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fsm_ornek3 is
end tb_fsm_ornek3;

architecture sim of tb_fsm_ornek3 is
    signal clk       : STD_LOGIC := '0';
    signal rst_n     : STD_LOGIC := '0';
    signal signal_i  : STD_LOGIC := '0';
    signal detect_o  : STD_LOGIC;

    constant clk_period : time := 10 ns;  

    component fsm_ornek3
        Port (
            clk       : in  STD_LOGIC;
            rst_n     : in  STD_LOGIC;
            signal_i  : in  STD_LOGIC;
            detect_o  : out STD_LOGIC
        );
    end component;

begin
    uut: fsm_ornek3
        port map (
            clk       => clk,
            rst_n     => rst_n,
            signal_i  => signal_i,
            detect_o  => detect_o
        );

    clk_process: process begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;

    end process;  
    
     sim_process: process
    begin   
          wait for 3*clk_period ;
    
        assert false
            report "SIM DONE"
            severity failure;   
    end process;
      
  

end sim;