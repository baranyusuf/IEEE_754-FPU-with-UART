library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_ornek4 is
    Port (
        clk    : in  STD_LOGIC;
        rst_n  : in  STD_LOGIC;
        ta_i   : in  STD_LOGIC;
        tb_i   : in  STD_LOGIC;
        la_o   : out STD_LOGIC_VECTOR(1 downto 0);
        lb_o   : out STD_LOGIC_VECTOR(1 downto 0)
    );
end fsm_ornek4;

architecture Behavioral of fsm_ornek4 is
    type state_type is (S0, S1, S2, S3);
    signal state : state_type;
    signal la, lb : STD_LOGIC_VECTOR(1 downto 0);

    constant green  : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant yellow : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant red    : STD_LOGIC_VECTOR(1 downto 0) := "10";

begin
    process(clk, rst_n)
    begin
        if rst_n = '1' then
            state <= S0;
        elsif rising_edge(clk) then
            case state is
                when S0 =>
                    if ta_i = '1' then
                        state <= S0;
                    else
                        state <= S1;
                    end if;
                when S1 =>
                    state <= S2;
                when S2 =>
                    if tb_i = '0' then
                        state <= S3;
                    else
                        state <= S2;
                    end if;
                when S3 =>
                    state <= S0;
                when others =>
                    state <= S0;
            end case;
        end if;
    end process;

    process(state)
    begin
        case state is
            when S0 =>
                la <= green;
                lb <= red;
            when S1 =>
                la <= yellow;
                lb <= red;
            when S2 =>
                la <= red;
                lb <= green;
            when S3 =>
                la <= red;
                lb <= yellow;
            when others =>
                la <= green;
                lb <= red;
        end case;
    end process;

    la_o <= la;
    lb_o <= lb;

end Behavioral;