-- Library
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use ieee.numeric_std.All;
Entity frequencyCal Is
	Port
	(
		SI  : In std_logic; -- Input Signal
		CLK : In std_logic; -- CLOCK
		RES : In std_logic;
		SW1 : In std_logic;
		SW2 : In std_logic;
		-- output
		SEVEN_SEGMENT_OUT : Out std_logic_vector(6 Downto 0);
		SEGMENT_EN        : Out std_logic_vector(3 Downto 0);
		LED1              : Out std_logic;
		LED2              : Out std_logic
	);
End frequencyCal;
-- Architecture Declaration
Architecture rtl Of frequencyCal Is
	Signal muxInput        : std_logic_vector(3 Downto 0) := (Others => '0');
	Signal segmentOut      : std_logic_vector(6 Downto 0) := (Others => '0');
	Constant resetMuxInput : std_logic_vector(3 Downto 0) := "0000";
	Constant clkTouS       : Integer := 4999; -- given that clock 50mhz
	--Constant SegmentTimeSplice : Integer := 10; -- 10ms
	Constant clkFreq : Integer := 50e6; -- 50mhz
	Signal Ticks     : Integer := 0;
	Signal SI_Freq   : Integer := 0;
	-- Store SI Frequency in digits
	Signal Unit, Unit_P, Ten, Ten_P, Hundred, Hundred_P, Thousand, Thousand_P, TenThousand, TenThousand_P, HundredThousand, HundredThousand_P : Integer  := 0;
	-- Seven Segment Timing
	Signal whichSegment : Integer := 0; -- which segment to display 0 to 3 for 4 display
	-- Creating real world timing.
	Signal timingCounter                                    : Integer := 0;
	Signal uS_100, mS_1, mS_10, mS_100, Second_1, Second_10 : Integer := 0;
	-- Function output seven segment display
	
	Signal resetDigitalCounter : std_logic := '0'; -- 1 will reset 
	Function sevenSegmentOut(muxInpuVal : std_logic_vector(3 Downto 0) := "0000") Return std_logic_vector Is
	Begin
		-- function code
		Case(muxInpuVal) Is
			When "0000"  => Return "0000001"; -- 0
			When "0001"  => Return "1001111"; -- 1
			When "0010"  => Return "0010010"; -- 2
			When "0011"  => Return "0000110"; -- 3
			When "0100" => Return "1001100"; -- 4
			When "0101" => Return "0100100"; -- 5
			When "0110" => Return "0100000"; -- 6
			When "0111" => Return "0001111"; -- 7
			When "1000" => Return "0000000"; -- 8
			When "1001" => Return "0000100"; -- 9
			When Others     => Return "0000001"; -- display 0 when error
		End Case;
	End Function;
	-- increments value
	Procedure IncrementWrap(
		Signal Counter     : Inout Integer;
		Constant WrapValue : In Integer;
		Constant Enable    : In Boolean;
	Variable Wrapped   : Out Boolean) Is
		Begin
			If Enable Then
				If Counter = WrapValue - 1 Then
					Wrapped := true;
					Counter <= 0;
				Else
					Wrapped := false;
					Counter <= Counter + 1;
				End If;
			End If;
		END PROCEDURE;
			begin  -- start of rtl
			--
			-- end procedure;
			-- start of process
			process(mS_100)  -- every second reset the si freq counters 
			Begin
				if mS_100 = 5 then
				resetDigitalCounter <= not resetDigitalCounter;
				end if;
			End Process;
			
			Process (SI, resetDigitalCounter)
			Variable Wrap : Boolean;
			Variable U,T,H,Th,TTh,HTh : Integer range 0 to 10;
			begin
			
				if rising_edge(resetDigitalCounter) then 
				U := Unit; 
				T := Ten;
				H := Hundred;
				Th := Thousand;
				TTh := TenThousand;
				HTh := HundredThousand;
				
				Unit_P <= U;
				Ten_p <= T;
				Hundred_P <= H;
				Thousand_P <= Th;
				TenThousand_P <= TTh;
				HundredThousand_P <= HTh;
				
				Unit <= 0; 
				Ten <= 0;
				Hundred <= 0;
				Thousand <= 0;
				TenThousand <= 0;
				HundredThousand <= 0;		
				else 
				
				If rising_edge(SI) Then
								IncrementWrap(Unit, 10, true, Wrap);
								IncrementWrap(Ten, 10, Wrap, Wrap);
								IncrementWrap(Hundred, 10, Wrap, Wrap);
								IncrementWrap(Thousand, 10, Wrap, Wrap);
								IncrementWrap(TenThousand, 10, Wrap, Wrap);
								IncrementWrap(HundredThousand, 10, Wrap, Wrap);
				End If;
