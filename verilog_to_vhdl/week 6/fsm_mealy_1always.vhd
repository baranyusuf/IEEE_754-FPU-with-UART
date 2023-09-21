library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_mealy_1always is
  Port (
    x_i : in STD_LOGIC;
    rst_n : in STD_LOGIC ;
    clk : in STD_LOGIC;
    y_o : out STD_LOGIC
  );
end fsm_mealy_1always;

architecture Behavioral of fsm_mealy_1always is
  signal A_reg, B_reg : STD_LOGIC := '0';
begin
  process(clk, rst_n)
  begin
    if rst_n = '1' then
      A_reg <= '0';
      B_reg <= '0';
    elsif rising_edge(clk) then
      A_reg <= (A_reg and x_i) or (B_reg and x_i);
      B_reg <= (not A_reg) and x_i;
    end if;
  end process;

  y_o <= (A_reg or B_reg) and (not x_i);
end Behavioral;
