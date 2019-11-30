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
		PHI_90 : Out std_logic
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
		
	
	Counter : Process(CEA,CLK,SI,RES) 
	variable eventCounterA1 : Integer  := 0; -- numeric
	variable eventCounterA2 : Integer  := 0; -- numeric
	variable enableReset	: boolean := true;
	begin 
	if RES = '1' then 
		TCU1 <= '0';
	elsif SI = '1' then
		if enableReset = true then 
			TCU1 <= '0';
			eventCounterA1 := 0;
			eventCounterA2 := 0;
			enableReset := false;
		elsif rising_edge(CEA) then 
			eventCounterA1 := eventCounterA1 + 2;
		else 
		-- nothing
		end if;
		
	elsif SI = '0' then 
		if CLK = '1' then 
			if eventCounterA1 = eventCounterA2 then 
				TCU1 <= '1';
				enableReset := true;
			else 
				eventCounterA2 := eventCounterA2 + 1;
			end if;
		end if;
	else 
	--nothing
	end if;
	end process;
	
	
	Counter2 : Process(CEB,CLK,SI,RES) 
	variable eventCounterB1 : Integer  := 0; -- numeric
	variable eventCounterB2 : Integer  := 0; -- numeric
	variable enableResetB	: boolean := true;
	begin 
	if RES = '1' then 
		TCU2 <= '0';
	elsif SI = '0' then
		if enableResetB = true then 
			TCU2 <= '0';
			eventCounterB1 := 0;
			eventCounterB2 := 0;
			enableResetB := false;
		elsif rising_edge(CEB) then 
			eventCounterB1 := eventCounterB1 + 2;
		else 
		-- nothing
		end if;
		
	elsif SI = '1' then 
		if CLK = '1' then 
			if eventCounterB1 = eventCounterB2 then 
				TCU2 <= '1';
				enableResetB := true;
			else 
				eventCounterB2 := eventCounterB2 + 1;
			end if;
		end if;
	else 
	--nothing
	end if;
	end process;
	

	
	-- generate output dual D-FF.
	PHI_OUTPUT : Process (CLK, RES)
	Begin

		If RES = '1' Then
			PHI_0 <= '0';
			PHI_90 <= '0';
		elsif rising_edge(CLK) Then
			TCU_XNOR_SI <= (TCU1 OR TCU2) XNOR SI;
			PHI_0 <= SI;
			PHI_90 <= TCU_XNOR_SI;
		End If;
	End Process;
 
End rtl;