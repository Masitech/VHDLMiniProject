library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BinaryCounter is 
   port( 
   
     CE: in std_logic;
 	 CLK: in std_logic;
 	 RESET: in std_logic;
 	 Output: out std_logic_vector(0 to 3);
	 OFLOW : out std_logic);
end BinaryCounter;
 
architecture RTL of BinaryCounter is
   signal temp: std_logic_vector(0 to 3) := (others => '0');
   signal OFLOW_s : std_logic := '0';
begin   

process(CE,RESET)
   begin
      if RESET ='1' then
         temp <= "0000";
      elsif(rising_edge(CE)) then
         --if CE ='1' then
            if temp="1001" then
               temp<="0000";
			    OFLOW_s <= not OFLOW_s;
            else
               temp <= temp + 1;
            end if;
         --end if;
      end if;
   end process;
   
   Output <= temp;
   OFLOW <= OFLOW_s;
end RTL;