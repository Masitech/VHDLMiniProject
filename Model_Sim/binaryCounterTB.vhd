
-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity BinaryCounterTB is 
end entity;

architecture sim of BinaryCounterTB is 
  -- custom signals 
  -- Input Signal 
  signal CE_s                   : std_logic; 
  signal CLK_s                  : std_logic; 
  signal RESETX_s                  : std_logic := '0';   
  
  -- output Signal 
  signal Unit_s    : std_logic_vector(3 downto 0);
  signal Ten_s    : std_logic_vector(3 downto 0);
  signal Hundred_s    : std_logic_vector(3 downto 0);
  signal Thousand_s    : std_logic_vector(3 downto 0);
  signal OFLOW_U, OFLOW_T, OFLOW_H, OFLOW_Th : std_logic; 
 
  -- componets 
  component BinaryCounter
    port(
	 CE: in std_logic;
 	 CLK: in std_logic;
 	 RES: in std_logic;
 	 Output: out std_logic_vector(0 to 3);
	 OFLOW : out std_logic
    );
 end component;
--  period definitions
   constant CLK_period : time := 20 ns;
   --constant SI_period :  time  := 8521 ns; -- 1363 = 733675hz
begin
 -- instance of componets and port map componet port to signal 
   Unit:BinaryCounter port map(
	 CE  => CE_s,
 	 CLK => CLK_s,
 	 RES => RESETX_s,
 	 Output => Unit_s,
	 OFLOW => OFLOW_U
   );
   
   Ten:BinaryCounter port map(
	 CE  => OFLOW_U,
 	 CLK => CLK_s,
 	 RES => RESETX_s,
 	 Output => Ten_s,
	 OFLOW => OFLOW_T
   );
   
    Hundred:BinaryCounter port map(
	 CE  => OFLOW_T,
 	 CLK => CLK_s,
 	 RES => RESETX_s,
 	 Output => Hundred_s,
	 OFLOW => OFLOW_H
   );
   
     Thousand:BinaryCounter port map(
	 CE  => OFLOW_H,
 	 CLK => CLK_s,
 	 RES => RESETX_s,
 	 Output => Thousand_s,
	 OFLOW => OFLOW_Th
   );
  -- CLR
	
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
		CE_s <= '0';
		wait for 50 ns;
		CE_s <= '1';
		wait for 50 ns;
	end process; 

	
 RES_process :process
   begin
		RESETX_s <= '0';
		wait for 12555 ns;
		RESETX_s <= '1';
		wait for 100 ns;
   end process;
   
   
end architecture;