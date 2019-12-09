-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019
-- File Info : Generic module for a 4 bit binary counter with clock enable and overflow.  

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY BinaryCounter IS
   PORT
   (
      CE : IN std_logic;
      CLK : IN std_logic;
      RESET : IN std_logic;
      Output : OUT std_logic_vector(0 TO 3);
      OFLOW : OUT std_logic
   );
END BinaryCounter;
ARCHITECTURE RTL OF BinaryCounter IS
   SIGNAL temp : std_logic_vector(0 TO 3) := (OTHERS => '0');
   SIGNAL OFLOW_s : std_logic := '0';
BEGIN
   PROCESS (CLK, RESET)
   BEGIN
      IF RESET = '1' THEN
         temp <= "0000";
      ELSIF (rising_edge(CLK)) THEN
         IF CE = '1' THEN
            IF temp = "1001" THEN
               temp <= "0000";
               OFLOW_s <= '1';
            ELSE
               temp <= temp + 1;
            END IF;
         ELSE
            OFLOW_s <= '0';  -- overflow is only active for 1 clock cycle same as CE 
         END IF;
      END IF;
   END PROCESS;
   Output <= temp;
   OFLOW <= OFLOW_s;
END RTL;