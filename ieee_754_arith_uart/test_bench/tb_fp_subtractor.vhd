library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
 
entity fp_subtractor_tb is
end fp_subtractor_tb;
 
architecture behavior of fp_subtractor_tb is 
	 
component fp_subtractor is
  port(A_sbtr      : in  std_logic_vector(31 downto 0);
       B_sbtr      : in  std_logic_vector(31 downto 0);
       clk    : in  std_logic;
       reset_sbtr  : in  std_logic;
       start_sbtr  : in  std_logic;
       done_sbtr   : out std_logic;
       sum_sbtr : out std_logic_vector(31 downto 0)
       );
end component;	 
	 
signal tb_Reset : std_logic := '0';
signal tb_Clock : std_logic := '0';
signal tb_start : std_logic := '0';
signal tb_A, tb_B : std_logic_vector(31 downto 0):= (others => '0');
signal tb_done : std_logic;
signal tb_sum : std_logic_vector(31 downto 0);



-- Clock period definitions
constant period : time := 10 ns;    

begin

	-- Instantiate the Unit Under Test (UUT)
	uut: fp_subtractor 
		PORT MAP (
	   A_sbtr       => tb_A,
       B_sbtr       => tb_B,
       clk          => tb_Clock,
       reset_sbtr   => tb_Reset,
       start_sbtr   => tb_start,
       done_sbtr    => tb_done,
       sum_sbtr     => tb_sum
       );
  
		
  --  Test Bench Statements
	process is	
	begin
		tb_Clock <= '0';
		wait for period/2;
		tb_Clock <= '1';
		wait for period/2;
	end process; 
	
	STIMULI : process begin 
	wait until rising_edge(tb_Clock);
	wait for 10 * period;
  	tb_start <= '1';
	
  	tb_A <= "10111111100000011000000000000000";
  	tb_B <= "00111011110001001000000000000000"; 
  	wait for period;
  	tb_Reset <= '1';
	 
	 
	
	wait for period ;
	tb_reset <= '0';
	wait for period;
	tb_start <= '0';
	wait for period*5;
	tb_start <= '1';
	tb_A <= "11010010101010011001100010011010";
  	tb_B <= "11001101000001100110011101100110"; 
  	wait for 5* period;
	wait for 1* period;
	
	
	assert false
	report "SIM DONE"
	SEVERITY FAILURE;
		            
	end process;  
		
	
end;