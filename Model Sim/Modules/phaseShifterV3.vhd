-- Author : Masum Ahmed 
-- Email  : Ma786@kent.ac.uk
-- Date   : 04/12/2019
-- File Info : Using 2 different counter one at clk speed and other at clk / 2 (toggle). It works out what is half of input
-- half wave. It works out the half for the first half of SI cycle and half of the second half of the SI single incase the SI signal has non 
-- propotional duty cycle e.g not 50-50 

Library IEEE;
Use IEEE.std_logic_1164.All;
Use IEEE.numeric_std.All;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
	
	
	Signal TCU_XNOR : std_logic;
	-- variable 
	Signal CEA_Counter1 : integer := 0;
	Signal CEA_Counter2 : integer := 0; 
	Signal CEB_Counter1 : integer := 0;
	Signal CEB_Counter2 : integer := 0;

	Signal PHI_0_s : std_logic; 
	
Begin

	
	CounterX : process(RES,CLK)
	begin 
	if RES = '1' then
	 CEA_Counter1 <= 0;
	 CEA_Counter2 <= 0;
	 CEB_Counter1 <= 0;
	 CEB_Counter2 <= 0;
	elsif rising_edge(CLK) then
		if SI = '0' then 
			TCU2 <= '0';
			CEB_Counter2 <= 0;
			CEA_Counter2 <= CEA_Counter2 + 1;
			if CEA_Counter2 = CEA_Counter1 then 
				if TCU1 = '0' then
					TCU1 <= '1';
					CEA_Counter1 <= 0;
				end if;
			end if;
			
			if CEB = '0' then -- increment counter CEB
				CEB_Counter1 <= CEB_Counter1 + 1;
			end if;
		elsif SI = '1' then 
				TCU1 <= '0'; -- when si is high TCU1 is low 
			CEA_Counter2 <= 0;
			CEB_Counter2 <= CEB_Counter2 + 1;
			if CEB_Counter2 = CEB_Counter1 then
				if TCU2 = '0' then 
					TCU2 <= '1';
					CEB_Counter1 <= 0;
				end if;
			end if;
			
			if CEA = '0' then --incremnt counter CEA
				CEA_Counter1 <= CEA_Counter1 + 1;
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
			TCU_XNOR <= (TCU1 or TCU2) xnor PHI_0_s;
			PHI_0_s <= SI;
			PHI_0 <= SI;
			PHI_90 <= TCU_XNOR;
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

	CEA <= (SI And TOGGLE) Or (Not SI);
	CEB <= ((Not SI) And TOGGLE) Or SI;

End rtl;