library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity top is
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
end top;

architecture Behavioral of top is
 
-- Component declarations--

COMPONENT fp_adder is
  port(A      : in  std_logic_vector(31 downto 0);
       B      : in  std_logic_vector(31 downto 0);
       clk    : in  std_logic;
       reset  : in  std_logic;
       start  : in  std_logic;
       done   : out std_logic;
       sum 	  : out std_logic_vector(31 downto 0)
       );
end COMPONENT;

COMPONENT fp_subtractor is
  port(A_sbtr      : in  std_logic_vector(31 downto 0);
       B_sbtr      : in  std_logic_vector(31 downto 0);
       clk         : in  std_logic;
       reset_sbtr  : in  std_logic;
       start_sbtr  : in  std_logic;
       done_sbtr   : out std_logic;
       sum_sbtr    : out std_logic_vector(31 downto 0)
       );
end COMPONENT;

COMPONENT fp_multiplier is
    Port ( x : in  STD_LOGIC_VECTOR (31 downto 0);
           y : in  STD_LOGIC_VECTOR (31 downto 0);
           z : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT; 

COMPONENT fpu is
    port (
        clk_i 			: in std_logic;
        opa_i        	: in std_logic_vector(31 downto 0);  
        opb_i           : in std_logic_vector(31 downto 0);
        fpu_op_i		: in std_logic_vector(2 downto 0);
        rmode_i 		: in std_logic_vector(1 downto 0);
        output_o        : out std_logic_vector(31 downto 0);
        start_i			: in std_logic; 
        ready_o 		: out std_logic;
        ine_o 			: out std_logic;
        overflow_o  	: out std_logic;
        underflow_o 	: out std_logic;
        div_zero_o  	: out std_logic;
        inf_o			: out std_logic;
        zero_o			: out std_logic;
        qnan_o			: out std_logic;
        snan_o			: out std_logic 
	);   
end COMPONENT;

COMPONENT uart_rx is
port (
clk				: in std_logic;
rx_i			: in std_logic;
dout_o			: out std_logic_vector (7 downto 0);
rx_done_tick_o	: out std_logic
);
end component;

component uart_tx is
generic (
c_clkfreq		: integer := 100_000_000;
c_baudrate		: integer := 115_200;
c_stopbit		: integer := 2
);
port (
clk				: in std_logic;
din_i			: in std_logic_vector (7 downto 0);
tx_start_i		: in std_logic;
tx_o			: out std_logic;
tx_done_tick_o	: out std_logic
);
end component;

----------------------------------------------------------------------------------------
   
-- Sıgnal and Type declarations--   
   
type states is (S_IDL,S_RX, S_OP, S_TX);
type operator is (S_FAIL ,S_ADD, S_SUB, S_MUL, S_DIV); 
                                     
signal state : states := S_IDL;                                              
signal s_received : std_logic_vector (7 downto 0) := (others => '0');        
signal s_rx_done_tick  : std_logic := '0';                                   
signal packet : std_logic_vector ( 87 downto 0 ) := (others => '0');         
signal rc_byte_cntr : std_logic_vector (3 downto 0 ) := (others => '0');                           
signal s_operator : operator := S_ADD ;                                     
signal s_header : std_logic_vector ( 7 downto 0) := (others => '0');         
signal s_footer : std_logic_vector ( 7 downto 0) := (others => '0');         
signal s_operator_select : std_logic_vector ( 7 downto 0) := "11111111";
signal s_float_1 : std_logic_vector (31 downto 0 ) := (others => '0');
signal s_float_2 : std_logic_vector (31 downto 0 ) := (others => '0');
signal s_reset_adder : std_logic := '0';
signal s_start_adder : std_logic := '0';
signal s_done_adder : std_logic := '0';
signal s_result : std_logic_vector (31 downto 0 ) := (others => '0');
signal s_adder_counter : std_logic_vector (7 downto 0 ) := (others => '0');          
signal s_result_adder : std_logic_vector ( 31 downto 0 ) := (others => '0');
signal s_reset_subtractor : std_logic := '0';
signal s_start_subtractor : std_logic := '0';
signal s_result_subtractor : std_logic_vector (31 downto 0) := (others => '0');
signal s_done_subtractor : std_logic := '0';
signal s_subtractor_counter : std_logic_vector (7 downto 0) := ( others => '0');                                             
signal s_result_multiplier : std_logic_vector (31 downto 0 ) := (others => '0');
signal s_multiplier_counter : std_logic_vector ( 7 downto 0 ) := (others => '0');    
signal s_division_selecter : std_logic_vector ( 2 downto 0 ) := "011";
signal s_division_round : std_logic_vector ( 1 downto 0 ) := "00";
signal s_result_division : std_logic_vector ( 31 downto 0 ) := (others => '0');
signal s_start_division : std_logic := '0';
signal s_done_division : std_logic := '0'; 
signal s_division_counter : std_logic_vector (7 downto 0 ) := (others => '0');       
signal s_division_temp : std_logic_vector ( 31 downto 0 ) := (others => '0');
signal s_start_division_stim : std_logic := '0'; 
signal s_data_tx : std_logic_vector (47 downto 0 ) := (others => '0');
signal s_tx_byte_counter : std_logic_vector (3 downto 0 ) := (others => '0');        
signal s_uart_tx : std_logic_vector (7 downto 0 ) := (others => '0');
signal s_tx_done : std_logic := '0';
signal s_tx_start : std_logic := '0'; 
signal s_tx_delay : integer := 0; 
signal s_tx_start_counter : integer := 0;        
signal s_ine_o 	       : std_logic := '0';                                        
signal s_overflow_o    : std_logic := '0';                                        
signal s_underflow_o   : std_logic := '0';                                        
signal s_div_zero_o    : std_logic := '0';                                        
signal s_inf_o	       : std_logic := '0';                                        
signal s_zero_o	       : std_logic := '0';                                        
signal s_qnan_o	       : std_logic := '0';                                        
signal s_snan_o	       : std_logic := '0';                                        

----------------------------------------------------------------------------------------

begin

-- Component instantiations--

ADDER : fp_adder
port map (
	   A      => s_float_1,
       B      => s_float_2,
       clk    => clk,
       reset  => s_reset_adder,
       start  => s_start_adder,
       done   => s_done_adder,
       sum    => s_result_adder
       );

SUBTRACTOR : fp_subtractor
port map ( 
	   A_sbtr      => s_float_1,
       B_sbtr      => s_float_2,
       clk         => clk,
       reset_sbtr  => s_reset_subtractor,
       start_sbtr  => s_start_subtractor,
       done_sbtr   => s_done_subtractor,
       sum_sbtr    => s_result_subtractor
       );
       
MULTIPLIER : fp_multiplier
port map ( 
	  x => s_float_1,
      y => s_float_2,
      z =>  s_result_multiplier
      ); 
           
DIVIDER : fpu
port map (
      clk_i 		=> clk, 
      opa_i  		=> s_float_1,
      opb_i  		=> s_float_2,
      fpu_op_i  	=> s_division_selecter,
      rmode_i 		=> s_division_round,  
      output_o    	=> s_result_division,
      start_i	 	=> s_start_division,
      ready_o 		=> s_done_division,
      ine_o 		=> s_ine_o,    		
      overflow_o  	=> s_overflow_o,
      underflow_o 	=> s_underflow_o,
      div_zero_o  	=> s_div_zero_o,
      inf_o			=> s_inf_o,
      zero_o		=> s_zero_o,
      qnan_o		=> s_qnan_o,
      snan_o		=> s_snan_o
      );
                               

RECEIVER : uart_rx
port map ( 
      clk 				=> clk,				
      rx_i				=> pc_to_fpga,		
	  dout_o	   		=> s_received,		
	  rx_done_tick_o 	=> s_rx_done_tick
	  ); 

TRANSMITTER : uart_tx
port map(
      clk		 		=> clk,
      din_i	  			=> s_uart_tx,
      tx_start_i		=> s_tx_start,
      tx_o		 		=> fpga_to_pc,
      tx_done_tick_o	=> s_tx_done
	  );

----------------------------------------------------------------------------------------

--MAIN PROCESS--   

process (clk) begin
if rising_edge(clk) then 
	case state  is 
 
 when S_IDL =>
 	
 	s_tx_start_counter <= 0;
 	s_tx_delay <= 0;
 	error_o <= '0'; 
 	s_operator <= S_ADD;
   	if s_received = x"BA" then
		state <= S_RX;
	end if; 
 

 
 when S_RX =>
 	packet (87 downto 80) <= x"BA";
 	
 	if rc_byte_cntr = (byte_number  ) then
 		
 		state <= S_OP;
 	  	s_header <= packet (87 downto 80);
 	  	s_operator_select <= packet(79 downto 72);
 		s_footer <= packet (7 downto 0);
 	else	
 	
 	if s_rx_done_tick = '1' then
 	
 		packet  <=  packet (79 downto 0) & s_received ;
 		rc_byte_cntr <= rc_byte_cntr + 1;
 		
 	end if;		
 	 	
 	end if;
 when S_OP =>
 
 	case s_operator_select is
         when x"00" =>
              s_operator <= S_ADD;
         when x"01" =>
              s_operator <= S_SUB;
         when x"02" =>
              s_operator <= S_MUL;
         when x"03" =>
              s_operator <= S_DIV;
         when others =>
         	 s_operator <= S_FAIL;
         end case;	 
 	
 	 
 
 	case s_operator is 
 	
 		when S_FAIL =>
 	  	state <= S_IDL;                             
 		rc_byte_cntr <= (others => '0');                                   
 		s_adder_counter <= (others => '0');         
 		s_subtractor_counter <= (others => '0');    
 		s_multiplier_counter <= (others => '0');    
 		s_division_counter   <= (others => '0');                         
 		s_header  <= (others => '0');               
 		s_footer  <= (others => '0');               
 		s_tx_byte_counter <= (others => '0');       
 		error_o <= '1';                                            
 		s_ine_o 	  <= '0';                       
 		s_overflow_o  <= '0';                       
 		s_underflow_o <= '0';                       
 		s_div_zero_o  <= '0';                       
 		s_inf_o	      <= '0';                       
 		s_zero_o	  <= '0';                       
 		s_qnan_o	  <= '0';                       
 		s_snan_o	  <= '0';                       
 		

 		
 		when S_ADD => 
 		
 		s_float_1 <= packet (71 downto 40);
 		s_float_2 <= packet (39 downto 8);
 		
 		
 		if (s_adder_counter = 0)  then
 		s_start_adder <= '1';
 		s_adder_counter <= s_adder_counter + 1;
 		
 		
 		elsif (s_adder_counter = 15)  then
 		s_start_adder <= '0';
 		s_adder_counter <= s_adder_counter + 1;
 		
 		elsif (s_adder_counter = 16) then 
 		s_reset_adder <= '1'; 
 		s_adder_counter <= s_adder_counter + 1;
 		
 		elsif (s_adder_counter = 17) then 
 		s_reset_adder <= '0'; 
 		s_adder_counter <= s_adder_counter + 1;
 		
 		
 		elsif (s_adder_counter = 49)  then
 		s_result <= s_result_adder; 
 		state <= S_TX;
 		
 		else
 		s_adder_counter <= s_adder_counter + 1;
 		end if;
 		
 		when S_SUB =>
 		
 		s_float_1 <= packet (71 downto 40);
 		s_float_2 <= packet (39 downto 8);
 		
 		if (s_subtractor_counter = 1)  then
 		s_start_subtractor <= '1';
 		s_subtractor_counter <= s_subtractor_counter + 1;
 		
 		elsif (s_subtractor_counter = 15)  then
 		s_start_subtractor <= '0';
 		s_subtractor_counter <= s_subtractor_counter + 1; 
 		
 		elsif (s_subtractor_counter = 17)  then
 		
 		s_reset_subtractor <= '1';
 		s_subtractor_counter <= s_subtractor_counter + 1;
 		
 		elsif (s_subtractor_counter = 18)  then
 		
 		s_reset_subtractor <= '0';
 		s_subtractor_counter <= s_subtractor_counter + 1;
 		
 		elsif (s_subtractor_counter = 49)  then
 		s_result <= s_result_subtractor;
 		state <= S_TX;
 		
 		else
 		s_subtractor_counter <= s_subtractor_counter + 1;
 		end if;
 		
 		when S_MUL =>
 		s_float_1 <= packet (71 downto 40);
 		s_float_2 <= packet (39 downto 8);
 		if s_multiplier_counter = 49 then
 		s_result <= s_result_multiplier;
 		state <= S_TX;
 		else
 		s_multiplier_counter <= s_multiplier_counter + 1;
 		end if;
 		
 		
 		when S_DIV => 
 	
 		
 		if s_done_division = '1' then 
 		s_division_temp <= s_result_division;
 		end if;
 		
 		if s_start_division_stim = '1' then
 		s_start_division <= '1';
 		else
 		s_start_division <= '0';
 		end if;
 		
 		if s_division_counter <= 1 then
 		s_start_division_stim <= '1';
 		s_division_counter <= s_division_counter +1;
 		
 		elsif s_division_counter <= 2 then
 		s_float_1 <= packet (71 downto 40);
 		s_float_2 <= packet (39 downto 8);
 		s_division_counter <= s_division_counter +1;
 		s_start_division_stim <= '0';
 		
 		elsif s_division_counter = 49 then
 		s_result <= s_division_temp; 
 		state <= S_TX;
 		else 
 		s_division_counter <= s_division_counter +1;
 		end if;
 		
 			    
     end case;
 
 
 when S_TX => 
 
 	if s_footer = x"DB" then
 	s_data_tx <= s_header & s_result & s_footer;
 	
 	if s_tx_delay = 3 then
 	
 	
 	
 	
 	if s_tx_byte_counter = 0 then
 	s_uart_tx <= s_data_tx (47 downto 40);
    if s_tx_start_counter = 1 then
    	s_tx_start <= '1';
    	s_tx_start_counter <= s_tx_start_counter + 1;
    else 
    	s_tx_start_counter <= s_tx_start_counter + 1;
    	s_tx_start <= '0';
    end if;		
    
  	
  	
  	
 		
 	elsif s_tx_byte_counter = 1 then
 	s_uart_tx <= s_data_tx ( 39 downto 32);
 	if s_tx_start_counter = 1 then
    	s_tx_start <= '1';
    	s_tx_start_counter <= s_tx_start_counter + 1;
    else 
    	s_tx_start_counter <= s_tx_start_counter + 1;
    	s_tx_start <= '0';
    end if;
 	
  	
	
	
 	elsif s_tx_byte_counter = 2 then
 	s_uart_tx <= s_data_tx ( 31 downto 24);
 	if s_tx_start_counter = 1 then
    	s_tx_start <= '1';
    	s_tx_start_counter <= s_tx_start_counter + 1;
    else 
    	s_tx_start_counter <= s_tx_start_counter + 1;
    	s_tx_start <= '0';
    end if;
 	
    
    
    
   
 	elsif s_tx_byte_counter = 3 then
 	s_uart_tx <= s_data_tx ( 23 downto 16);
 	if s_tx_start_counter = 1 then
    	s_tx_start <= '1';
    	s_tx_start_counter <= s_tx_start_counter + 1;
    else 
    	s_tx_start_counter <= s_tx_start_counter + 1;
    	s_tx_start <= '0';
    end if;
 	
 	
 	
 	
 	
 	elsif s_tx_byte_counter = 4 then
 	s_uart_tx <= s_data_tx ( 15 downto 8);
 	if s_tx_start_counter = 1 then
    	s_tx_start <= '1';
    	s_tx_start_counter <= s_tx_start_counter + 1;
    else 
    	s_tx_start_counter <= s_tx_start_counter + 1;
    	s_tx_start <= '0';
    end if;
 
 
 
 
 	 
 	elsif s_tx_byte_counter = 5 then
 	s_uart_tx <= s_data_tx ( 7 downto 0);
 	if s_tx_start_counter = 1 then
    	s_tx_start <= '1';
    	s_tx_start_counter <= s_tx_start_counter + 1;
    else 
    	s_tx_start_counter <= s_tx_start_counter + 1;
    	s_tx_start <= '0';
    end if;
 	
 	
 	
 	
 	
 	
 	elsif s_tx_byte_counter = 6 then 
 	state <= S_IDL;
	rc_byte_cntr <= (others => '0');
	s_operator <= S_ADD;
	s_adder_counter <= (others => '0');
	s_subtractor_counter <= (others => '0');
	s_multiplier_counter <= (others => '0');
	s_division_counter   <= (others => '0');
	s_header  <= (others => '0');
	s_footer  <= (others => '0'); 
	s_tx_byte_counter <= (others => '0');
	
	s_ine_o 	  <= '0';
	s_overflow_o  <= '0';
	s_underflow_o <= '0';
	s_div_zero_o  <= '0';
	s_inf_o	      <= '0';
	s_zero_o	  <= '0';
	s_qnan_o	  <= '0';
	s_snan_o	  <= '0'; 
 	                                                                
 
     end if;
     
     if s_tx_done = '1' then
     s_tx_byte_counter <= s_tx_byte_counter +1;
     s_tx_start_counter <= 0;
     end if; 
    
    else
 	s_tx_delay <= s_tx_delay +1;
 	
 	end if;
 
 	else
 	
 	error_o <= '1';
 	state <= S_IDL;
	rc_byte_cntr <= (others => '0');
	s_operator <= S_FAIL;
	s_adder_counter <= (others => '0');
	s_subtractor_counter <= (others => '0');
	s_multiplier_counter <= (others => '0');
	s_division_counter   <= (others => '0');
	s_header  <= (others => '0');
	s_footer  <= (others => '0'); 
	s_tx_byte_counter <= (others => '0');
	
	s_ine_o 	  <= '0';
	s_overflow_o  <= '0';
	s_underflow_o <= '0';
	s_div_zero_o  <= '0';
	s_inf_o	      <= '0';
	s_zero_o	  <= '0';
	s_qnan_o	  <= '0';
	s_snan_o	  <= '0'; 
 	
 	
 	end if;
 	
                                          
 end case;
 
end if;		
end process;
----------------------------------------------------------------------------------------

end Behavioral;