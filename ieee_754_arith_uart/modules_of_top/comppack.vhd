library  ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.fpupack.all;

package comppack is

	
	component pre_norm_addsub is
	port(clk_i 			: in std_logic;
			 opa_i			: in std_logic_vector(31 downto 0);
			 opb_i			: in std_logic_vector(31 downto 0);
			 fracta_28_o		: out std_logic_vector(27 downto 0);
			 fractb_28_o		: out std_logic_vector(27 downto 0);
			 exp_o			: out std_logic_vector(7 downto 0));
	end component;
	
	component addsub_28 is
	port(clk_i 			  : in std_logic;
			 fpu_op_i		   : in std_logic;
			 fracta_i			: in std_logic_vector(27 downto 0); 
			 fractb_i			: in std_logic_vector(27 downto 0);
			 signa_i 			: in std_logic;
			 signb_i 			: in std_logic;
			 fract_o			: out std_logic_vector(27 downto 0);
			 sign_o 			: out std_logic);
	end component;
	
	component post_norm_addsub is
	port(clk_i 				: in std_logic;
			 opa_i 				: in std_logic_vector(31 downto 0);
			 opb_i 				: in std_logic_vector(31 downto 0);
			 fract_28_i		: in std_logic_vector(27 downto 0);	
			 exp_i			  : in std_logic_vector(7 downto 0);
			 sign_i			  : in std_logic;
			 fpu_op_i			: in std_logic;
			 rmode_i			: in std_logic_vector(1 downto 0);
			 output_o			: out std_logic_vector(31 downto 0);
			 ine_o				: out std_logic
		);
	end component;
	

	
	component pre_norm_mul is
	port(
			 clk_i		  : in std_logic;
			 opa_i			: in std_logic_vector(31 downto 0);
			 opb_i			: in std_logic_vector(31 downto 0);
			 exp_10_o			: out std_logic_vector(9 downto 0);
			 fracta_24_o		: out std_logic_vector(23 downto 0);	
			 fractb_24_o		: out std_logic_vector(23 downto 0)
		);
	end component;
	
	component mul_24 is
	port(
			 clk_i 			  : in std_logic;
			 fracta_i			: in std_logic_vector(23 downto 0); 
			 fractb_i			: in std_logic_vector(23 downto 0);
			 signa_i 			: in std_logic;
			 signb_i 			: in std_logic;
			 start_i			: in std_logic;
			 fract_o			: out std_logic_vector(47 downto 0);
			 sign_o 			: out std_logic;
			 ready_o			: out std_logic
			 );
	end component;
	
	component serial_mul is
	port(
			 clk_i 			  	: in std_logic;
			 fracta_i			: in std_logic_vector(FRAC_WIDTH downto 0);
			 fractb_i			: in std_logic_vector(FRAC_WIDTH downto 0);
			 signa_i 			: in std_logic;
			 signb_i 			: in std_logic;
			 start_i			: in std_logic;
			 fract_o			: out std_logic_vector(2*FRAC_WIDTH+1 downto 0);
			 sign_o 			: out std_logic;
			 ready_o			: out std_logic
			 );
	end component;
	
	component post_norm_mul is
	port(
			 clk_i		  		: in std_logic;
			 opa_i					: in std_logic_vector(31 downto 0);
			 opb_i					: in std_logic_vector(31 downto 0);
			 exp_10_i			: in std_logic_vector(9 downto 0);
			 fract_48_i		: in std_logic_vector(47 downto 0);	
			 sign_i					: in std_logic;
			 rmode_i			: in std_logic_vector(1 downto 0);
			 output_o				: out std_logic_vector(31 downto 0);
			 ine_o					: out std_logic
		);
	end component;
	
	
	component pre_norm_div is
	port(
			 clk_i		  	: in std_logic;
			 opa_i			: in std_logic_vector(FP_WIDTH-1 downto 0);
			 opb_i			: in std_logic_vector(FP_WIDTH-1 downto 0);
			 exp_10_o		: out std_logic_vector(EXP_WIDTH+1 downto 0);
			 dvdnd_50_o		: out std_logic_vector(2*(FRAC_WIDTH+2)-1 downto 0); 
			 dvsor_27_o		: out std_logic_vector(FRAC_WIDTH+3 downto 0)
		);
	end component;
	
	component serial_div is
	port(
			 clk_i 			  	: in std_logic;
			 dvdnd_i			: in std_logic_vector(2*(FRAC_WIDTH+2)-1 downto 0);
			 dvsor_i			: in std_logic_vector(FRAC_WIDTH+3 downto 0);
			 sign_dvd_i 		: in std_logic;
			 sign_div_i 		: in std_logic;
			 start_i			: in std_logic;
			 ready_o			: out std_logic;
			 qutnt_o			: out std_logic_vector(FRAC_WIDTH+3 downto 0);
			 rmndr_o			: out std_logic_vector(FRAC_WIDTH+3 downto 0);
			 sign_o 			: out std_logic;
			 div_zero_o			: out std_logic
			 );
	end component;	
	
	component post_norm_div is
	port(
			 clk_i		  		: in std_logic;
			 opa_i				: in std_logic_vector(FP_WIDTH-1 downto 0);
			 opb_i				: in std_logic_vector(FP_WIDTH-1 downto 0);
			 qutnt_i			: in std_logic_vector(FRAC_WIDTH+3 downto 0);
			 rmndr_i			: in std_logic_vector(FRAC_WIDTH+3 downto 0);
			 exp_10_i			: in std_logic_vector(EXP_WIDTH+1 downto 0);
			 sign_i				: in std_logic;
			 rmode_i			: in std_logic_vector(1 downto 0);
			 output_o			: out std_logic_vector(FP_WIDTH-1 downto 0);
			 ine_o				: out std_logic
		);
	end component;	
	
	
	
	
	component pre_norm_sqrt is
		port(
			 clk_i		  : in std_logic;
			 opa_i			: in std_logic_vector(31 downto 0);
			 fracta_52_o		: out std_logic_vector(51 downto 0);
			 exp_o				: out std_logic_vector(7 downto 0));
	end component;
	
	component sqrt is
		generic	(RD_WIDTH: integer; SQ_WIDTH: integer); 
		port(
			 clk_i 			 : in std_logic;
			 rad_i			: in std_logic_vector(RD_WIDTH-1 downto 0); 
			 start_i			: in std_logic;
			 ready_o			: out std_logic;
			 sqr_o			: out std_logic_vector(SQ_WIDTH-1 downto 0);
			 ine_o			: out std_logic);
	end component;
	
	
	component post_norm_sqrt is
	port(	 clk_i		  		: in std_logic;
			 opa_i					: in std_logic_vector(31 downto 0);
			 fract_26_i		: in std_logic_vector(25 downto 0);
			 exp_i				: in std_logic_vector(7 downto 0);
			 ine_i				: in std_logic;
			 rmode_i			: in std_logic_vector(1 downto 0);
			 output_o				: out std_logic_vector(31 downto 0);
			 ine_o					: out std_logic);
	end component;
	
		
end comppack;