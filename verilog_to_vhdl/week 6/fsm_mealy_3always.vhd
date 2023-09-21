library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_mealy_3always is
  Port (
    x_i : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    clk : in STD_LOGIC;
    y_o : out STD_LOGIC
  );
end fsm_mealy_3always;

architecture Behavioral of fsm_mealy_3always is
  signal y : STD_LOGIC;
  signal A_reg, B_reg, A_next, B_next : STD_LOGIC := '0';
begin
  
  process(clk, rst_n)
  begin
    if rst_n = '1' then
      A_reg <= '0';
      B_reg <= '0';
    elsif rising_edge(clk) then
      A_reg <= A_next;
      B_reg <= B_next;
    end if;
  end process;

  process(x_i, A_reg, B_reg)
  begin
    A_next <= (A_reg and x_i) or (B_reg and x_i);
    B_next <= not A_reg and x_i;
  end process;

  process(A_reg, B_reg, x_i)
  begin
    y <= (A_reg or B_reg) and (not x_i);
  end process;

  y_o <= y;
end Behavioral;