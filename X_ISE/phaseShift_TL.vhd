-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019
-- Info : Top level file for the project, brings together all of the submodules
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY phaseShift_TL IS
   PORT
   (
      MCLK       : IN STD_LOGIC;
      CLR        : IN STD_LOGIC;
      SW         : IN std_logic_vector(1 DOWNTO 0);
      SENSOR_IN  : IN STD_LOGIC;

      -- OUTPUT
      PHI_0      : OUT STD_LOGIC;
      PHI_90     : OUT STD_LOGIC;
      DIGIT      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      DIGEN      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      LED        : OUT std_logic_vector(1 DOWNTO 0);
      OFLOW      : OUT std_logic
         );
END phaseShift_TL;
ARCHITECTURE struct OF phaseShift_TL IS
   -- DIV2 Components - Creates system clock for phaseshift
   COMPONENT clockDiv2 IS
      PORT
      (
         MCLK  : IN STD_LOGIC; -- Master Clock input
         CLK   : OUT STD_LOGIC
      ); -- clock output
   END COMPONENT;
   -- SYNC Components : sync reset of all internal links to button on board
   COMPONENT sync IS
      PORT
      (
         CLR    : IN std_logic; -- D
         CLK    : IN std_logic; -- CLOCK
         RESET  : IN std_logic; -- Active High Reset
         RES    : OUT std_logic -- Output
      );
   END COMPONENT;
   -- SYNC2 Components : Sync input
   COMPONENT sync2 IS
      PORT
      (
         SENSOR_IN  : IN std_logic; -- D
         CLK        : IN std_logic; -- CLOCK
         RES        : IN std_logic; -- Active High Reset
         SI         : OUT std_logic -- Output
      );
   END COMPONENT;
   COMPONENT PhaseShifter IS
      PORT
      (
         --input
         SI      : IN std_logic;
         CLK     : IN std_logic;
         RES     : IN std_logic;
         --output
         PHI_0   : OUT std_logic;
         PHI_90  : OUT std_logic
      );
   END COMPONENT;
   COMPONENT frequencyCal IS
      PORT
      (
         SI      : IN std_logic; -- Input Signal
         CLK     : IN std_logic; -- CLOCK
         RES     : IN std_logic;
         SW      : IN std_logic_vector(1 DOWNTO 0);
         -- output
         LED     : OUT std_logic_vector(1 DOWNTO 0);
         DA      : OUT std_logic_vector(3 DOWNTO 0);
         DB      : OUT std_logic_vector(3 DOWNTO 0);
         DC      : OUT std_logic_vector(3 DOWNTO 0);
         DD      : OUT std_logic_vector(3 DOWNTO 0);
         DE      : OUT std_logic; -- display enable
         OFLOWX  : OUT std_logic
      );
   END COMPONENT;
   COMPONENT displayInterface IS
      PORT
      (
         HEXA   : IN std_logic_vector(3 DOWNTO 0);
         HEXB   : IN std_logic_vector(3 DOWNTO 0);
         HEXC   : IN std_logic_vector(3 DOWNTO 0);
         HEXD   : IN std_logic_vector(3 DOWNTO 0);
         DE     : IN std_logic;
         RES    : IN std_logic;
         DIGIT  : OUT std_logic_vector(7 DOWNTO 0);
         DIGEN  : OUT std_logic_vector(3 DOWNTO 0)
      );
   END COMPONENT;
   -- signal
   --signal MCLK_s: std_logic;
   SIGNAL SI_s : std_logic := '0';
   SIGNAL CLK_s : std_logic := '0';
   SIGNAL RES_s : std_logic := '0';
   SIGNAL RESET_s : std_logic := '0';
   SIGNAL HEXA_s, HEXB_s, HEXC_s, HEXD_s, DIGEN_s : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
   SIGNAL DE_s : std_logic := '0';
BEGIN
   M_CLK_DIV : clockDiv2
   PORT MAP
   (
      MCLK  => MCLK,
      CLK   => CLK_s -- created internal clock.
   );
   M_SYNC_RESET : sync
   PORT MAP
   (
      CLR    => CLR, -- D
      CLK    => CLK_s, -- CLOCK
      RESET  => RESET_s, -- Active High Reset will never reset.
      RES    => RES_s -- Output
   );
   M_SYNC_SI : sync2
   PORT MAP
   (
      SENSOR_IN  => SENSOR_IN, -- D
      CLK        => CLK_s, -- CLOCK
      RES        => RES_s, -- Active High Reset+++++
      SI         => SI_s -- Output
   );

   M_PhaseShifter : PhaseShifter
   PORT MAP
   (
      SI      => SI_s,
      CLK     => CLK_s,
      RES     => RES_s,
      --output
      PHI_0   => PHI_0,
      PHI_90  => PHI_90
   );
   M_Freq_Cal : frequencyCal
   PORT MAP
   (
      SI      => SI_s,
      CLK     => CLK_s,
      RES     => RES_s,
      SW      => SW,
      -- output
      LED     => LED,
      DA      => HEXA_s,
      DB      => HEXB_s,
      DC      => HEXC_s,
      DD      => HEXD_s,
      DE      => DE_s,
      OFLOWX  => OFLOW
   );
   M_Display : displayInterface
   PORT MAP
   (
      HEXA   => HEXA_s,
      HEXB   => HEXB_s,
      HEXC   => HEXC_s,
      HEXD   => HEXD_s,
      DE     => DE_s,
      RES    => RES_s,

      DIGIT  => DIGIT,
      DIGEN  => DIGEN
   );
END struct;