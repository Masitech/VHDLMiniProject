-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity genericDivider2TB is 
end entity;

architecture sim of genericDivider2TB is 
	constant 	 MCLKF 			: 	integer := 12e6; --12mhz
	constant 	 MCLK_Period 	: 	time 	:= 1000ms / MCLKF; --1 second 
	
	signal 		  MCLK 			: 	std_logic := '0';
	signal		   CLK				: 	std_logic := '0';

component  clockDiv is 
generic(N: integer := 2);
	port (
    	MCLK 	 : in std_logic;
    	RES    : in std_logic;
     CLK		  : out std_logic);
end component;
begin

	--DUT 
	div2 : clockDiv
	port map(
	MCLK 	=> MCLK,
	RES => '0',
	CLK 	=> CLK
		);

	--generating the master clock.
	MCLK <= not MCLK after MCLK_Period / 2;
	
	process 
	begin 
    	wait for 10ns;
	
	end process;

end architecture;