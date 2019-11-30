
-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity frequencyCalTB is 
end entity;

architecture sim of frequencyCalTB is 
  -- custom signals 
  -- Input Signal 
  signal SI_s                   : std_logic; 
  signal CLK_s                  : std_logic; 
  signal RES_S                  : std_logic;   
  signal SW1_s                  : std_logic;
  signal SW2_s                  : std_logic;
  
  -- output Signal 
  signal SEVEN_SEGMENT_OUT_s    : std_logic_vector(6 downto 0);
  signal SEGMENT_EN_0_s         : std_logic;
  signal SEGMENT_EN_1_s         : std_logic;
  signal SEGMENT_EN_2_s         : std_logic;
  signal SEGMENT_EN_3_s         : std_logic;
  signal LED1_s                 : std_logic;
  signal LED2_s                 : std_logic;
 
  -- componets 
  component frequencyCal
    port(
    SI                  : in  std_logic;   -- Input Signal
    CLK                 : in  std_logic;   -- CLOCK
    RES                 : in  std_logic;
    SW1                 : in  std_logic; 
    SW2                 : in  std_logic;  
    -- output 
    SEVEN_SEGMENT_OUT   : out std_logic_vector(6 downto 0);
    SEGMENT_EN_0        : out std_logic;
    SEGMENT_EN_1        : out std_logic;
    SEGMENT_EN_2        : out std_logic;
    SEGMENT_EN_3        : out std_logic;
    LED1                : out std_logic;
    LED2                : out std_logic 
    );
 end component;
--  period definitions
   constant CLK_period : time := 20 ns;
   constant SI_period : time  := 8521 ns; -- 1363 = 733675hz
begin
 -- instance of componets and port map componet port to signal 
   FREQ_C:frequencyCal port map(
    SI                  => SI_s,
    CLK                 => CLK_s,
    RES                 => RES_s,
    SW1                 => SW1_s,
    SW2                 => SW2_s,
    -- output 
    SEVEN_SEGMENT_OUT   => SEVEN_SEGMENT_OUT_s,
    SEGMENT_EN_0        => SEGMENT_EN_0_s,
    SEGMENT_EN_1        => SEGMENT_EN_1_s,
    SEGMENT_EN_2        => SEGMENT_EN_2_s,
    SEGMENT_EN_3        => SEGMENT_EN_3_s,
    LED1                => LED1_s,
    LED2                => LED2_s
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