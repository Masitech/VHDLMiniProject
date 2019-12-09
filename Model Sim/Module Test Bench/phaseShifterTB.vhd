-- Author : Masum Ahmed
-- Email : Ma786@kent.ac.uk
-- Date : 04/12/2019

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY phaseShifterTB IS
END ENTITY;

ARCHITECTURE sim OF phaseShifterTB IS
	-- custom signals
	-- Input Signal
	SIGNAL SI_s  : std_logic;
	SIGNAL CLK_s : std_logic;
	SIGNAL RES_S : std_logic; 
 
	-- output Signal
	SIGNAL PHI_0  : std_logic;
	SIGNAL PHI_90 : std_logic;

	-- componets
	COMPONENT PhaseShifter
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
	END COMPONENT;
	-- period definitions
	CONSTANT CLK_period : TIME := 10 ns;
	CONSTANT SI_period  : TIME := 1 ms;
BEGIN
	-- instance of componets and port map componet port to signal
	PHA : PhaseShifter
	PORT MAP
	(
		--input
		SI  => SI_S, 
		CLK => CLK_s, 
		RES => RES_s, 
		--output
		PHI_0  => PHI_0, 
		PHI_90 => PHI_90
	);

	-- CLR
	RES_s <= '1', '0' AFTER 50 ns;
	-- Clock process definitions
	CLK_process : PROCESS
	BEGIN
		CLK_s <= '0';
		WAIT FOR CLK_period/2;
		CLK_s <= '1';
		WAIT FOR CLK_period/2;
	END PROCESS;

	SI_process : PROCESS
	BEGIN
		SI_s <= '0';
		WAIT FOR SI_period / 2;
		SI_s <= '1';
		WAIT FOR SI_period / 2;
	END PROCESS;
END ARCHITECTURE;