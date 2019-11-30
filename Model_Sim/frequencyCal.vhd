-- Library
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use ieee.numeric_std.All;

Entity frequencyCal Is
	Port (
		SI : In std_logic; -- Input Signal
		CLK : In std_logic; -- CLOCK
		RES : In std_logic;
		SW1 : In std_logic;
		SW2 : In std_logic; 
		-- output
		SEVEN_SEGMENT_OUT : Out std_logic_vector(6 Downto 0);
		SEGMENT_EN_0 : Out std_logic;
		SEGMENT_EN_1 : Out std_logic;
		SEGMENT_EN_2 : Out std_logic;
		SEGMENT_EN_3 : Out std_logic;
		LED1 : Out std_logic;
		LED2 : Out std_logic 
	);
End frequencyCal;

-- Architecture Declaration
Architecture rtl Of frequencyCal Is
	Signal muxInput : std_logic_vector(3 Downto 0) := (Others => '0');
	Signal segmentOut : std_logic_vector(6 Downto 0) := (Others => '0');
	Constant resetMuxInput : std_logic_vector(3 Downto 0) := "0000";
	Constant miliSecondroll : Integer := 4999; -- given that clock 50mhz
	Constant SegmentTimeSplice : Integer := 10; -- 10ms 
	constant clkFreq		: Integer := 50e6; -- 50mhz
	Signal Ticks : Integer := 0;
	Signal SI_Freq : Integer := 0;
	Signal Unit, Unit_P : Integer := 0;
	Signal Ten, Ten_P  : Integer := 0;
	Signal Hundred, Hundred_P : Integer := 0;
	Signal Thousand, Thousand_P : Integer := 0;
	Signal TenThousand, TenThousand_P : Integer := 0;
	Signal HundredThousand, HundredThousand_P : Integer := 0;
	Signal whichSegment : Integer := 0; -- which segment to display 0 to 3 for 4 display
	Signal timingCounter : Integer := 0;
	Signal millisecond : Integer := 0; -- for displaying single seven segment
	Signal Hundred_uS : Integer := 0; 
	Function sevenSegmentOut(muxInpuVal : std_logic_vector(3 Downto 0) := "0000") Return std_logic_vector Is
	-- local variable (temp)
	Variable returnValue : std_logic_vector(6 Downto 0);
Begin
	-- function code
	Case(muxInpuVal) Is
		When "0000" => 
			returnValue := "0000001"; -- 0
		When "0001" => 
			returnValue := "1001111"; -- 1
		When "0010" => 
			returnValue := "0010010"; -- 2
		When "0011" => 
			returnValue := "0000110"; -- 3
		When "0100" => 
			returnValue := "1001100"; -- 4
		When "0101" => 
			returnValue := "0100100"; -- 5
		When "0110" => 
			returnValue := "0100000"; -- 6
		When "0111" => 
			returnValue := "0001111"; -- 7
		When "1000" => 
			returnValue := "0000000"; -- 8
		When "1001" => 
			returnValue := "0000100"; -- 9
		When Others => 
			returnValue := "0000001"; -- display 0 when error
	End Case;

	--return statment Return returnValue;
	return returnValue;
End Function;
-- increments value
Procedure IncrementWrap(
	Signal Counter : Inout Integer;
	Constant WrapValue : In Integer;
	Constant Enable : In Boolean;
	Variable Wrapped : Out Boolean) Is
Begin
	If Enable Then
		If Counter = WrapValue Then
			Wrapped := true;
			Counter <= 0;
		Else
			Wrapped := false;
			Counter <= Counter + 1;
		End If;
	End If;
End Procedure; 
 
Begin
	Process (CLK, SI)
	Variable tempVal : integer;
	Begin
		If rising_edge(SI) Then
		tempVal := clkFreq / (Ticks);
		SI_Freq <= tempVal;

		Ticks <= 0;
		End If;
 
		If rising_edge(CLK) Then
			-- Cascade counters
			Ticks <= Ticks + 1;

		End If;
	End Process;
	
	process (millisecond) 
	variable tempVal : integer;
	begin 
		Unit_P <= SI_Freq mod 10;
		tempVal := SI_Freq / 10;  -- consider var * (1/10)
		Ten_P <= tempVal mod 10;
		tempVal := tempVal /10;
		Hundred_P <= tempVal mod 10;
		tempVal := tempVal /10;
		Thousand_P <= tempVal mod 10;
		tempVal := tempVal /10;
		TenThousand_P <= tempVal mod 10;
		tempVal := tempVal /10;
		HundredThousand_P <= tempVal mod 10;
	end process;

	-- Process Declaration
	-- Output seven segment display
	Process (CLK, RES)
	Variable Wrap : Boolean;
		Begin
			If RES = '1' Then
				segmentOut <= sevenSegmentOut(resetMuxInput); -- display 0 on all of the display when reset.
			Else
				-- on rising edge check signal then set output
				If falling_edge(CLK) Then
					IncrementWrap(timingCounter, miliSecondroll, true, Wrap);
					IncrementWrap(Hundred_uS,  10, Wrap, Wrap);
					IncrementWrap(millisecond, SegmentTimeSplice, Wrap, Wrap);
					IncrementWrap(whichSegment, 3, Wrap, Wrap);
 
				End If; 
			End If;
		End Process;

		Process (whichSegment)
			Begin
				Case (whichSegment) Is
					When 0 => 
						muxInput <= std_logic_vector(to_unsigned(Unit_P, muxInput'length)); 
						SEGMENT_EN_0 <= '1'; SEGMENT_EN_1 <= '0'; SEGMENT_EN_2 <= '0'; SEGMENT_EN_3 <= '0'; 
					
					When 1 => 
						muxInput <= std_logic_vector(to_unsigned(Ten_P, muxInput'length));
						SEGMENT_EN_0 <= '0'; SEGMENT_EN_1 <= '1'; SEGMENT_EN_2 <= '0'; SEGMENT_EN_3 <= '0'; 
					
					When 2 => 
						muxInput <= std_logic_vector(to_unsigned(Hundred_P, muxInput'length));
						SEGMENT_EN_0 <= '0'; SEGMENT_EN_1 <= '0'; SEGMENT_EN_2 <= '1'; SEGMENT_EN_3 <= '0'; 
					
					When 3 => 
						muxInput <= std_logic_vector(to_unsigned(Thousand_P, muxInput'length));
						SEGMENT_EN_0 <= '0'; SEGMENT_EN_1 <= '0'; SEGMENT_EN_2 <= '0'; SEGMENT_EN_3 <= '1'; 

					When Others => muxInput <= resetMuxInput; -- display 0 when error
				End Case;

				If TenThousand_P > 0 Then
					LED1 <= '1';
				Else
					LED1 <= '0';
				End If;

				If HundredThousand_P > 0 Then
					LED2 <= '1';
				Else
					LED2 <= '0';

				End If;
			End Process;
			
process(muxInput) 
begin 
	 
	SEVEN_SEGMENT_OUT <= sevenSegmentOut(muxInput);
	
end process;

--SEVEN_SEGMENT_OUT <= segmentOut; 
			-- END
End rtl;