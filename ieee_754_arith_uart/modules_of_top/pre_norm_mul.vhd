library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

library work;
use work.fpupack.all;

entity pre_norm_mul is
	port(
			 clk_i		  : in std_logic;
			 opa_i			: in std_logic_vector(FP_WIDTH-1 downto 0);
			 opb_i			: in std_logic_vector(FP_WIDTH-1 downto 0);
			 exp_10_o			: out std_logic_vector(EXP_WIDTH+1 downto 0);
			 fracta_24_o		: out std_logic_vector(FRAC_WIDTH downto 0);	-- hidden(1) & fraction(23)
			 fractb_24_o		: out std_logic_vector(FRAC_WIDTH downto 0)
		);
end pre_norm_mul;

architecture rtl of pre_norm_mul is

signal s_expa, s_expb : std_logic_vector(EXP_WIDTH-1 downto 0);
signal s_fracta, s_fractb : std_logic_vector(FRAC_WIDTH-1 downto 0);
signal s_exp_10_o, s_expa_in, s_expb_in : std_logic_vector(EXP_WIDTH+1 downto 0);

signal s_opa_dn, s_opb_dn : std_logic;

begin

	
		s_expa <= opa_i(30 downto 23);
		s_expb <= opb_i(30 downto 23);
		s_fracta <= opa_i(22 downto 0);
		s_fractb <= opb_i(22 downto 0);

 	-- Output Register
	process(clk_i)
	begin
		if rising_edge(clk_i) then	
			exp_10_o <= s_exp_10_o;
		end if;
	end process;
	
	-- opa or opb is denormalized
	s_opa_dn <= not or_reduce(s_expa);
	s_opb_dn <= not or_reduce(s_expb);
	
	
	fracta_24_o <= not(s_opa_dn) & s_fracta;
	fractb_24_o <= not(s_opb_dn) & s_fractb;

	s_expa_in <= ("00"&s_expa) + ("000000000"&s_opa_dn);
	s_expb_in <= ("00"&s_expb) + ("000000000"&s_opb_dn);

	

	s_exp_10_o <= s_expa_in + s_expb_in - "0001111111";		



end rtl;
