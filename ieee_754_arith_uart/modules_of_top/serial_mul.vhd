library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library work;
use work.fpupack.all;

entity serial_mul is
	port(
			 clk_i 			  	: in std_logic;
			 fracta_i			: in std_logic_vector(FRAC_WIDTH downto 0); -- hidden(1) & fraction(23)
			 fractb_i			: in std_logic_vector(FRAC_WIDTH downto 0);
			 signa_i 			: in std_logic;
			 signb_i 			: in std_logic;
			 start_i			: in std_logic;
			 fract_o			: out std_logic_vector(2*FRAC_WIDTH+1 downto 0);
			 sign_o 			: out std_logic;
			 ready_o			: out std_logic
			 );
end serial_mul;

architecture rtl of serial_mul is

type t_state is (waiting,busy);

signal s_fract_o: std_logic_vector(47 downto 0);

signal s_fracta_i, s_fractb_i : std_logic_vector(23 downto 0);
signal s_signa_i, s_signb_i, s_sign_o : std_logic;
signal s_start_i, s_ready_o : std_logic;
signal s_state : t_state;
signal s_count : integer range 0 to 23;
signal s_tem_prod : std_logic_vector(23 downto 0);

begin

-- Input Register
process(clk_i)
begin
	if rising_edge(clk_i) then	
		s_fracta_i <= fracta_i;
		s_fractb_i <= fractb_i;
		s_signa_i<= signa_i;
		s_signb_i<= signb_i;
		s_start_i <= start_i;
	end if;
end process;	

-- Output Register
process(clk_i)
begin
	if rising_edge(clk_i) then	
		fract_o <= s_fract_o;
		sign_o <= s_sign_o;	
		ready_o <= s_ready_o;
	end if;
end process;

s_sign_o <= signa_i xor signb_i;

-- FSM
process(clk_i)
begin
	if rising_edge(clk_i) then
		if s_start_i ='1' then
			s_state <= busy;
			s_count <= 0;
		elsif s_count=23 then
			s_state <= waiting;
			s_ready_o <= '1';
			s_count <=0;
		elsif s_state=busy then
			s_count <= s_count + 1;
		else
			s_state <= waiting;
			s_ready_o <= '0';
		end if;
	end if;	
end process;

g1: for i in 0 to 23 generate
	s_tem_prod(i) <= s_fracta_i(i) and s_fractb_i(s_count);
end generate;	

process(clk_i)
variable v_prod_shl : std_logic_vector(47 downto 0);
begin
	if rising_edge(clk_i) then
		if s_state=busy then
			v_prod_shl := shl(conv_std_logic_vector(0,24)&s_tem_prod, conv_std_logic_vector(s_count,5));
			if s_count /= 0 then
				s_fract_o <= v_prod_shl + s_fract_o;
			else	
				s_fract_o <= v_prod_shl;
			end if;
		end if;
	end if;	
end process;

end rtl;

