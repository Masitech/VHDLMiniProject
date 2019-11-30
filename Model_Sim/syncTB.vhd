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
         CLK : IN  std_logic; -- Clock Input
         CLR : IN  std_logic; -- Clear Input
         RES : OUT  std_logic -- Reset Output
        );
    END COMPONENT;

   --Inputs
   signal CLK : std_logic := '0';
   signal CLR : std_logic := '0';

 	--Outputs
   signal RES : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SYNC PORT MAP (
          CLK => CLK,
          CLR => CLR,
          RES => RES
        );
		  
	-- CLR
	CLR <= '0', '1' after 10 ns;
	
   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
-- END
END;