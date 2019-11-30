library IEEE;
use IEEE.std_logic_1164.all;

entity phaseShiftTB_TL is 
end entity;

architecture sim of phaseShiftTB_TL is 

Signal MCLK_s : std_logic;
Signal CLR_s  : std_logic;
Signal SW_s  : std_logic_vector(1 downto 0);
Signal SENSOR_IN_s : std_logic; 

Signal PHI_0_s 	: std_logic;
Signal PHI_90_s : std_logic; 
Signal DIGIT_s  : std_logic_vector(7 downto 0);
Signal DIGEN_s  : std_logic_vector(3 downto 0);
Signal LED_s   : std_logic_vector(1 downto 0); 
Signal OFLOW_s  : std_logic; 

 constant MCLK_period : time := 10 ns;  -- 100mhz
 constant SENSOR_IN_period : time  := 8521 ns; -- 1363 = 733675hz

component phaseShift_TL is
	port (
		MCLK : in STD_LOGIC;
		CLR  : in STD_LOGIC;
		SW : in STD_LOGIC_VECTOR(1 downto 0);
		SENSOR_IN : in STD_LOGIC;
		-- OUTPUT 
		PHI_0 : out STD_LOGIC;
		PHI_90 : out STD_LOGIC; 
		DIGIT	: out STD_LOGIC_VECTOR(7 downto 0);
		DIGEN  : out STD_LOGIC_VECTOR(3 downto 0);
		LED : out STD_LOGIC_VECTOR(1 downto 0); 
		OFLOW	: out std_logic
	);
end component;
begin 

PS_TL: phaseShift_TL
	port map(
		MCLK  => MCLK_s,
		CLR   => CLR_s,
		SW 	=> SW_s,
		SENSOR_IN => SENSOR_IN_s,
		-- OUTPUT 
		PHI_0  => PHI_0_s,
		PHI_90 => PHI_90_s, 
		DIGIT	=> DIGIT_s,
		DIGEN  => DIGEN_s,
		LED	=> LED_s,
		OFLOW	=> OFLOW_s
	);


  -- CLR
	CLR_s <= '1', '0' after 100 ns;
	SW_s <= "00"; -- stick to just displays
   -- Clock process definitions
 CLK_process :process
   begin
		MCLK_s <= '0';
		wait for MCLK_period/2;
		MCLK_s <= '1';
		wait for MCLK_period/2;
   end process;

 SI_process :process 
	begin 
		SENSOR_IN_s <= '0';
		wait for SENSOR_IN_period / 2;
		SENSOR_IN_s <= '1';
		wait for SENSOR_IN_period / 2;
	end process; 

	
end architecture;