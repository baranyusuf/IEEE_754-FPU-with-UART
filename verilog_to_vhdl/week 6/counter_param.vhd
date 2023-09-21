library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter_param is
  Generic (
    N : integer := 8
  );
  Port (
    clk : in  STD_LOGIC;
    rst_n : in  STD_LOGIC;
    count_o : out STD_LOGIC_VECTOR(N-1 downto 0)
  );
end counter_param;

architecture Behavioral of counter_param is
  signal count : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
begin
  process(clk, rst_n)
  begin
    if rst_n = '1' then
      count <= (others => '0');
    elsif rising_edge(clk) then
      count <= count +1;
    end if;
  end process;
  
  count_o <= count;
end Behavioral;
