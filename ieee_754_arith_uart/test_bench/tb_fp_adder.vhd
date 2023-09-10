library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
 
entity fp_adder_tb is
end fp_adder_tb;
 
architecture behavior of fp_adder_tb is 
	 
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
	 
signal tb_Reset : std_logic := '0';
signal tb_Clock : std_logic := '0';
signal tb_start : std_logic := '0';
signal tb_A, tb_B : std_logic_vector(31 downto 0):= (others => '0');
signal tb_done : std_logic;
signal tb_sum : std_logic_vector(31 downto 0);

signal tb_fileSum : std_logic_vector(31 downto 0):= (others => '0');


-- Clock period definitions
constant period : time := 10 ns;    

begin

	-- Instantiate the Unit Under Test (UUT)
	uut: fp_adder 
		PORT MAP (
			A				=> tb_A,
			B				=> tb_B,
			reset			=> tb_Reset,
			clk				=> tb_Clock,
			start		=> tb_start,
			done		=> tb_done,

			sum	=> tb_sum
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
  	tb_start <= '1';
	
  	tb_A <= "00111111100000000000000000000000";
  	tb_B <= "00111111110000000000000000000000"; 
  	wait for period;
  	tb_Reset <= '1';
	 
	 
	
	wait for period ;
	tb_reset <= '0';
	wait for period;
	tb_start <= '0';
	wait for period*5;
	tb_start <= '1';
	tb_A <= "11000000101010011001100110011010";
  	tb_B <= "01000000000001100110011001100110"; 
  	wait for 5* period;
	wait for 1* period;
	
	
	assert false
	report "SIM DONE"
	SEVERITY FAILURE;
		            
	end process;  
		
	
end;