-- Author : Masum Ahmed
-- Email : Ma786@kent.ac.uk
-- Date : 04/12/2019
-- File Info : Generic module for a 4 bit binary counter with clock enable and overflow. 

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY BinaryCounterTB IS
END ENTITY;

ARCHITECTURE sim OF BinaryCounterTB IS
	-- custom signals
	-- Input Signal
	SIGNAL CE_s     : std_logic;
	SIGNAL CLK_s    : std_logic;
	SIGNAL RESETX_s : std_logic := '0'; 
 
	-- output Signal
	SIGNAL Unit_s                              : std_logic_vector(3 DOWNTO 0);
	SIGNAL Ten_s                               : std_logic_vector(3 DOWNTO 0);
	SIGNAL Hundred_s                           : std_logic_vector(3 DOWNTO 0);
	SIGNAL Thousand_s                          : std_logic_vector(3 DOWNTO 0);
	SIGNAL OFLOW_U, OFLOW_T, OFLOW_H, OFLOW_Th : std_logic;

	-- componets
	COMPONENT BinaryCounter
		PORT 
		(
			CE     : IN std_logic;
			CLK    : IN std_logic;
			RESET  : IN std_logic;
			Output : OUT std_logic_vector(0 TO 3);
			OFLOW  : OUT std_logic
		);
	END COMPONENT;
	-- period definitions
	CONSTANT CLK_period : TIME := 20 ns;
	--constant SI_period : time := 8521 ns; -- 1363 = 733675hz
BEGIN
	-- instance of componets and port map componet port to signal
	Unit : BinaryCounter
	PORT MAP
	(
		CE     => CE_s, 
		CLK    => CLK_s, 
		RESET  => RESETX_s, 
		Output => Unit_s, 
		OFLOW  => OFLOW_U
	);
 
	Ten : BinaryCounter
	PORT MAP
	(
		CE     => OFLOW_U, 
		CLK    => CLK_s, 
		RESET  => RESETX_s, 
		Output => Ten_s, 
		OFLOW  => OFLOW_T
	);
 
	Hundred : BinaryCounter
	PORT MAP
	(
		CE     => OFLOW_T, 
		CLK    => CLK_s, 
		RESET  => RESETX_s, 
		Output => Hundred_s, 
		OFLOW  => OFLOW_H
	);
 
	Thousand : BinaryCounter
	PORT MAP
	(
		CE     => OFLOW_H, 
		CLK    => CLK_s, 
		RESET  => RESETX_s, 
		Output => Thousand_s, 
		OFLOW  => OFLOW_Th
	);
	-- CLR
 
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
		CE_s <= '0';
		WAIT FOR 500 ns;
		CE_s <= '1';
		WAIT FOR 20 ns;
	END PROCESS;

 
	RES_process : PROCESS
	BEGIN
		RESETX_s <= '0';
		WAIT FOR 1 ms;
		RESETX_s <= '1';
		WAIT FOR 20 ns;
	END PROCESS;
 
 
END ARCHITECTURE;