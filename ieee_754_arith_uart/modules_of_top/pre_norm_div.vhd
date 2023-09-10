library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

library work;
use work.fpupack.all;

entity pre_norm_div is
	port(
			 clk_i		  	: in std_logic;
			 opa_i			: in std_logic_vector(FP_WIDTH-1 downto 0);
			 opb_i			: in std_logic_vector(FP_WIDTH-1 downto 0);
			 exp_10_o		: out std_logic_vector(EXP_WIDTH+1 downto 0);
			 dvdnd_50_o		: out std_logic_vector(2*(FRAC_WIDTH+2)-1 downto 0); 
			 dvsor_27_o		: out std_logic_vector(FRAC_WIDTH+3 downto 0)
		);
end pre_norm_div;

architecture rtl of pre_norm_div is


signal s_expa, s_expb : std_logic_vector(EXP_WIDTH-1 downto 0);
signal s_fracta, s_fractb : std_logic_vector(FRAC_WIDTH-1 downto 0);
signal s_dvdnd_50_o : std_logic_vector(2*(FRAC_WIDTH+2)-1 downto 0); 
signal s_dvsor_27_o : std_logic_vector(FRAC_WIDTH+3 downto 0); 
signal s_dvd_zeros, s_div_zeros: std_logic_vector(5 downto 0);
signal s_exp_10_o		: std_logic_vector(EXP_WIDTH+1 downto 0);

signal s_expa_in, s_expb_in	: std_logic_vector(EXP_WIDTH+1 downto 0);
signal s_opa_dn, s_opb_dn : std_logic;
signal s_fracta_24, s_fractb_24 : std_logic_vector(FRAC_WIDTH downto 0);

begin

		s_expa <= opa_i(30 downto 23);
		s_expb <= opb_i(30 downto 23);
		s_fracta <= opa_i(22 downto 0);
		s_fractb <= opb_i(22 downto 0);
		dvdnd_50_o <= s_dvdnd_50_o;
		dvsor_27_o	<= s_dvsor_27_o;
	
	-- Output Register
	process(clk_i)
	begin
		if rising_edge(clk_i) then	
			exp_10_o <= s_exp_10_o;
		end if;
	end process;
 
 
	s_opa_dn <= not or_reduce(s_expa);
	s_opb_dn <= not or_reduce(s_expb);
	
	s_fracta_24 <= (not s_opa_dn) & s_fracta;
	s_fractb_24 <= (not s_opb_dn) & s_fractb;
	
	-- count leading zeros
	s_dvd_zeros <= count_l_zeros( s_fracta_24 );
	s_div_zeros <= count_l_zeros( s_fractb_24 );
	
	-- left-shift the dividend and divisor
	s_dvdnd_50_o <= shl(s_fracta_24, s_dvd_zeros) & "00000000000000000000000000";
	s_dvsor_27_o <= "000" & shl(s_fractb_24, s_div_zeros);
	

	
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			-- pre-calculate exponent
			s_expa_in <= ("00"&s_expa) + ("000000000"&s_opa_dn);
			s_expb_in <= ("00"&s_expb) + ("000000000"&s_opb_dn);	
			s_exp_10_o <= s_expa_in - s_expb_in + "0001111111" -("0000"&s_dvd_zeros) + ("0000"&s_div_zeros);
		end if;
	end process;		
		



end rtl;
