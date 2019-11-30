library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity phaseShifterTB is 
end entity;

architecture sim of phaseShifterTB is 
  -- custom signals 
  -- Input Signal 
  signal SI_s                   : std_logic; 
  signal CLK_s                  : std_logic; 
  signal RES_S                  : std_logic;   
  
  -- output Signal 
  signal PHI_0                  : std_logic; 
  signal PHI_90                 : std_logic;
 
  -- componets 
  component PhaseShifter
    port(
      --input
      SI  	                   	: in 	std_logic;
      CLK		             		: in 	std_logic;
      RES		             		: in 	std_logic;
      --output
      PHI_0	                     : out std_logic;
      PHI_90	                  : out std_logic
    );
 end component;
--  period definitions
   constant CLK_period : time := 10 ns;
   constant SI_period : time := 1 ms;
begin
 -- instance of componets and port map componet port to signal 
   PHA:PhaseShifter port map(
      --input
      SI  	                     => SI_S,
      CLK		             		=> CLK_s,
      RES		             		=> RES_s,
      --output
      PHI_0	                     => PHI_0,
      PHI_90	                  => PHI_90
   );

  -- CLR
	RES_s <= '1', '0' after 50 ns;
   -- Clock process definitions
 CLK_process :process
   begin
		CLK_s <= '0';
		wait for CLK_period/2;
		CLK_s <= '1';
		wait for CLK_period/2;
   end process;

 SI_process :process 
	begin 
		SI_s <= '0';
		wait for SI_period / 2;
		SI_s <= '1';
		wait for SI_period / 2;
	end process; 
end architecture;
