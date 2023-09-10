library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use IEEE.std_logic_arith.all;

library work;
use work.fpupack.all;

entity addsub_28 is
	port(
			clk_i 			: in std_logic;
			fpu_op_i		: in std_logic;
			fracta_i		: in std_logic_vector(FRAC_WIDTH+4 downto 0);
			fractb_i		: in std_logic_vector(FRAC_WIDTH+4 downto 0);
			signa_i 		: in std_logic;
			signb_i 		: in std_logic;
			fract_o			: out std_logic_vector(FRAC_WIDTH+4 downto 0);
			sign_o 			: out std_logic);
end addsub_28;


architecture rtl of addsub_28 is

signal s_fracta_i, s_fractb_i : std_logic_vector(FRAC_WIDTH+4 downto 0);
signal s_fract_o : std_logic_vector(FRAC_WIDTH+4 downto 0);
signal s_signa_i, s_signb_i, s_sign_o : std_logic;
signal s_fpu_op_i : std_logic;

signal fracta_lt_fractb : std_logic;
signal s_addop: std_logic;

begin

		s_fracta_i <= fracta_i;
		s_fractb_i <= fractb_i;
		s_signa_i<= signa_i;
		s_signb_i<= signb_i;
		s_fpu_op_i <= fpu_op_i;
		
process(clk_i)
begin
	if rising_edge(clk_i) then	
		fract_o <= s_fract_o;
		sign_o <= s_sign_o;	
	end if;
end process;

fracta_lt_fractb <= '1' when s_fracta_i > s_fractb_i else '0';


s_addop <= ((s_signa_i xor s_signb_i)and not (s_fpu_op_i)) or ((s_signa_i xnor s_signb_i)and (s_fpu_op_i));


s_sign_o <= '0' when s_fract_o = conv_std_logic_vector(0,28) and (s_signa_i and s_signb_i)='0' else 
										((not s_signa_i) and ((not fracta_lt_fractb) and (fpu_op_i xor s_signb_i))) or
										((s_signa_i) and (fracta_lt_fractb or (fpu_op_i xor s_signb_i)));


process(s_fracta_i, s_fractb_i, s_addop, fracta_lt_fractb)
begin
	if s_addop='0' then
		s_fract_o <= s_fracta_i + s_fractb_i;
	else
		if fracta_lt_fractb = '1' then 
			s_fract_o <= s_fracta_i - s_fractb_i;
		else
			s_fract_o <= s_fractb_i - s_fracta_i;				
		end if;
	end if;
end process;




end rtl;