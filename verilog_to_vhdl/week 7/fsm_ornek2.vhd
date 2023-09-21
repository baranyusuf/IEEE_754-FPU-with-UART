library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_ornek2 is
    Port (
        clk       : in  STD_LOGIC;
        rst_n     : in  STD_LOGIC;
        signal_i  : in  STD_LOGIC;
        detect_o  : out STD_LOGIC
    );
end fsm_ornek2;

architecture Behavioral of fsm_ornek2 is
    constant tetik_bekle  : STD_LOGIC := '0';
    constant tetik_alindi : STD_LOGIC := '1';

    signal state  : STD_LOGIC := '0';
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
                        state <= '0';
                    else
                        state <= '1';
                    end if;
                when tetik_alindi =>
                    if signal_i = '0' then
                        state <= '0';
                    else
                        state <= '1';
                    end if;
                when others =>
                    state <= '0';
            end case;
        end if;
    end process;

    process(state, signal_i)
    begin
        if state = tetik_bekle then
            if signal_i = '0' then
                detect <= '0';
            else
                detect <= '1';
            end if;
        else
            detect <= '0';
        end if;
    end process;

    detect_o <= detect;

end Behavioral;