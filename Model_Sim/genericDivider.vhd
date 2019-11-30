-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity clockDiv is 
generic(N: integer:=2);
	port (
    	MCLK 	 : in std_logic;
    	RES    : in std_logic := '0'; -- active high reset
    	CLK		  : out std_logic
    );
end entity;
	
architecture rtl of clockDiv is 
	signal outputX : std_logic :='0';
begin

	process(MCLK) is 
    variable varCount : integer RANGE 0 to N;
	--constant variable rollOver : integer := N;
	begin 
		if rising_edge(MCLK) then 
		  if RES = '1' then 
		    outputX <= '0';
		  elsif varCount = N-1 then 
				outputX <= not outputX;
				varCount := 0;
			else
				varCount := VarCount + 1;
			end if;
		end if;
		
	end process;
CLK <= outputX;
	
end architecture;