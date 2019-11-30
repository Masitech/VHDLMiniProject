-- Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Entity Declaration (D type Flip Flip) 
entity sync is
    Port ( 
    CLR         : in  std_logic;   -- D
    CLK         : in  std_logic;   -- CLOCK
    RESET       : in  std_logic;   -- Active High Reset
    RES         : out std_logic    -- Output 
    );
end sync;

-- Architecture Declaration
architecture rtl of sync is
begin
-- Process Declaration
process (CLK, RESET)
begin
-- Clock Rise Edge
  if rising_edge (CLK) then
    RES <= CLR;  -- Input becomes the output during rising edge. 
	end if ;
end process ;
-- END
end rtl;


