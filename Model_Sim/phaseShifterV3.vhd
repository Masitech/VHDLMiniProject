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
End Entity;

Architecture rtl Of PhaseShifter Is
	-- clk div 2
	Signal TOGGLE : std_logic;
	-- counter A
	Signal CEA : std_logic;
	Signal TCU1 : std_logic;

	-- counter B .
	Signal CEB : std_logic;
	
	-- variable 
	Signal CEA_Counter1 : integer;
	Signal CEA_Counter2 : integer; 
	Signal CEB_Counter1 : integer;
	Signal CEB_Counter2 : integer;
	
Begin

	-- count CEA
	CounterA0 : process(CEA,SI) 
	begin 
	if rising_edge(SI) then 
		CEA_Counter1 <= 0;
	elsif CEA = '0' then --low  
		CEA_Counter1 <= CEA_Counter1 + 1;
	end if;
	end process;
	
	-- count CEA
	CounterB1 : process(CEB,SI) 
	begin 
	if falling_edge(SI) then
		CEB_Counter1 <= 0;
	elsif CEB = '0' then --low  
		CEB_Counter1 <= CEB_Counter1 + 1;
	end if;
	
	
	end process;
	CounterX : process(SI,CLK)
	begin 
	if rising_edge(CLK) then 
		if SI = '0' then 
			CEB_Counter2 <= 1;
			CEA_Counter2 <= CEA_Counter2 + 1;
			if CEA_Counter1 = CEA_Counter2 then 
				TCU1 <= '1';
			end if;
		elsif SI = '1' then 
			CEA_Counter2 <= 1;
			CEB_Counter2 <= CEB_Counter2 + 1;
			if CEB_Counter1 = CEB_Counter2 then
				TCU1 <= '0';
			end if;
		end if;
	end if;
	end process;

	-- generate output dual D-FF.
	PHI_OUTPUT : Process (CLK, RES)
	Begin
		If RES = '1' Then
			PHI_0 <= '0';
			PHI_90 <= '0';
		elsif rising_edge(CLK) Then
			PHI_0 <= SI;
			PHI_90 <= TCU1;
		End If;
	End Process;
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
		
End rtl;