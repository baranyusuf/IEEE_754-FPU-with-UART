---------  Fill in the constants (file names) ------------
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! --
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! --
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_txtio_top is
    generic (
        c_clkfreq       : integer := 100_000_000;
        c_baudrate      : integer := 115_200
    );
end tb_txtio_top;

architecture Behavioral of tb_txtio_top is

    component top
        generic (
            c_clkfreq       : integer := 100_000_000;
            byte_number     : integer := 11
        );
        port (
            clk             : in std_logic;
            pc_to_fpga      : in std_logic;
            fpga_to_pc      : out std_logic;
            error_o         : out std_logic
        );
    end component;
    
    component uart_rx_tb                                      
    generic (                                              
    c_clkfreq		: integer := 100_000_000;              
    c_baudrate		: integer := 115_200                   
    );                                                     
    port (                                                 
    clk				: in std_logic;                        
    rx_i			: in std_logic;                        
    dout_o			: out std_logic_vector (7 downto 0);   
    rx_done_tick_o	: out std_logic                        
    );                                                     
    end component;                                           
    
    	

    constant CLOCK_PERIOD : time := 10 ns;

    type my_array_type is array (0 to 999) of std_logic_vector(87 downto 0);
    type my_array_type_2 is array(0 to 5) of std_logic_vector(7 downto 0);
    type my_array_type_3 is array(0 to 10) of std_logic_vector(7 downto 0);
    type my_array_type_4 is array(0 to 999) of std_logic_vector ( 47 downto 0 );
    
    signal my_array : my_array_type := (others => (others => '0'));
    signal s_sim_packet 	: std_logic_vector (87 downto 0 ) := (others => '0');
    signal my_array_2 : my_array_type_2 := (others => (others => '0'));
    signal my_array_3 : my_array_type_3 := ( others => ( others => '0'));
    signal my_array_4 : my_array_type_4 := ( others => ( others => '0'));
    
    signal s_sim_write : std_logic_vector (47 downto 0 ) := (others => '0');
    signal s_received : std_logic_vector (7 downto 0 ) := (others => '0');
    signal s_rx_done : std_logic := '0';
    signal s_clk : std_logic := '0';
    signal s_pc_to_fpga : std_logic := '1';
    signal s_fpga_to_pc : std_logic := '1';
    signal s_error_o : std_logic := '0';

    constant c_bittimerlim : integer := c_clkfreq/c_baudrate;
    constant C_FILE_NAME_WR : string := "";
	constant C_FILE_NAME_RD : string := "";



begin

    TBU : top
    port map (
        clk => s_clk,
        pc_to_fpga => s_pc_to_fpga,
        fpga_to_pc => s_fpga_to_pc,
        error_o => s_error_o
    ); 
    
    
	 uart_rx_tb_inst : uart_rx_tb
	 generic map (
		 c_clkfreq     => 100_000_000,  
		 c_baudrate    => 115_200       
		         )
	 port map (
		 clk           => s_clk,      
		 rx_i          => s_fpga_to_pc,       
		 dout_o        => s_received,     
		 rx_done_tick_o => s_rx_done  
	 );
		
    
    
   process
   begin
       s_clk <= '0';
       wait for 5 ns;
       s_clk <= '1';
       wait for 5 ns;
   end process;

   STIMULI : process

       variable VEC_LINE_RD : line;
       variable VEC_VAR_RD : std_logic_vector(87 downto 0);
       file VEC_FILE_RD : text open read_mode is C_FILE_NAME_RD;
       
       variable VEC_LINE_WR : line;                             
       variable VEC_VAR_WR : std_logic_vector(47 downto 0);     
       file VEC_FILE_WR : text open write_mode is C_FILE_NAME_WR;

   begin

       for i in 0 to 9999 loop
           wait until rising_edge(s_clk);
           readline(VEC_FILE_RD, VEC_LINE_RD);
           hread(VEC_LINE_RD, VEC_VAR_RD);
           my_array(i) <= VEC_VAR_RD;
       end loop;
       
       file_close(VEC_FILE_RD);  
       
       for i in 0 to 9999 loop
       	wait until rising_edge(s_clk);
       	s_sim_packet <= my_array (i);
       	wait until rising_edge(s_clk);
        my_array_3 (0) <= s_sim_packet (87 downto 80 );	
        my_array_3 (1) <= s_sim_packet (79 downto 72 );	
        my_array_3 (2) <= s_sim_packet (71 downto 64 );	
        my_array_3 (3) <= s_sim_packet (63 downto 56 );	
        my_array_3 (4) <= s_sim_packet (55 downto 48 );	
        my_array_3 (5) <= s_sim_packet (47 downto 40 );	
        my_array_3 (6) <= s_sim_packet (39 downto 32 );	
        my_array_3 (7) <= s_sim_packet (31 downto 24 );	
        my_array_3 (8) <= s_sim_packet (23 downto 16 );	
        my_array_3 (9) <= s_sim_packet (15 downto 8 ); 	
        my_array_3 (10) <= s_sim_packet (7 downto 0 );
           for a in 0 to 10 loop  
           	s_pc_to_fpga <= '0';
           	wait for c_bittimerlim * CLOCK_PERIOD;
           	for b in 0 to 7 loop
           		s_pc_to_fpga <= my_array_3 (a)(b);
           		wait for c_bittimerlim * CLOCK_PERIOD;   		 
           	end loop;
           	s_pc_to_fpga <= '1';
           	wait for c_bittimerlim * CLOCK_PERIOD;
           end loop;
           
           for c in 0 to 5 loop
           wait until s_rx_done = '1';
           my_array_2 (c) <= s_received;
           end loop;
           
       wait for 2* CLOCK_PERIOD ;    
       s_sim_write (47 downto 40) <= my_array_2 (0);
       s_sim_write (39 downto 32) <= my_array_2 (1);
       s_sim_write (31 downto 24) <= my_array_2 (2);
       s_sim_write (23 downto 16) <= my_array_2 (3);
       s_sim_write (15 downto 8) <= my_array_2 (4);
       s_sim_write (7 downto 0) <= my_array_2 (5);
       wait until rising_edge(s_clk);
       
	   hwrite(VEC_LINE_WR, s_sim_write);
	   writeline(VEC_FILE_WR,VEC_LINE_WR);
	   	    	
       end loop;
   file_close(VEC_FILE_WR);
   
   ASSERT FALSE
   REPORT "SIM DONE"
   SEVERITY FAILURE;    
       	   	
   end process;
   
end Behavioral;