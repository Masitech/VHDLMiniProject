library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity displayInterface is 
	port (
		HEXA : in std_logic_vector(3 downto 0);
		HEXB : in std_logic_vector(3 downto 0);
		HEXC : in std_logic_vector(3 downto 0);
		HEXD : in std_logic_vector(3 downto 0);
		DE   : in std_logic;
		RES  : in std_logic;
		
		DIGIT : out std_logic_vector(7 downto 0);
		DIGEN : out std_logic_vector(3 downto 0));
end displayInterface;

architecture rtl of displayInterface is 
signal whichSegment : std_logic_vector(1 downto 0) := (others => '0');
signal segmentMux   : std_logic_vector(3 downto 0) := (others => '0'); 
begin 


process(DE)
begin 
	if rising_edge(DE) then 
		whichSegment <= whichSegment + 1;
	end if;
end process;


process(whichSegment)
begin 
	case whichSegment is 
	when "00"  =>
		DIGEN <= "0111";
		segmentMux <= HEXA;
	when "01"  =>
		DIGEN <= "1011";
		segmentMux <= HEXB;
	when "10"  =>
		DIGEN <= "1101";
		segmentMux <= HEXC;
	when "11"  =>
		DIGEN <= "1110";
		segmentMux <= HEXD;
	When Others =>
		DIGEN <= "0111";
		segmentMux <= HEXA;
	end case;
end process;

--new output if theres selection chnage. 
process(segmentMux, RES) 
begin	
if RES = '1' then 
			DIGIT <= "00000000";
		else
		Case(segmentMux) Is
			When "0000"  	=> 
			DIGIT  <= "00000011"; -- 0
			When "0001"  	=> 
			DIGIT  <= "10011111"; -- 1
			When "0010"  	=> 
			DIGIT  <= "00100101"; -- 2
			When "0011"  	=> 
			DIGIT  <= "00001101"; -- 3
			When "0100" 	=> 
			DIGIT  <= "10011001"; -- 4
			When "0101" 	=> 
			DIGIT  <= "01001001"; -- 5
			When "0110" 	=> 
			DIGIT  <= "01000001"; -- 6
			When "0111" 	=> 
			DIGIT  <=  "00011111"; -- 7
			When "1000" 	=> 
			DIGIT  <= "00000001"; -- 8
			When "1001" 	=> 
			DIGIT  <= "00001001"; -- 9
			When Others     => 
			DIGIT  <= "00000000"; -- display Light up all of the led when error
		End Case;
		end if;
end process;
end rtl;
