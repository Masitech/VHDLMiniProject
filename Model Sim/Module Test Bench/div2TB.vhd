-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019
-- File Info : Divides the main clock 100mhz by 2 using DFF + Not gate 
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity clockDiv2TB is 
end entity;

architecture sim of clockDiv2TB is 
	constant 	 MCLKF 			      : 	integer := 12e6;  --12mhz
	constant 	 MCLK_Period 	  : 	time 	:= 1000ms / MCLKF; --1 second 
	
	signal 		  MCLK 			       : 	std_logic := '0';
	signal		   CLK				        : 	std_logic := '0';
begin


	--DUT 
	cd2 : entity work.clockDiv2(rtl)
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