end if;
			End Process;

			Process (mS_1)
				Variable tempVal : Integer;
				Begin
				End Process;
				-- Process Declaration
				-- Output seven segment display
				Process (CLK, RES)
				Variable Wrap : Boolean;
					Begin
						If RES = '1' Then
							segmentOut <= sevenSegmentOut(resetMuxInput); -- display 0 on all of the display when reset.
						Else
							-- on rising edge check signal then set output
							If rising_edge (CLK) Then
								IncrementWrap(timingCounter, clkTouS, true, Wrap);
								IncrementWrap(uS_100, 10, Wrap, Wrap);
								IncrementWrap(mS_1, 10, Wrap, Wrap);
								IncrementWrap(mS_10, 10, Wrap, Wrap);
								IncrementWrap(mS_100, 10, Wrap, Wrap);
								IncrementWrap(Second_1, 10, Wrap, Wrap);
								IncrementWrap(Second_10, 10, Wrap, Wrap);
							End If;
						End If;
					End Process;
					Process (mS_10)
					Variable Wrap : Boolean;
						Begin
							IncrementWrap(whichSegment, 4, true, Wrap);
						End Process;
						Process (whichSegment)
							Begin
								Case (whichSegment) Is
									When 0 =>
										If (HundredThousand_P > 0) Then
											muxInput <= std_logic_vector(to_unsigned(Hundred_P, muxInput'length));
										Elsif (TenThousand_P > 0) Then
											muxInput <= std_logic_vector(to_unsigned(Ten_P, muxInput'length));
										Else
											muxInput <= std_logic_vector(to_unsigned(Unit_P, muxInput'length));
										End If;
										SEGMENT_EN <= "1000";
									When 1 =>
										If (HundredThousand_P > 0) Then
											muxInput <= std_logic_vector(to_unsigned(Thousand_P, muxInput'length));
										Elsif (TenThousand_P > 0) Then
											muxInput <= std_logic_vector(to_unsigned(Hundred_P, muxInput'length));
										Else
											muxInput <= std_logic_vector(to_unsigned(Ten_P, muxInput'length));
										End If;
										SEGMENT_EN <= "0100";
									When 2 =>
										If (HundredThousand_P > 0) Then
											muxInput <= std_logic_vector(to_unsigned(TenThousand_P, muxInput'length));
										Elsif (TenThousand_P > 0) Then
											muxInput <= std_logic_vector(to_unsigned(Thousand_P, muxInput'length));
										Else
											muxInput <= std_logic_vector(to_unsigned(Hundred_P, muxInput'length));
										End If;
										SEGMENT_EN <= "0010";
									When 3 =>
										If (HundredThousand_P > 0) Then
											muxInput <= std_logic_vector(to_unsigned(HundredThousand_P, muxInput'length));
										Elsif (TenThousand_P > 0) Then
											muxInput <= std_logic_vector(to_unsigned(TenThousand_P, muxInput'length));
										Else
											muxInput <= std_logic_vector(to_unsigned(Thousand_P, muxInput'length));
										End If;
										SEGMENT_EN              <= "0001";
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
							Process (muxInput)
								Begin
									SEVEN_SEGMENT_OUT <= sevenSegmentOut(muxInput);
								End Process;
								--SEVEN_SEGMENT_OUT <= segmentOut;
								-- END
End rtl;