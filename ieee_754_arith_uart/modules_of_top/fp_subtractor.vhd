library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fp_subtractor is
  port(A_sbtr      : in  std_logic_vector(31 downto 0);
       B_sbtr      : in  std_logic_vector(31 downto 0);
       clk    : in  std_logic;
       reset_sbtr  : in  std_logic;
       start_sbtr  : in  std_logic;
       done_sbtr   : out std_logic;
       sum_sbtr : out std_logic_vector(31 downto 0)
       );
end fp_subtractor;

architecture Behavioral of fp_subtractor is
component fp_adder is
port(A      : in  std_logic_vector(31 downto 0);
       B      : in  std_logic_vector(31 downto 0);
       clk    : in  std_logic;
       reset  : in  std_logic;
       start  : in  std_logic;
       done   : out std_logic;
       sum : out std_logic_vector(31 downto 0)
       );
end component; 

signal B_sbtr_changed : std_logic_vector (31 downto 0) :=(others => '0');    

begin
B_sbtr_changed <= (not B_sbtr(31)) & B_sbtr(30 downto 0);

UUT_fp_adder : fp_adder
port map (
	   A => A_sbtr,     
       B => B_sbtr_changed,   
       clk => clk, 
       reset => reset_sbtr,
       start => start_sbtr,
       done => done_sbtr,
       sum => sum_sbtr
       );

end Behavioral;