library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_mealy_param is
  Port (
    x_i : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    clk : in STD_LOGIC;
    y_o : out STD_LOGIC
  );
end fsm_mealy_param;

architecture Behavioral of fsm_mealy_param is
  constant S0 : STD_LOGIC_VECTOR(1 downto 0) := "00";
  constant S1 : STD_LOGIC_VECTOR(1 downto 0) := "01";
  constant S2 : STD_LOGIC_VECTOR(1 downto 0) := "10";
  constant S3 : STD_LOGIC_VECTOR(1 downto 0) := "11";

  signal y : STD_LOGIC;
  signal state : STD_LOGIC_VECTOR(1 downto 0);

begin
 
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      state <= S0;
    elsif rising_edge(clk) then
      case state is
        when S0 =>
          if x_i = '0' then
            state <= S0;
          else
            state <= S1;
          end if;
          
        when S1 =>
          if x_i = '0' then
            state <= S0;
          else
            state <= S3;
          end if;

        when S2 =>
          if x_i = '0' then
            state <= S0;
          else
            state <= S2;
          end if;

        when S3 =>
          if x_i = '0' then
            state <= S0;
          else
            state <= S2;
          end if;

        when others =>
          state <= S0;
      end case;
    end if;
  end process;


  process(state, x_i)
  begin
    case state is
      when S0 =>
        if x_i = '0' then
          y <= '0';
        else
          y <= '0';
        end if;
        
      when S1 =>
        if x_i = '0' then
          y <= '1';
        else
          y <= '0';
        end if;

      when S2 =>
        if x_i = '0' then
          y <= '1';
        else
          y <= '0';
        end if;

      when S3 =>
        if x_i = '0' then
          y <= '1';
        else
          y <= '0';
        end if;

      when others =>
        y <= '0';
    end case;
  end process;

  y_o <= y;

end Behavioral;