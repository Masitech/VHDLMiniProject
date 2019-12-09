LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY displayInterfaceTB IS
END ENTITY;
ARCHITECTURE sim OF displayInterfaceTB IS
	SIGNAL HEXA_s, HEXB_s, HEXC_s, HEXD_s, DIGEN_s : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RES_s, DE_s                             : std_logic := '0';
	SIGNAL DIGIT_s                                 : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	COMPONENT displayInterface
		PORT 
		(
			HEXA  : IN std_logic_vector(3 DOWNTO 0);
			HEXB  : IN std_logic_vector(3 DOWNTO 0);
			HEXC  : IN std_logic_vector(3 DOWNTO 0);
			HEXD  : IN std_logic_vector(3 DOWNTO 0);
			DE    : IN std_logic;
			RES   : IN std_logic;
			DIGIT : OUT std_logic_vector(7 DOWNTO 0);
			DIGEN : OUT std_logic_vector(3 DOWNTO 0)
		);
	END COMPONENT;
BEGIN
	display : displayInterface
	PORT MAP
	(
		HEXA  => HEXA_s, 
		HEXB  => HEXB_s, 
		HEXC  => HEXC_s, 
		HEXD  => HEXD_s, 
 
		DE    => DE_s, 
		RES   => RES_s, 
		DIGEN => DIGEN_s, 
		DIGIT => DIGIT_s
	);
 
 
	-- CLR
	RES_s <= '1', '0' AFTER 100 ns;
 
	DE_process : PROCESS
	BEGIN
		DE_s <= '0';
		WAIT FOR 50 ns;
		DE_s <= '1';
		WAIT FOR 50 ns;
	END PROCESS;
 
	HEXA_s <= "0000", "0001" AFTER 1500 ns;
	HEXB_s <= "0000", "0010" AFTER 1500 ns;
	HEXC_s <= "0000", "0011" AFTER 1500 ns;
	HEXD_s <= "0000", "0100" AFTER 1500 ns;
 
END sim;