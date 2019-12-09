-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY phaseShiftTB_TL IS
END ENTITY;

ARCHITECTURE sim OF phaseShiftTB_TL IS

	SIGNAL MCLK_s             : std_logic;
	SIGNAL CLR_s              : std_logic;
	SIGNAL SW_s               : std_logic_vector(1 DOWNTO 0);
	SIGNAL SENSOR_IN_s        : std_logic;

	SIGNAL PHI_0_s            : std_logic;
	SIGNAL PHI_90_s           : std_logic;
	SIGNAL DIGIT_s            : std_logic_vector(7 DOWNTO 0);
	SIGNAL DIGEN_s            : std_logic_vector(3 DOWNTO 0);
	SIGNAL LED_s              : std_logic_vector(1 DOWNTO 0);
	SIGNAL OFLOW_s            : std_logic;

	CONSTANT MCLK_period      : TIME := 10 ns; -- 100mhz
	CONSTANT SENSOR_IN_period : TIME := 8521 ns; -- 1363 = 733675hz

	COMPONENT phaseShift_TL IS
		PORT 
		(
			MCLK      : IN STD_LOGIC;
			CLR       : IN STD_LOGIC;
			SW        : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			SENSOR_IN : IN STD_LOGIC;
			-- OUTPUT
			PHI_0  : OUT STD_LOGIC;
			PHI_90 : OUT STD_LOGIC;
			DIGIT  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			DIGEN  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			LED    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			OFLOW  : OUT std_logic
		);
	END COMPONENT;
BEGIN
	PS_TL : phaseShift_TL
	PORT MAP
	(
		MCLK      => MCLK_s, 
		CLR       => CLR_s, 
		SW        => SW_s, 
		SENSOR_IN => SENSOR_IN_s, 
		-- OUTPUT
		PHI_0  => PHI_0_s, 
		PHI_90 => PHI_90_s, 
		DIGIT  => DIGIT_s, 
		DIGEN  => DIGEN_s, 
		LED    => LED_s, 
		OFLOW  => OFLOW_s
	);
	-- CLR
	CLR_s <= '1', '0' AFTER 100 ns;
	SW_s  <= "00"; -- stick to just displays
	-- Clock process definitions
	CLK_process : PROCESS
	BEGIN
		MCLK_s <= '0';
		WAIT FOR MCLK_period/2;
		MCLK_s <= '1';
		WAIT FOR MCLK_period/2;
	END PROCESS;

	SI_process : PROCESS
	BEGIN
		SENSOR_IN_s <= '0';
		WAIT FOR SENSOR_IN_period / 2;
		SENSOR_IN_s <= '1';
		WAIT FOR SENSOR_IN_period / 2;
	END PROCESS;

 
END ARCHITECTURE;