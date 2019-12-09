-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY frequencyCalTB IS
END ENTITY;

ARCHITECTURE sim OF frequencyCalTB IS
	-- custom signals
	SIGNAL SI_s  : std_logic := '0';
	SIGNAL CLK_s : std_logic := '0';
	SIGNAL RES_s : std_logic := '0';
	SIGNAL SW_s  : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
	-- output
	SIGNAL LED_s   : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DA_s    : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DB_s    : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DC_s    : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DD_s    : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DE_s    : std_logic := '0';
	SIGNAL OFLOW_s : std_logic := '0';
	-- componets
	COMPONENT frequencyCal
		PORT 
		(
			SI  : IN std_logic; -- Input Signal
			CLK : IN std_logic; -- CLOCK
			RES : IN std_logic;
			SW  : IN std_logic_vector(1 DOWNTO 0);
			-- output
			LED    : OUT std_logic_vector(1 DOWNTO 0);
			DA     : OUT std_logic_vector(3 DOWNTO 0);
			DB     : OUT std_logic_vector(3 DOWNTO 0);
			DC     : OUT std_logic_vector(3 DOWNTO 0);
			DD     : OUT std_logic_vector(3 DOWNTO 0);
			DE     : OUT std_logic; -- display enable
			OFLOWX : OUT std_logic
		);
	END COMPONENT;
	-- period definitions
	CONSTANT CLK_period : TIME := 20 ns;
	CONSTANT SI_period  : TIME := 8521 ns; -- 1363 = 733675hz
BEGIN
	-- instance of componets and port map componet port to signal
	FREQ_C : frequencyCal
	PORT MAP
	(
		SI  => SI_s, 
		CLK => CLK_s, 
		RES => RES_s, 
		SW  => SW_s, 
 
		-- output
		LED    => LED_s, 
		DA     => DA_s, 
		DB     => DB_s, 
		DC     => DC_s, 
		DD     => DD_s, 
		DE     => DE_s, 
		OFLOWX => OFLOW_s
	);

	-- CLR
	SW_s  <= "00";
	RES_s <= '1', '0' AFTER 100 ns;
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