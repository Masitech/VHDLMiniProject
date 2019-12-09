Library IEEE;
Use IEEE.std_logic_1164.All;
Use IEEE.numeric_std.All;

Entity PhaseShifter Is
	Port (
		--input
		SI : In std_logic;
		CLK : In std_logic;
		RES : In std_logic;
		--output
		PHI_0 : Out std_logic;
		PHI_90 : Out std_logic;
		OFLOW : Out std_logic
	);
End;

Architecture rtl Of PhaseShifter Is
	-- clk div 2
	Signal TOGGLE : std_logic;
	-- counter A
	Signal CEA : std_logic;
	Signal TCU1 : std_logic;

	-- counter B .
	Signal CEB : std_logic;
	Signal TCU2 : std_logic;

	Signal TCU_XNOR_SI : std_logic;

Begin
	-- create toggle secondary clock
	Toggle_create : Process (CLK, RES) Is
		Variable toggleCounter : Integer Range 0 To 1;
	Begin
		If rising_edge(CLK) Then
			If RES = '1' Then
				TOGGLE <= '0';
			Else
				TOGGLE <= Not TOGGLE;
			End If;
		End If;
	End Process;
 
	-- Create CEA, CEB Signal
	CEX_logic : Process (TOGGLE, SI) Is
	Begin
		CEA <= (SI And TOGGLE) Or (Not SI);
		CEB <= ((Not SI) And TOGGLE) Or SI;
	End Process;
 
	-- Counter A
	CounterA : Process (CLK, CEA, RES, SI) Is
		Variable eventCounterA1 : Integer  := 0; -- numeric
		Variable eventCounterA2 : Integer  := 0; -- numeric
	Begin
		If RES = '1' Then
			TCU1 <= '0';
			else
			-- reset counter, TCU1 LOW, disable counting
			If rising_edge(SI) Then
				eventCounterA1 := 0;
				eventCounterA2 := 0;
				TCU1 <= '0';
			End If;
 
			If falling_edge(SI) Then
	
			End If;
 
			-- Is falling edge and counter is enabled then count. If it reaches the roll over value then. Set
			If rising_edge(CEA) AND SI = '1' Then
					eventCounterA1 := eventCounterA1 + 1;	
			End If;
			
			if rising_edge(CLK) AND SI = '0' then
					eventCounterA2 := eventCounterA2 + 1;
					if eventCounterA2 = eventCounterA1 then
						TCU1 <= '1'; -- output high
					end if;
				end if;
			end if;
	End Process;
 
 
 	-- Counter B
	CounterB : Process (CLK, CEB, RES, SI) Is
		Variable eventCounterB1 : Integer := 0; -- numeric
		Variable eventCounterB2 : Integer := 0; -- numeric
	Begin
		If RES = '1' Then
			TCU2 <= '0';
			else

			If falling_edge(SI) Then
				eventCounterB1 := 0;
				eventCounterB2 := 0;
				TCU2 <= '0';
			End If;
 
			-- Is falling edge and counter is enabled then count. If it reaches the roll over value then. Set
			If rising_edge(CEB) AND SI = '0' Then
					eventCounterB1 := eventCounterB1 + 1;	
			End If;
			
			if rising_edge(CLK) AND SI = '1' then
					eventCounterB2 := eventCounterB2 + 1;
					if eventCounterB2 = eventCounterB1 then
						TCU2 <= '1'; -- output high
					end if;
				end if;
			end if;
	End Process;

	-- generate output dual D-FF.
	PHI_OUTPUT : Process (CLK, RES)
	Begin
		if rising_edge(CLK) then
		TCU_XNOR_SI <= (TCU1 OR TCU2) XNOR SI;
 		end if;
		If RES = '1' Then
			PHI_0 <= '0';
			PHI_90 <= '0';
		Else
			If rising_edge(CLK) Then
				PHI_0 <= SI;
				PHI_90 <= TCU_XNOR_SI;
			End If;
		End If;
	End Process;
 
End rtl;