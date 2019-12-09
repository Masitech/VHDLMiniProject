-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019
-- File Info : interfaces with the seven segment displays to output the data.
-- The data is demultiplexed since the seven segment display shares common data lines. 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY displayInterface IS
   PORT
   (
      HEXA   : IN std_logic_vector(3 DOWNTO 0);
      HEXB   : IN std_logic_vector(3 DOWNTO 0);
      HEXC   : IN std_logic_vector(3 DOWNTO 0);
      HEXD   : IN std_logic_vector(3 DOWNTO 0);
      DE     : IN std_logic;
      RES    : IN std_logic;
      DIGIT  : OUT std_logic_vector(7 DOWNTO 0);
      DIGEN  : OUT std_logic_vector(3 DOWNTO 0)
   );
END displayInterface;
ARCHITECTURE rtl OF displayInterface IS
   SIGNAL whichSegment : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
   SIGNAL segmentMux : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
BEGIN

--
   PROCESS (DE, RES)
   BEGIN
      IF RES = '1' THEN
         DIGEN <= "0000";
      ELSIF rising_edge(DE) THEN
         whichSegment <= whichSegment + 1;
      END IF;
      CASE whichSegment IS
         WHEN "00" =>
            DIGEN <= "0111";
            segmentMux <= HEXA;
         WHEN "01" =>
            DIGEN <= "1011";
            segmentMux <= HEXB;
         WHEN "10" =>
            DIGEN <= "1101";
            segmentMux <= HEXC;
         WHEN "11" =>
            DIGEN <= "1110";
            segmentMux <= HEXD;
         WHEN OTHERS =>
            DIGEN <= "0111";
            segmentMux <= HEXA;
      END CASE;
   END PROCESS;
	
   -- new output if theres new selection change, 
	-- this is generic LUT table for Seven Segment .
   PROCESS (segmentMux, RES)
      BEGIN
         IF RES = '1' THEN
            DIGIT <= "00000000"; -- display Light up all of the leds when error / reset
         ELSE
            CASE(segmentMux) IS
               WHEN "0000" =>
                  DIGIT <= "00000011"; -- 0
               WHEN "0001" =>
                  DIGIT <= "10011111"; -- 1
               WHEN "0010" =>
                  DIGIT <= "00100101"; -- 2
               WHEN "0011" =>
                  DIGIT <= "00001101"; -- 3
               WHEN "0100" =>
                  DIGIT <= "10011001"; -- 4
               WHEN "0101" =>
                  DIGIT <= "01001001"; -- 5
               WHEN "0110" =>
                  DIGIT <= "01000001"; -- 6
               WHEN "0111" =>
                  DIGIT <= "00011111"; -- 7
               WHEN "1000" =>
                  DIGIT <= "00000001"; -- 8
               WHEN "1001" =>
                  DIGIT <= "00001001"; -- 9
               WHEN OTHERS =>
                  DIGIT <= "00000000"; -- display Light up all of the leds when error / reset
            END CASE;						-- This should not happen when in normal operation 
         END IF;
      END PROCESS;
END rtl;