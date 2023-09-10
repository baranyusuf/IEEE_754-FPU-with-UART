library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_top is
generic (
c_clkfreq		: integer := 100_000_000;
c_baudrate		: integer := 115_200
);
end tb_top;

architecture Behavioral of tb_top is 

component top
generic (
c_clkfreq		: integer := 100_000_000;
byte_number 	: integer := 11
);
port (
clk				: in std_logic;
pc_to_fpga		: in std_logic;
fpga_to_pc		: out std_logic;
error_o 		: out std_logic
);
end component;

constant CLOCK_PERIOD 	: time 		:= 10 ns; 

type my_array_type is array(0 to 10) of std_logic_vector(7 downto 0);
signal my_array : my_array_type := (others => (others => '0'));
signal s_clk 			: std_logic 		:= '0';
signal s_pc_to_fpga 	: std_logic 		:= '1';
signal s_fpga_to_pc 	: std_logic 		:= '1';
signal s_error_o 		: std_logic 		:= '0';
signal s_sim_packet 	: std_logic_vector (87 downto 0 ) := (others => '0');
constant c_bittimerlim 	: integer 			:= c_clkfreq/c_baudrate;  


begin  

TBU : top 
port map (
clk	    	 =>	s_clk,
pc_to_fpga	 => s_pc_to_fpga,
fpga_to_pc	 => s_fpga_to_pc,
error_o      => s_error_o
); 

process begin
        s_clk <= '0';
        wait for 5 ns;
        s_clk <= '1';
        wait for 5 ns;
    end process;

process begin
    
    wait for CLOCK_PERIOD * c_bittimerlim*10 ;


	s_sim_packet <= x"BA5041A00000423B3333DB";                    ---ASSIGN--- --BA (HEADER)---00(+)---20---46.8---DB---	
	wait for CLOCK_PERIOD;
	my_array (0) <= s_sim_packet (87 downto 80 ); 
	my_array (1) <= s_sim_packet (79 downto 72 );
	my_array (2) <= s_sim_packet (71 downto 64 );
	my_array (3) <= s_sim_packet (63 downto 56 );
	my_array (4) <= s_sim_packet (55 downto 48 );
	my_array (5) <= s_sim_packet (47 downto 40 );
	my_array (6) <= s_sim_packet (39 downto 32 );
	my_array (7) <= s_sim_packet (31 downto 24 );
	my_array (8) <= s_sim_packet (23 downto 16 );
	my_array (9) <= s_sim_packet (15 downto 8 );
	my_array (10) <= s_sim_packet (7 downto 0 ); 
	
	s_pc_to_fpga <= '1';
	wait for c_bittimerlim * CLOCK_PERIOD;   ---WAIT---
	
	
	for a in 0 to 10 loop
		s_pc_to_fpga <= '0';
		wait for c_bittimerlim * CLOCK_PERIOD;
			for b in 0 to 7 loop
				s_pc_to_fpga <= my_array(a)(b);
				wait for c_bittimerlim * CLOCK_PERIOD;      ---SENT---
	    	end loop;
	    s_pc_to_fpga <= '1';
		wait for c_bittimerlim * CLOCK_PERIOD;
	end loop;
	
	
 	wait for c_bittimerlim * CLOCK_PERIOD*100;      ---WAITING---
   
ASSERT FALSE
REPORT "SIM DONE"              --SIM ENDED--
SEVERITY FAILURE;   
   
end process;    
   
end Behavioral;
