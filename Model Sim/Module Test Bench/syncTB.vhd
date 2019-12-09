LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- Entity Declaration 
ENTITY SYNC_TB IS
END SYNC_TB;
-- Architecture Declaration
ARCHITECTURE behavior OF SYNC_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT SYNC
    PORT(
      CLR    : IN std_logic; -- D
      CLK    : IN std_logic; -- CLOCK
      RESET  : IN std_logic; -- Active High Reset
      RES    : OUT std_logic -- Output
        );
    END COMPONENT;

   --Inputs
   signal CLK_s : std_logic := '0';
   signal CLR_s : std_logic := '0';
   signal RESET_s : std_logic := '0';
 	--Outputs
   signal RES_s : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SYNC PORT MAP (
          CLK => CLK_s,
          CLR => CLR_s,
		  RESET => RESET_s,
          RES => RES_s
        );
		  
	
   -- Clock process definitions
   CLK_process :process
   begin
		CLK_s <= '0';
		wait for CLK_period/2;
		CLK_s <= '1';
		wait for CLK_period/2;
   end process;
   
   CLR_process :process
   begin
		CLR_s <= '0';
		wait for 500 ns;
		CLR_s <= '1';
		wait for 50 ns;
   end process;
-- END
END;