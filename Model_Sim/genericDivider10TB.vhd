-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity genericDivider10TB is 
end entity;

architecture sim of genericDivider10TB is 
	constant 	MCLKF 			: 	integer := 12e6; --12mhz
	constant 	MCLK_Period 	: 	time 	:= 1000ms / MCLKF; --1 second 
	
	signal 		MCLK 			: 	std_logic := '0';
	signal		CLK				: 	std_logic := '0';

component  clockDiv is 
generic(N: integer := 10);
	port (
    	MCLK 	: in std_logic;
        CLK		: out std_logic
    );
end component;
begin

	--DUT 
	div10 : clockDiv
	port map(
	MCLK 	=> MCLK,
	CLK 	=> CLK
	);

	--generating the master clock.
	MCLK <= not MCLK after MCLK_Period / 2;
	
	process 
	begin 
    	wait for 10ns;
	
	end process;

end architecture;