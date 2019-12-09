-- Author : Masum Ahmed
-- Email : Ma786@kent.ac.uk
-- Date : 04/12/2019
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- Entity Declaration 
ENTITY SYNC2_TB IS
END SYNC2_TB;
-- Architecture Declaration
ARCHITECTURE behavior OF SYNC2_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT SYNC2
    PORT(
      SENSOR_IN  : IN std_logic; -- D
      CLK        : IN std_logic; -- CLOCK
      RES        : IN std_logic; -- Active High Reset
      SI         : OUT std_logic -- Output
        );
    END COMPONENT;

   --Inputs
   signal CLK_s : std_logic := '0';
   signal SENSOR_IN_s : std_logic := '0';
   signal RESET_s : std_logic := '0';
 	--Outputs
   signal SI_s : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SYNC2 PORT MAP (
          CLK => CLK_s,
          SENSOR_IN => SENSOR_IN_s,
		  RES => RESET_s,
          SI => SI_s
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
		SENSOR_IN_s <= '0';
		wait for 500 ns;
		SENSOR_IN_s <= '1';
		wait for 500 ns;
   end process;
-- END
END behavior;