-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019
-- File Info : Calculates the frequency of input signal by sampling the rising edge of SI for 1 real second. 
-- This is done using casacded 4 bit binary counter with synchronous clock and clock enable (which also acts as 
-- over flow). Every 1 second the counter is resets and starts counting from the begining again. Hence the freqency on will update every 1 second. 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY frequencyCal IS
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
END frequencyCal;
-- Architecture Declaration
ARCHITECTURE rtl OF frequencyCal IS
   -- signals, functions, procedure, componet
   SIGNAL DE_s : std_logic := '0'; -- display enable
   SIGNAL LD_s : std_logic := '0'; -- load data
   SIGNAL CE_s : std_logic := '0'; -- pulse
   SIGNAL CE_i : std_logic := '0'; -- pulse intimediate 
   SIGNAL Unit, Unit_P, Ten, Ten_P, Hundred, Hundred_P, Thousand, Thousand_P, TenThousand, TenThousand_P, HundredThousand, HundredThousand_P : std_logic_vector(3 DOWNTO 0);
   SIGNAL OFLOW_U, OFLOW_T, OFLOW_H, OFLOW_Th, OFLOW_TTh, OFLOW_HTh : std_logic := '0';
   SIGNAL div50k_s : std_logic_vector(15 DOWNTO 0);
   SIGNAL second_1_Counter_s : std_logic_vector(25 DOWNTO 0);
   SIGNAL second_1_Tick_s : std_logic;
   SIGNAL ERROR_OVFLOW : std_logic;
   SIGNAL CounterReset : std_logic;
   -- Componet def of a 4 bit binary counter with clock enable 
   COMPONENT BinaryCounter
      PORT
      (
         CE      : IN std_logic;
         CLK     : IN std_logic;
         RESET   : IN std_logic;
         Output  : OUT std_logic_vector(0 TO 3);
         OFLOW   : OUT std_logic
      );
   END COMPONENT;
BEGIN
   -- start of rtl
   -- Casaceded instances of binary counter conected to each other. 
   Unit_PM : BinaryCounter
   PORT MAP
   (--x1
      CE      => CE_s,
      CLK     => CLK,
      RESET   => CounterReset,
      Output  => Unit,
      OFLOW   => OFLOW_U
   );
   Ten_PM : BinaryCounter
   PORT MAP
   (--x10
      CE      => OFLOW_U,
      CLK     => CLK,
      RESET   => CounterReset,
      Output  => Ten,
      OFLOW   => OFLOW_T
   );
   Hundred_PM : BinaryCounter
   PORT MAP
   (--x100
      CE      => OFLOW_T,
      CLK     => CLK,
      RESET   => CounterReset,
      Output  => Hundred,
      OFLOW   => OFLOW_H
   );
   Thousand_PM : BinaryCounter
   PORT MAP
   (--x1000
      CE      => OFLOW_H,
      CLK     => CLK,
      RESET   => CounterReset,
      Output  => Thousand,
      OFLOW   => OFLOW_Th
   );
   TenThousand_PM : BinaryCounter
   PORT MAP
   (--x10000
      CE      => OFLOW_Th,
      CLK     => CLK,
      RESET   => CounterReset,
      Output  => TenThousand,
      OFLOW   => OFLOW_TTh
   );
   HundredThousand_PM : BinaryCounter
   PORT MAP
   (--x100000
      CE      => OFLOW_TTh,
      CLK     => CLK,
      RESET   => CounterReset,
      Output  => HundredThousand,
      OFLOW   => OFLOW_HTh
   );

   CE_s <= (NOT CE_i) AND SI; -- CE pluse gen every time SI changes
   OFLOWX <= ERROR_OVFLOW;
	
	-- Creates 1 cycle pluse every time SI changes. 
   pulseGen : PROCESS (CLK, RES)
   BEGIN
      IF RES = '1' THEN
         CE_i <= '0';
      ELSE
         IF rising_edge(CLK) THEN
            CE_i <= SI;
         END IF;
      END IF;
   END PROCESS;
   
	-- si freq too high, the overflow pin will go high, if the data overflows above: 999999
   OverFlowErr : PROCESS (OFLOW_HTh, RES)
   BEGIN
      IF RES = '1' THEN
         ERROR_OVFLOW <= '0';
      ELSIF rising_edge(OFLOW_HTh) THEN
         ERROR_OVFLOW <= '1';
      END IF;
   END PROCESS;
   
	-- new clock for time splicing the out of the seven segment display. 50mhz/50k = 1ms period 
	div50K : PROCESS (CLK, RES)
   BEGIN
      IF RES = '1' THEN
         div50k_s <= "0000000000000000";
      ELSIF rising_edge(CLK) THEN
         IF div50k_s = "1100001101010000" THEN -- when reaches 50k in decimal reset counter
            div50k_s <= "0000000000000000";
            LD_s <= NOT LD_s; -- 1ms period
         ELSE
            div50k_s <= div50k_s + 1;
         END IF;
      END IF;
   END PROCESS;

	-- new clock from main clock for 1 second counter 50mhz/50e6 = 1
   second_1_tick : PROCESS (CLK, RES)
      VARIABLE U, T, H, Th, TTh, HTh : std_logic_vector(3 DOWNTO 0);
   BEGIN
      IF RES = '1' THEN
         CounterReset <= '1';
         second_1_Counter_s <= (OTHERS => '0');
      ELSIF rising_edge(CLK) THEN
         IF second_1_Counter_s = "10111110101111000010000000" THEN -- its actall half second but rising + falling = 1 second
            second_1_Counter_s <= (OTHERS => '0');
            second_1_Tick_s <= NOT second_1_Tick_s;
            U := Unit;
            T := Ten;
            H := Hundred;
            Th := Thousand;
            TTh := TenThousand;
            HTh := HundredThousand;
            Unit_P <= U;
            Ten_P <= T;
            Hundred_P <= H;
            Thousand_P <= Th;
            TenThousand_P <= TTh;
            HundredThousand_P <= HTh;

            CounterReset <= '1';
         ELSE
            second_1_Counter_s <= second_1_Counter_s + 1;
            CounterReset <= '0';
         END IF;
      END IF;
   END PROCESS;

	-- output the signal using DFF, for display module (timing)
   sync_LD_S : PROCESS (CLK)
   BEGIN
      IF RES = '1' THEN
         DE <= '0';
      ELSIF rising_edge(CLK) THEN
         DE <= LD_s;
      END IF;
   END PROCESS;

   -- Loads the data from binary counter output to module output. 
   switchLED : PROCESS (CLK, SW)
   BEGIN
      CASE(SW) IS
         WHEN "00" =>
            DA <= Unit_P;
            DB <= Ten_P;
            DC <= Hundred_P;
            DD <= Thousand_P;
            LED <= "00";
         WHEN "01" =>
            DA <= Ten_P;
            DB <= Hundred_P;
            DC <= Thousand_P;
            DD <= TenThousand_P;
            LED <= "01";
         WHEN "10" =>
            DA <= Ten_P;
            DB <= Hundred_P;
            DC <= Thousand_P;
            DD <= TenThousand_P;
            LED <= "10";
         WHEN "11" =>
            DA <= Hundred_P;
            DB <= Thousand_P;
            DC <= TenThousand_P;
            DD <= HundredThousand_P;
            LED <= "11";
         WHEN OTHERS =>
            DA <= Unit_P;
            DB <= Ten_P;
            DC <= Hundred_P;
            DD <= Thousand_P;
            LED <= "00";
      END CASE;
   END PROCESS;
END rtl;