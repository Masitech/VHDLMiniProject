-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019
-- File Info : Buffers the input signal from the outside 
-- world and produces a clean high low signal for the internal circuit. 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- Entity Declaration (D type Flip Flip)
ENTITY sync2 IS
   PORT
   (
      SENSOR_IN  : IN std_logic; -- D
      CLK        : IN std_logic; -- CLOCK
      RES        : IN std_logic; -- Active High Reset
      SI         : OUT std_logic -- Output
   );
END sync2;
-- Architecture Declaration
ARCHITECTURE rtl OF sync2 IS
BEGIN
   -- Process Declaration
   PROCESS (CLK, RES)
   BEGIN
      -- Clock Rise Edge
      IF rising_edge (CLK) THEN
         IF RES = '1' THEN
            SI <= '0';
         ELSE
            SI <= SENSOR_IN; -- Input becomes the output during rising edge.
         END IF;
      END IF;
   END PROCESS;
END rtl;
