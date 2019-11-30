-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity clockDiv2 is 
	port (
    	MCLK 	: in std_logic;
      CLK		: out std_logic
    );
end entity;
	

architecture rtl of clockDiv2 is 
	signal counter : std_logic :='0';
begin

	process(MCLK) is 
	begin 
		if rising_edge(MCLK) then 
			counter <= not counter;
		end if;
	end process;
			CLK <= counter;
end architecture;