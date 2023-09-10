library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_fpu is
end tb_fpu;

architecture tb_fpu of tb_fpu is 
 	
 	component fpu
        port (
            clk_i       : in std_logic;
            opa_i       : in std_logic_vector(31 downto 0);
            opb_i       : in std_logic_vector(31 downto 0);
            fpu_op_i    : in std_logic_vector(2 downto 0);
            rmode_i     : in std_logic_vector(1 downto 0);
            start_i     : in std_logic;
            ready_o     : out std_logic;
            output_o    : out std_logic_vector(31 downto 0);
            ine_o       : out std_logic;
            overflow_o  : out std_logic;
            underflow_o : out std_logic;
            div_zero_o  : out std_logic;
            inf_o       : out std_logic;
            zero_o      : out std_logic;
            qnan_o      : out std_logic;
            snan_o      : out std_logic
        );
    end component;




    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal opa : std_logic_vector(31 downto 0) := (others => '0');
    signal opb : std_logic_vector(31 downto 0) := (others => '0');
    signal fpu_op : std_logic_vector(2 downto 0) := "000";
    signal rmode : std_logic_vector(1 downto 0) := "00";
    signal start : std_logic := '0';

    signal ready : std_logic := '0';
    signal output : std_logic_vector(31 downto 0);
    signal ine, overflow, underflow, div_zero, inf, zero, qnan, snan : std_logic;

    constant CLOCK_PERIOD : time := 10 ns; -- Modify as needed

    -- Clock process...
    
    begin 
    fpu_inst : fpu
        port map (
            clk_i => clk,
            opa_i => opa,
            opb_i => opb,
            fpu_op_i => fpu_op,
            rmode_i => rmode,
            start_i => start,
            ready_o => ready,
            output_o => output,
            ine_o => ine,
            overflow_o => overflow,
            underflow_o => underflow,
            div_zero_o => div_zero,
            inf_o => inf,
            zero_o => zero,
            qnan_o => qnan,
            snan_o => snan
        );
    
    
    
    
    
    process begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- DUT instantiation...
    

    -- Stimulus process...
    process
    begin
        start <= '0';
        wait UNTIL rising_edge(clk);
        start <= '1'; 
        
         -- Initial delay

        opa <= "01000010100100000000000000000000"; -- 1.0 in IEEE 754 single precision format
        opb <= "01000001000100000000000000000000"; -- 0.5 in IEEE 754 single precision format
        fpu_op <= "011";    -- Add operation
        rmode <= "00";
        wait UNTIL rising_edge(clk); 
        start <= '0'; 
        wait until ready ='1'; 
        wait UNTIL rising_edge(clk);  
        start <= '1'; 
        wait UNTIL rising_edge(clk);
         -- Initial delay

        opa <= x"01010000"; -- 1.0 in IEEE 754 single precision format
        opb <= x"10100000"; -- 0.5 in IEEE 754 single precision format
        fpu_op <= "011";    -- Add operation
        rmode <= "00"; 
        wait UNTIL rising_edge(clk);
        start <= '0';
        wait until ready ='1'; 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
        wait UNTIL rising_edge(clk); 
         
        start <= '0';
		wait UNTIL rising_edge(clk);
		wait UNTIL rising_edge(clk);
		
        assert false
        report "SIM DONE"
        severity failure;
                                       
                                       

        

        

    end process;

    
    

end tb_fpu;