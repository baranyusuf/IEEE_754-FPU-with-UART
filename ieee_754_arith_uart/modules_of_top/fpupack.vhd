library  ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package fpupack is


	-- Data width of floating-point number. Deafult: 32
	constant FP_WIDTH : integer := 32;
	
	-- Data width of fraction. Deafult: 23
	constant FRAC_WIDTH : integer := 23;
	
	-- Data width of exponent. Deafult: 8
	constant EXP_WIDTH : integer := 8;

	--Zero vector
	constant ZERO_VECTOR: std_logic_vector(30 downto 0) := "0000000000000000000000000000000";
	
	-- Infinty FP format
	constant INF  : std_logic_vector(30 downto 0) := "1111111100000000000000000000000";
	
	-- QNaN (Quit Not a Number) FP format (without sign bit)
    constant QNAN : std_logic_vector(30 downto 0) := "1111111110000000000000000000000";
    
    -- SNaN (Signaling Not a Number) FP format (without sign bit)
    constant SNAN : std_logic_vector(30 downto 0) := "1111111100000000000000000000001";
    
    -- count the  zeros starting from left
    function count_l_zeros (signal s_vector: std_logic_vector) return std_logic_vector;
    
    -- count the zeros starting from right
	function count_r_zeros (signal s_vector: std_logic_vector) return std_logic_vector;
    
end fpupack;

package body fpupack is
    
    -- count the  zeros starting from left
	function count_l_zeros (signal s_vector: std_logic_vector) return std_logic_vector is
		variable v_count : std_logic_vector(5 downto 0);	
	begin
		v_count := "000000";
		for i in s_vector'range loop
			case s_vector(i) is
				when '0' => v_count := v_count + "000001";
				when others => exit;
			end case;
		end loop;
		return v_count;	
	end count_l_zeros;


	-- count the zeros starting from right
	function count_r_zeros (signal s_vector: std_logic_vector) return std_logic_vector is
		variable v_count : std_logic_vector(5 downto 0);	
	begin
		v_count := "000000";
		for i in 0 to s_vector'length-1 loop
			case s_vector(i) is
				when '0' => v_count := v_count + "000001";
				when others => exit;
			end case;
		end loop;
		return v_count;	
	end count_r_zeros;


		
end fpupack;