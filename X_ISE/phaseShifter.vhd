-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019
-- File Info : Using 2 different counter one at clk speed and other at clk / 2 (toggle). It works out what is half of input
-- half wave. It works out the half for the first half of SI cycle and half of the second half of the SI single incase the SI signal has non 
-- propotional duty cycle e.g not 50-50 


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY PhaseShifter IS
	PORT 
	(
		--input
		SI  : IN std_logic;
		CLK : IN std_logic;
		RES : IN std_logic;
		--output
		PHI_0  : OUT std_logic;
		PHI_90 : OUT std_logic
	);
END ENTITY;

ARCHITECTURE rtl OF PhaseShifter IS
	-- clk div 2
	SIGNAL TOGGLE : std_logic;
	-- counter A
	SIGNAL CEA  : std_logic;
	SIGNAL TCU1 : std_logic;

	-- counter B .
	SIGNAL CEB      : std_logic;
	SIGNAL TCU2     : std_logic;
 
 
	SIGNAL TCU_XNOR : std_logic;
	-- variable
	SIGNAL CEA_Counter1 : INTEGER := 0;
	SIGNAL CEA_Counter2 : INTEGER := 0;
	SIGNAL CEB_Counter1 : INTEGER := 0;
	SIGNAL CEB_Counter2 : INTEGER := 0;

	SIGNAL PHI_0_s      : std_logic;
 
BEGIN
	CounterX : PROCESS (RES, CLK)
	BEGIN
		IF RES = '1' THEN
			CEA_Counter1 <= 0;
			CEA_Counter2 <= 0;
			CEB_Counter1 <= 0;
			CEB_Counter2 <= 0;
		ELSIF rising_edge(CLK) THEN
			IF SI = '0' THEN
				TCU2         <= '0';
				CEB_Counter2 <= 0;
				CEA_Counter2 <= CEA_Counter2 + 1;
				IF CEA_Counter2 = CEA_Counter1 THEN
					IF TCU1 = '0' THEN
						TCU1         <= '1';
						CEA_Counter1 <= 0;
					END IF;
				END IF;
 
				IF CEB = '0' THEN -- increment counter CEB
					CEB_Counter1 <= CEB_Counter1 + 1;
				END IF;
			ELSIF SI = '1' THEN
				TCU1         <= '0'; -- when si is high TCU1 is low
				CEA_Counter2 <= 0;
				CEB_Counter2 <= CEB_Counter2 + 1;
				IF CEB_Counter2 = CEB_Counter1 THEN
					IF TCU2 = '0' THEN
						TCU2         <= '1';
						CEB_Counter1 <= 0;
					END IF;
				END IF;
 
				IF CEA = '0' THEN --incremnt counter CEA
					CEA_Counter1 <= CEA_Counter1 + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	-- generate output dual D-FF.
	PHI_OUTPUT : PROCESS (CLK, RES)
	BEGIN
		IF RES = '1' THEN
			PHI_0  <= '0';
			PHI_90 <= '0';
		ELSIF rising_edge(CLK) THEN
			TCU_XNOR <= (TCU1 OR TCU2) XNOR PHI_0_s;
			PHI_0_s  <= SI;
			PHI_0    <= SI;
			PHI_90   <= TCU_XNOR;
		END IF;
	END PROCESS;
	-- create toggle secondary clock
	Toggle_create : PROCESS (CLK, RES) IS
	BEGIN
		IF rising_edge(CLK) THEN
			IF RES = '1' THEN
				TOGGLE <= '0';
			ELSE
				TOGGLE <= NOT TOGGLE; 
			END IF;
		END IF;
	END PROCESS;

	CEA <= (SI AND TOGGLE) OR (NOT SI);
	CEB <= ((NOT SI) AND TOGGLE) OR SI;

END rtl;