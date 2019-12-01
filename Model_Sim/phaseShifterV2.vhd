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
	Signal TCU2 : std_logic;

	Signal TCU_XNOR_SI : std_logic;
	
	
	-- variable 
	Signal CEA_Counter1 : integer;
	Signal CEA_Counter2 : integer; 
	Signal CEB_Counter1 : integer;
	Signal CEB_Counter2 : integer;
	
	Signal ResetCEA_CounterA : boolean; 
	Signal ResetCEA_CounterB : boolean; 
	Signal ResetCEB_CounterA : boolean; 
	Signal ResetCEB_CounterB : boolean; 
Begin

	-- count CEA
	CounterA0 : process(CEA,ResetCEA_CounterA) 
	begin 
	if (ResetCEA_CounterA = true) then 
		CEA_Counter1 <= 0;
		ResetCEA_CounterB <= true; -- done reset; 
	elsif rising_edge(CEA) then 
		ResetCEA_CounterB <= false;
		CEA_Counter1 <= CEA_Counter1 + 1;
	end if;
	end process;
	
	CounterA1 : process(SI,CLK)
	begin 
	if (ResetCEA_CounterB = true) then 
		ResetCEA_CounterA <= false;
	elsif rising_edge(CLK) then 
		if SI = '0' then 
			CEA_Counter2 <= CEA_Counter2 + 1;
			if CEA_Counter1 = CEA_Counter2 then 
				TCU1 <= '1';
				ResetCEA_CounterA <= true; -- reset cea counter 1
			end if;
		else 
		TCU1 <= '0';
		CEA_Counter2 <= 0;
		end if;

	end if;
	end process;





	-- count CEB
	CounterB0 : process(CEB,ResetCEB_CounterA) 
	begin 
	if (ResetCEB_CounterA = true) then 
		CEB_Counter1 <= 0;
		ResetCEB_CounterB <= true; -- done reset; 
	elsif rising_edge(CEB) then 
		ResetCEB_CounterB <= false;
		CEB_Counter1 <= CEB_Counter1 + 1;
	end if;
	end process;
	
	CounterB1 : process(SI,CLK)
	begin 
	if (ResetCEB_CounterB = true) then 
		ResetCEB_CounterA <= false;
	elsif rising_edge(CLK) then 
		if SI = '1' then 
			CEB_Counter2 <= CEB_Counter2 + 1;
			if CEB_Counter1 = CEB_Counter2 then 
				TCU2 <= '1';
				ResetCEB_CounterA <= true; -- reset cea counter 1
			end if;
		else 
		TCU2 <= '0';
		CEB_Counter2 <= 0;
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
			TCU_XNOR_SI <= (TCU1 OR TCU2) XNOR SI;
			PHI_0 <= SI;
			PHI_90 <= TCU_XNOR_SI;
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