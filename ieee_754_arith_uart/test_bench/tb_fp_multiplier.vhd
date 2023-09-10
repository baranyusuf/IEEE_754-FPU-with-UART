LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_fp_multiplier IS
END tb_fp_multiplier;
 
ARCHITECTURE behavior OF tb_fp_multiplier IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fp_multiplier
    PORT(
         x : IN  std_logic_vector(31 downto 0);
         y : IN  std_logic_vector(31 downto 0);
         z : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal x : std_logic_vector(31 downto 0) := (others => '0');
   signal y : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal z : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fp_multiplier PORT MAP (
          x => x,
          y => y,
          z => z
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		
		x<="01000000001000000000000000000000";--2.5
		y<="11000001000110110011001100110011";--(-9.7)
		
		wait for 10 ns;
		x<="01000000000000000000000000000000";
		y<="01000000000000000000000000000000";
		wait for 10 ns;
			assert false
	report "SIM DONE"
	SEVERITY FAILURE;
		
		--z = (2.5) * (-9.7) = -24.25
		-- z will be "11000001110000100000000000000000"
      
   end process;

END;