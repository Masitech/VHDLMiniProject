library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity displayInterfaceTB is 
end entity;


architecture sim of displayInterfaceTB is 
signal HEXA_s, HEXB_s, HEXC_s, HEXD_s, DIGEN_s : std_logic_vector(3 downto 0):= (others => '0');
signal CLK_s, RES_s, DE_s : std_logic := '0';
signal DIGIT_s : std_logic_vector( 7 downto 0) := (others => '0'); 

component displayInterface 
	port(
		HEXA : in std_logic_vector(3 downto 0);
		HEXB : in std_logic_vector(3 downto 0);
		HEXC : in std_logic_vector(3 downto 0);
		HEXD : in std_logic_vector(3 downto 0);
		DE   : in std_logic;
		CLK  : in std_logic;
		RES  : in std_logic;
		
		DIGIT : out std_logic_vector(7 downto 0);
		DIGEN : out std_logic_vector(3 downto 0)
	);
end component;
begin 

display : displayInterface 
	port map (
	HEXA => HEXA_s,
	HEXB => HEXB_s,
	HEXC => HEXC_s,
	HEXD => HEXD_s,
	
	DE => DE_s,
	CLK => CLK_s,
	RES => RES_s,
	DIGEN => DIGEN_s,
	DIGIT => DIGIT_s
	
	);
	
	
	  -- CLR
	RES_s <= '1', '0' after 100 ns;
   -- Clock process definitions
 CLK_process :process
   begin
		CLK_s <= '0';
		wait for 10 ns;
		CLK_s <= '1';
		wait for 10 ns;
   end process;
   
   
    DE_process :process
   begin
		DE_s <= '0';
		wait for 500 ns;
		DE_s <= '1';
		wait for 500 ns;
   end process;
   
   HEXA_s <= "0000", "0001" after 1500 ns;
   HEXB_s <= "0000", "0010" after 1500 ns;
   HEXC_s <= "0000", "0011" after 1500 ns;
   HEXD_s <= "0000", "0100" after 1500 ns;
   
end sim;