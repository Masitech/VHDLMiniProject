
-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity frequencyCalTB is 
end entity;

architecture sim of frequencyCalTB is 
  -- custom signals 
		Signal SI_s  : std_logic;
		Signal CLK_s : std_logic;
		Signal RES_s : std_logic;
		Signal SW_s  : std_logic_vector(1 downto 0);
		-- output
		Signal LED_s  : std_logic_vector(1 downto 0);
		Signal DA_s : std_logic_vector(3 Downto 0);
		Signal DB_s : std_logic_vector(3 Downto 0);
		Signal DC_s : std_logic_vector(3 Downto 0);
		Signal DD_s : std_logic_vector(3 Downto 0);
		Signal DE_s : std_logic;
		Signal OFLOW_s : std_logic;
  -- componets 
  component frequencyCal
    port(
		SI  : In std_logic; -- Input Signal
		CLK : In std_logic; -- CLOCK
		RES : In std_logic;
		SW  : In std_logic_vector(1 downto 0);
		-- output
		LED  : Out std_logic_vector(1 downto 0);
		DA : Out std_logic_vector(3 Downto 0);
		DB : Out std_logic_vector(3 Downto 0);
		DC : Out std_logic_vector(3 Downto 0);
		DD : Out std_logic_vector(3 Downto 0);
		DE   : Out std_logic   -- display enable
    );
 end component;
--  period definitions
   constant CLK_period : time := 20 ns;
   constant SI_period : time  := 8521 ns; -- 1363 = 733675hz
begin
 -- instance of componets and port map componet port to signal 
   FREQ_C:frequencyCal port map(
		SI  => SI_s,
		CLK => CLK_s,
		RES => RES_s,
		SW  => SW_s,
		
		-- output
		LED  => LED_s,
		DA => DA_s,
		DB => DB_s,
		DC => DC_s,
		DD => DD_s,
		DE   => DE_s
		OFLOW => OFLOW_s;
   );

  -- CLR
	RES_s <= '1', '0' after 100 ns;
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