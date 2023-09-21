library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fsm_mealy_param is
end tb_fsm_mealy_param;

architecture Behavioral of tb_fsm_mealy_param is

component fsm_mealy_param is
Port (
    x_i : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    clk : in STD_LOGIC;
    y_o : out STD_LOGIC
  );
  end component;

    constant CLK_PERIOD : time := 10 ns; 
    signal x_i : std_logic := '0';   
    signal rst_n : std_logic := '1';
    signal clk : std_logic;      
    signal y_o : std_logic;
    
begin

DUT: fsm_mealy_param

port map (
            x_i => x_i,
            rst_n => rst_n,
            clk => clk,
            y_o => y_o
        );
        
clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process clk_process;
   
 stimulus_process : process begin 
 
 wait for clk_period *3;
  x_i <= '1';
 wait for clk_period * 10;
  x_i <= '0'; 
 wait for clk_period * 10; 
   x_i <= '1'; 
   wait for clk_period * 2; 
   x_i <= '0';
   wait for clk_period * 3;
   rst_n <= '1';
   wait for clk_period ;
   rst_n <= '0';
   wait for clk_period;
   x_i <= '1';
   wait for clk_period *5;
   
    
   
   
   
   
   
 assert false
        report "SIM DONE"
        severity failure;      
    end process;

end Behavioral;                