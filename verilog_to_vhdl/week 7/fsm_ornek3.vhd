library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_ornek3 is
    Port (
        clk       : in  STD_LOGIC;
        rst_n     : in  STD_LOGIC;
        signal_i  : in  STD_LOGIC;
        detect_o  : out STD_LOGIC
    );
end fsm_ornek3;

architecture Behavioral of fsm_ornek3 is
    type state_type is (tetik_bekle, tetik_alindi, bekle);
    signal state : state_type;
    signal detect : STD_LOGIC;

begin
    process(clk, rst_n)
    begin
        if rst_n = '1' then
            state <= tetik_bekle;
        elsif rising_edge(clk) then
            case state is
                when tetik_bekle =>
                    if signal_i = '0' then
                        state <= tetik_bekle;
                    else
                        state <= tetik_alindi;
                    end if;
                when tetik_alindi =>
                    state <= bekle;
                when bekle =>
                    if signal_i = '0' then
                        state <= tetik_bekle;
                    else
                        state <= bekle;
                    end if;
                when others =>
                    state <= tetik_bekle;
            end case;
        end if;
    end process;

    process(state)
    begin
        case state is
            when tetik_bekle =>
                detect <= '0';
            when tetik_alindi =>
                detect <= '1';
            when bekle =>
                detect <= '0';
            when others =>
                detect <= '0';
        end case;
    end process;

    detect_o <= detect;

end Behavioral;