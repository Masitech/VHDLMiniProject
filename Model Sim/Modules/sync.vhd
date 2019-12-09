-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019
-- File Info : acts as a buffer from clr button on the fpga dev board to the logic units.
-- This will reduce noise from button debounce + synch design implementation

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- Entity Declaration (D type Flip Flip)
ENTITY sync IS
   PORT
   (
      CLR    : IN std_logic; -- D
      CLK    : IN std_logic; -- CLOCK
      RESET  : IN std_logic; -- Active High Reset
      RES    : OUT std_logic -- Output
   );
END sync;
-- Architecture Declaration
ARCHITECTURE rtl OF sync IS
BEGIN
   -- Process Declaration
   PROCESS (CLK, RESET)
   BEGIN
      -- Clock Rise Edge
      IF rising_edge (CLK) THEN
         RES <= CLR; -- Input becomes the output during rising edge.
      END IF;
   END PROCESS;
   -- END
END rtl;
