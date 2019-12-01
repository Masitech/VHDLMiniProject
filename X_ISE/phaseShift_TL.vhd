
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity phaseShift_TL is 
	port (
		MCLK 		: in STD_LOGIC;
		CLR  		: in STD_LOGIC;
		SW			: in std_logic_vector(1 downto 0);
		SENSOR_IN 	: in STD_LOGIC;
		
		
		-- OUTPUT 
		PHI_0 		: out STD_LOGIC;
		PHI_90 		: out STD_LOGIC; 
		DIGIT		: out STD_LOGIC_VECTOR(7 downto 0);
		DIGEN  		: out STD_LOGIC_VECTOR(3 downto 0);
		LED			: out std_logic_vector(1 downto 0);
		OFLOW		: out std_logic
	
	);
end phaseShift_TL;


architecture struct of phaseShift_TL is 

-- DIV2 Components - Creates system clock for phaseshift
component clockDiv2 is
    Port ( 
			MCLK 	: in  STD_LOGIC; -- Master Clock input
			CLK 	: out STD_LOGIC
			); -- clock output
end component;


-- SYNC Components : sync reset of all internal links to button on board 
component sync is
    Port ( 
    CLR         : in  std_logic;   -- D
    CLK         : in  std_logic;   -- CLOCK
    RESET       : in  std_logic;   -- Active High Reset
    RES         : out std_logic    -- Output 
    );
end component;



-- SYNC2 Components : Sync input 
component sync2 is
port(
    SENSOR_IN   : in  std_logic;   -- D
    CLK         : in  std_logic;   -- CLOCK
    RES         : in  std_logic;   -- Active High Reset
    SI          : out std_logic    -- Output 
);
end component;

component PhaseShifter is 
		Port (
		--input
		SI : In std_logic;
		CLK : In std_logic;
		RES : In std_logic;
		--output
		PHI_0 : Out std_logic;
		PHI_90 : Out std_logic
	);
end component;


component frequencyCal is
	Port
	(
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
		DE   : Out std_logic;   -- display enable
		OFLOWX : Out std_logic
	);
	
end component;

component displayInterface is
	Port
	(
		HEXA : in std_logic_vector(3 downto 0);
		HEXB : in std_logic_vector(3 downto 0);
		HEXC : in std_logic_vector(3 downto 0);
		HEXD : in std_logic_vector(3 downto 0);
		DE   : in std_logic;
		RES  : in std_logic;
		
		DIGIT : out std_logic_vector(7 downto 0);
		DIGEN : out std_logic_vector(3 downto 0)
	);
	
end component;
-- signal
--signal MCLK_s: std_logic; 
signal  SI_s : std_logic := '0';
signal  CLK_s : std_logic := '0'; 
signal  RES_s : std_logic := '0';
signal  RESET_s : std_logic := '0';
signal HEXA_s, HEXB_s, HEXC_s, HEXD_s, DIGEN_s : std_logic_vector(3 downto 0):= (others => '0');
Signal DE_s : std_logic := '0';

begin

M_CLK_DIV : clockDiv2 
	port map(
		MCLK => MCLK,
		CLK => CLK_s -- created internal clock. 
	);


M_SYNC_RESET : sync 
	port map(
		CLR         => CLR,   -- D
		CLK         => CLK_s,   -- CLOCK
		RESET       => RESET_s,  -- Active High Reset will never reset. 
		RES         => RES_s    -- Output 
	);
	
M_SYNC_SI : sync2 
	port map(
		SENSOR_IN  	=> SENSOR_IN,	 	-- D
		CLK         => CLK_s,		-- CLOCK
		RES         => RES_s,  		-- Active High Reset+++++
		SI          => SI_s   		-- Output 
	);
	
	
M_PhaseShifter : PhaseShifter
	port map(
		SI  => SI_s,
		CLK => CLK_s,
		RES => RES_s,
		--output
		PHI_0 => PHI_0,
		PHI_90 => PHI_90
	);
	
M_Freq_Cal : frequencyCal 
	port map (
		SI  => SI_s,
		CLK => CLK_s,
		RES => RES_s,
		SW  => SW,
		-- output
		LED => LED,
		DA  => HEXA_s,
		DB  => HEXB_s,
		DC  => HEXC_s,
		DD  => HEXD_s,
		DE  => DE_s,
		OFLOWX => OFLOW
		);

M_Display : displayInterface
	port map(
		HEXA => HEXA_s,
		HEXB => HEXB_s,
		HEXC => HEXC_s,
		HEXD => HEXD_s,
		DE   => DE_s,
		RES  => RES_s,
		
		DIGIT => DIGIT,
		DIGEN => DIGEN
	);
	
end struct;