library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_ornek1 is
    Port (
        clk       : in  STD_LOGIC;
        rst_n     : in  STD_LOGIC;
        anahtar_i : in  STD_LOGIC;
        kirmizi_o : out STD_LOGIC;
        yesil_o   : out STD_LOGIC
    );
end fsm_ornek1;

architecture Behavioral of fsm_ornek1 is
    constant kat0 : STD_LOGIC := '0';
    constant kat1 : STD_LOGIC := '1';

    signal kat   : STD_LOGIC;
    signal kirmizi, yesil : STD_LOGIC;

begin
    process(clk, rst_n)
    begin
        if rst_n = '1' then
            kat <= kat0;
        elsif rising_edge(clk) then
            case kat is
                when kat0 =>
                    if anahtar_i = '0' then
                        kat <= kat0;
                    else
                        kat <= kat1;
                    end if;
                when kat1 =>
                    if anahtar_i = '0' then
                        kat <= kat0;
                    else
                        kat <= kat1;
                    end if;
                when others =>
                    kat <= kat0;
            end case;
        end if;
    end process;

    process(kat, anahtar_i)
    begin
        if kat = kat0 then
            kirmizi <= '1';
            yesil   <= '0';
        else
            kirmizi <= '0';
            yesil   <= '1';
        end if;
    end process;

    kirmizi_o <= kirmizi;
    yesil_o   <= yesil;

end Behavioral;