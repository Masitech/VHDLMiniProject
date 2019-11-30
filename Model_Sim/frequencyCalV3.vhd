library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity frequencyCal Is
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
		DE : Out std_logic ;  -- display enable
		OFLOWX : Out std_logic
	);
End frequencyCal;
-- Architecture Declaration
Architecture rtl Of frequencyCal Is
-- signals, functions, procedure, componet 
Signal DE_s : std_logic := '0'; -- display enable
Signal LD_s : std_logic := '0'; -- load data
Signal CE_s : std_logic := '0';  -- pulse 
Signal CE_i : std_logic := '0';  -- pulse indimate 

Signal Unit,Unit_P, Ten, Ten_P, Hundred, Hundred_P, Thousand,Thousand_P, TenThousand,TenThousand_P, HundredThousand, HundredThousand_P : std_logic_vector(3 downto 0):= (Others => '0');
signal OFLOW_U, OFLOW_T, OFLOW_H, OFLOW_Th, OFLOW_TTh, OFLOW_HTh : std_logic := '0';
signal div50k_s : std_logic_vector(15 downto 0) := (Others => '0');
signal second_1_Counter_s : std_logic_vector(6 downto 0) := (others => '0');
signal second_1_Tick_s : std_logic := '0';
signal ERROR_OVFLOW : std_logic := '0';
signal CounterReset : std_logic := '0';

--single counter 
  component BinaryCounter
    port(
	 CE: in std_logic;
 	 CLK: in std_logic;
 	 RESET: in std_logic;
 	 Output: out std_logic_vector(0 to 3);
	 OFLOW : out std_logic
    );
 end component;
 
begin  -- start of rtl

 -- instance of componets and port map componet port to signal 
   Unit_PM:BinaryCounter port map( --x1
	 CE  => CE_s,
 	 CLK => CLK,
 	 RESET => CounterReset,
 	 Output => Unit,
	 OFLOW => OFLOW_U
   );
   
   Ten_PM:BinaryCounter port map( --x10
	 CE  => OFLOW_U,
 	 CLK => CLK,
 	 RESET => CounterReset,
 	 Output => Ten,
	 OFLOW => OFLOW_T
   );
   
    Hundred_PM:BinaryCounter port map( --x100
	 CE  => OFLOW_T,
 	 CLK => CLK,
 	 RESET => CounterReset,
 	 Output => Hundred,
	 OFLOW => OFLOW_H
   );
   
     Thousand_PM:BinaryCounter port map( --x1000
	 CE  => OFLOW_H,
 	 CLK => CLK,
 	 RESET => CounterReset,
 	 Output => Thousand,
	 OFLOW => OFLOW_Th
   );
   
     TenThousand_PM:BinaryCounter port map( --x10000
	 CE  => OFLOW_Th,
 	 CLK => CLK,
 	 RESET => CounterReset,
 	 Output => TenThousand,
	 OFLOW => OFLOW_TTh
   );
   
	HundredThousand_PM:BinaryCounter port map( --x100000
	 CE  => OFLOW_TTh,
 	 CLK => CLK,
 	 RESET => CounterReset,
 	 Output => HundredThousand,
	 OFLOW => OFLOW_HTh
   );
   
   
-- process 
	CE_s <= (not CE_i) and SI; -- CE pluse gen every time SI changes 
	OFLOWX <= ERROR_OVFLOW;
	
	pulseGen : process (CLK, RES)	
	begin
		if RES = '1' then 
			CE_i <= '0';
		else 
			if rising_edge(CLK) then
				CE_i <= SI;
			end if;
		end if;
	end process;
	
	-- si freq too high 
	OverFlowErr : process(OFLOW_HTh, RES) 
			begin 
			if RES = '1' then 
				ERROR_OVFLOW <= '0';
			elsif rising_edge(OFLOW_HTh) then
				ERROR_OVFLOW <= '1';
				end if;
			end process;
	
	div50K : process (CLK, RES)
	begin 
	if RES = '1' then 
		div50k_s <= "0000000000000000";   
	elsif rising_edge(CLK) then 
		if div50k_s = "1100001101010000" then   -- when reaches 50k in decimal reset counter 
				div50k_s <= "0000000000000000";
				LD_s <= not LD_s;				-- 10ms period 
			else 
				div50k_s <= div50k_s + 1;
		end if; 
	end if;
	end process;
	
	
	second_1_tick : process(LD_s,RES)
	begin 
	if RES = '1' then 
		second_1_Counter_s <= "0000000";
	elsif rising_edge(LD_s) then 
		if second_1_Counter_s = "0110010" then  -- its actall half second but rising + falling = 1 second 
			second_1_Counter_s <= "0000000";
			second_1_Tick_s <= not second_1_Tick_s;			
		else 
			second_1_Counter_s <= second_1_Counter_s + 1;
		end if;
end if;
	end process; 
	
	
	-- every one second it reset the binary counter, RES input also reset the counters along with the timers 
	resetBCounters : process(CLK, RES, second_1_Tick_s)
	variable resetTiming:   integer := 0;
	begin
	if RES = '1' then 
		CounterReset <= '1';
	elsif rising_edge(second_1_Tick_s) then 
	
		Unit_P 	<= Unit;
		Ten_P 	<= Ten;
		Hundred_P <= Hundred;
		Thousand_P <= Thousand;
		TenThousand_P <= TenThousand;
		HundredThousand_P <= HundredThousand;
		
		CounterReset <= '1';
	elsif CounterReset = '1' then 
		--if rising_edge(CLK) then 
			resetTiming := resetTiming +1;
			if resetTiming = 5 then 
				CounterReset <= '0';
			end if;
		--end if;
	end if;
	end process;
	
	
	sync_LD_S : process(CLK) 
	begin 
		if RES = '1' then
		 DE <= '0'; 
		elsif rising_edge(CLK) then 
			DE <= LD_s;
		end if;
	end process;
	
	
	switchLED : process (CLK, SW)
	begin
		case(SW) is
			when "00" =>
				DA <= Unit_P; DB <= Ten_P; DC <= Hundred_P; DD <= Thousand_P;
				LED <= "00";
			when "01" => 
				DA <= Ten_P; DB <= Hundred_P; DC <= Thousand_P; DD <= TenThousand_P;
				LED <= "01";
			when "10" => 
				DA <= Ten_P; DB <= Hundred_P; DC <= Thousand_P; DD <= TenThousand_P;
				LED <= "10";
			when "11" => 
				DA <= Hundred_P; DB <= Thousand_P; DC <= TenThousand_P; DD <= HundredThousand_P;
				LED <= "11";
			When others =>
				DA <= Unit_P; DB <= Ten_P; DC <= Hundred_P; DD <= Thousand_P;
				LED <= "00";
		end case;
	end process;
End rtl;
