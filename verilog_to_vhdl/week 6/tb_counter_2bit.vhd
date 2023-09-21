library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_counter_2bit is
end tb_counter_2bit;

architecture Behavioral of tb_counter_2bit is

    component counter_2bit
        port( 
            clk : in std_logic ;
            rst_n : in std_logic;
            count_o : out std_logic_vector(1 downto 0)
        );
    end component; 
 
    signal clk : std_logic;
    signal rst_n : std_logic := '1';
    signal count_o : std_logic_vector(1 downto 0) := (others => '0');     
                 
    
begin   


    DUT : counter_2bit
    port map(
        clk => clk,
        rst_n => rst_n,
        count_o => count_o
    );  
               
    clk_process : process begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process clk_process; 

    STIMULI : process
    begin
        wait until rising_edge(clk);
        rst_n <= '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk); 
        wait until rising_edge(clk);
        rst_n <= '1';
        wait until rising_edge(clk);
        rst_n <= '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
                          
        
 
        assert false
            report "SIM DONE"
            severity failure; 
       
    end process;

end Behavioral;