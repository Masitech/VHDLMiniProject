-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019
-- File Info : Divides the main clock 100mhz by 2 using DFF + Not gate 

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY clockDiv2 IS
   PORT
   (
      MCLK  : IN std_logic;
      CLK   : OUT std_logic
   );
END ENTITY;

ARCHITECTURE rtl OF clockDiv2 IS
   SIGNAL counter : std_logic := '0';
BEGIN
   PROCESS (MCLK) IS
   BEGIN
      IF rising_edge(MCLK) THEN
         counter <= NOT counter;
      END IF;
   END PROCESS;
   CLK <= counter;
END ARCHITECTURE;