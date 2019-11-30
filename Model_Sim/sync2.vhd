-- Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Entity Declaration (D type Flip Flip) 
entity sync2 is
    Port ( 
    SENSOR_IN   : in  std_logic;   -- D
    CLK         : in  std_logic;   -- CLOCK
    RES       : in  std_logic;   -- Active High Reset
    SI         : out std_logic    -- Output 
    );
end sync2;

-- Architecture Declaration
architecture rtl of sync2 is
--signal si_sig : std_logic := '0';
begin
-- Process Declaration
process (CLK, RES)
begin
-- Clock Rise Edge
if rising_edge (CLK) then
  if RES = '1' then 
    SI <= '0';
  else 
    SI <= SENSOR_IN;  -- Input becomes the output during rising edge. 
	end if ;
end if ;
end process ;
end rtl;


