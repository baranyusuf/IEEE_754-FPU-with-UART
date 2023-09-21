library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter_2bit is
    port( 
        clk : in std_logic ;
        rst_n : in std_logic;
        count_o : out std_logic_vector(1 downto 0)
    );
end counter_2bit;

architecture Behavioral of counter_2bit is
    signal count : std_logic_vector(1 downto 0);
    
begin 
    process (clk, rst_n) begin
        if rst_n = '1' then
            count <= "00";
        else  
            if rising_edge(clk) then
                count <= count + 1;
            end if;
        end if;
    end process;
    count_o <= count;

end Behavioral;
