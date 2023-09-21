library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_fsm_mealy_3always is
end tb_fsm_mealy_3always;

architecture Behavioral of tb_fsm_mealy_3always is

    component fsm_mealy_3always
        Port (
    x_i : in STD_LOGIC;
    rst_n : in STD_LOGIC ;
    clk : in STD_LOGIC;
    y_o : out STD_LOGIC
  );
    end component; 
 
    signal x_i : STD_LOGIC := '0';   
    signal rst_n : STD_LOGIC := '1';
    signal clk : STD_LOGIC;      
    signal y_o : STD_LOGIC;
    
    begin
               


    DUT : fsm_mealy_3always
    port map(
        x_i => x_i,
        rst_n => rst_n,
        clk => clk,
        y_o => y_o
    );  
               
    clk_process : process begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process clk_process; 

    STIMULI : process begin
        wait for 10 ns;
        rst_n <= '0';
        wait for 100 ns;
        x_i <= '1';
        wait for 200 ns;
        x_i <= '0';
        wait for 50 ns;
        rst_n <= '1';
        wait for 20 ns;
                          
      
        assert false
        report "SIM DONE"
        severity failure;      
    end process;

end Behavioral;