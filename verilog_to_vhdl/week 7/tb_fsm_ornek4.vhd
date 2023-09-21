library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_fsm_ornek4 is
end tb_fsm_ornek4;

architecture sim of tb_fsm_ornek4 is
    signal clk       : STD_LOGIC := '0';
    signal rst_n     : STD_LOGIC := '0';
    signal ta_i      : STD_LOGIC := '0';
    signal tb_i      : STD_LOGIC := '0';
    signal la_o      : STD_LOGIC_VECTOR(1 downto 0);
    signal lb_o      : STD_LOGIC_VECTOR(1 downto 0);

    constant clk_period : time := 10 ns; 

    component fsm_ornek4
        Port (
            clk       : in  STD_LOGIC;
            rst_n     : in  STD_LOGIC;
            ta_i      : in  STD_LOGIC;
            tb_i      : in  STD_LOGIC;
            la_o      : out STD_LOGIC_VECTOR(1 downto 0);
            lb_o      : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

begin
    uut: fsm_ornek4
        port map (
            clk       => clk,
            rst_n     => rst_n,
            ta_i      => ta_i,
            tb_i      => tb_i,
            la_o      => la_o,
            lb_o      => lb_o
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