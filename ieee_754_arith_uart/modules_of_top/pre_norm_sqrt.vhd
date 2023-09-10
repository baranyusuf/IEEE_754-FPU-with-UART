library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

library work;
use work.fpupack.all;

entity pre_norm_sqrt is
	port(
			 clk_i		  	: in std_logic;
			 opa_i			: in std_logic_vector(FP_WIDTH-1 downto 0);
			 fracta_52_o	: out std_logic_vector(2*(FRAC_WIDTH+3)-1 downto 0);
			 exp_o			: out std_logic_vector(EXP_WIDTH-1 downto 0)
		);
end pre_norm_sqrt;

architecture rtl of pre_norm_sqrt is

signal s_expa : std_logic_vector(EXP_WIDTH-1 downto 0);
signal s_exp_o, s_exp_tem : std_logic_vector(EXP_WIDTH downto 0);
signal s_fracta : std_logic_vector(FRAC_WIDTH-1 downto 0);
signal s_fracta_24 : std_logic_vector(FRAC_WIDTH downto 0);
signal s_fracta_52_o, s_fracta1_52_o, s_fracta2_52_o : std_logic_vector(2*(FRAC_WIDTH+3)-1 downto 0);
signal s_sqr_zeros_o : std_logic_vector(5 downto 0);


signal s_opa_dn : std_logic;

begin

	s_expa <= opa_i(30 downto 23);
	s_fracta <= opa_i(22 downto 0);


	exp_o <= s_exp_o(7 downto 0);
	fracta_52_o <= s_fracta_52_o;	

	-- opa or opb is denormalized
	s_opa_dn <= not or_reduce(s_expa);
	
	s_fracta_24 <= (not s_opa_dn) & s_fracta;
	
	-- count leading zeros
	s_sqr_zeros_o <= count_l_zeros(s_fracta_24 ); 
	
	-- adjust the exponent
	s_exp_tem <= ("0"&s_expa)+"001111111" - ("000"&s_sqr_zeros_o);
	
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			if or_reduce(opa_i(30 downto 0))='1' then
				s_exp_o <= ("0"&s_exp_tem(8 downto 1)); 
			else 
				s_exp_o <= "000000000";
			end if;
		end if;
	end process;

	-- left-shift the radicand	
	s_fracta1_52_o <= shl(s_fracta_24, s_sqr_zeros_o) & "0000000000000000000000000000";
	s_fracta2_52_o <= '0' & shl(s_fracta_24, s_sqr_zeros_o) & "000000000000000000000000000";
	
	s_fracta_52_o <= s_fracta1_52_o when s_expa(0)='0' else s_fracta2_52_o; 

end rtl;
