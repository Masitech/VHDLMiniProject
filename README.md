# VHDLMiniProject
Design and Implementation of a Digital Phase Shift and Frequency Measurement Circuit using a Xilinx FPGA

Introduction
In this mini-project, you are required to design, verify and implement of a digital phase shifter and frequency measurement circuit using a Xilinx FPGA. In the past a similar design has been used as a driver for a resonant frequency load-cell similar to the one described in Figure 1. 
 
 
Figure 1 Thick Film PZT Metallic Resonator with a cross-section of Load Cell Design.
The operating principle of this system is to keep the load cell resonator oscillating at (or very close to) its resonant frequency. When a load is applied to the resonator load cell there is a change in the resonant frequency which is proportional to the load applied. By measuring the frequency it is possible to determine the load applied to the cell. 
The circuit to be designed here is used to maintain the sensor in resonance over a (wide) frequency range while also measuring the frequency of oscillation. The input (SENSOR_IN) to the circuit is a digital square wave (0 – 3.3V) of varying frequency output from the resonator which must be used (by the FPGA) to generate a 90o phase-shifted version of the signal which is then used to drive the resonator and keep it oscillating. The FPGA also needs to use the output from the load-cell resonator to measure its oscillating frequency of the resonator.
A Top-Level block diagram of the system which defines the inputs and outputs is shown in Figure 2

 
Figure 2. TOP Level of PHASESHIFT circuit

A block diagram showing the circuits used to build the system on the FPGA is shown in Figure 3. Further details of the internal structure of the blocks are outlined in the sections below. The two main components that need to be designed are the PHASE_SHIFTER circuit and the FREQUENCY_CALCULATOR circuit. The DISPLAY_INTERFACE circuit (which is provided) is also needed to drive the development board LED hex display (used to indicate the measured frequency), the range control (using the slider switches on the FPGA development board) and the range indicators (using the individual LEDs that are available on the FPGA Development Board. The VHDL description of this circuit is provided.
 
Figure 3. Block Diagram of  PHASESHIFT circuit
For final testing in the laboratory, a signal generator will be required to input a test pulse into the FPGA (A rectangular pulse with an input voltage range of 0 – 3.3V) and an oscilloscope used to compare the input and output pulses to confirm that the output is a 90o phase-shifted version of the input pulse. The signal frequency should also be displayed on the four hexadecimal displays on the FPGA development board.
The Phase_Shifter Circuit
Figure 4 is a suggested solution for the phase shift circuit which is based on two counters. A timing diagram that indicates the operation of this circuit is shown in Figure 5. The counters count up at half the rate that they count down. The logic required for the two counts enables signals (CEA and CEB) is also shown in Figure 4.  Use Modelsim® to design, build and simulate this circuit to confirm its operation.
 
Figure 4. Suggested  PHASE_SHIFTER circuit
A timing diagram for the Phase Shift Circuit is shown in Figure 5. The circuit is built using two up/down counters configured such that the count-down rate is twice that of the count-up rate.  The timing diagram also includes another interim signal that is needed to produce the two output signals PH_0 and PH_90.
 
Figure 5. Timing Diagram of PHASE_SHIFTER circuit
The Frequency Counter Circuit
Figure 6 is a suggested solution for the frequency counter circuit. It is used to count the number of rising edges of the input pulse that occur in one second (using decimal or MOD10 counters) and translate them into valid hexadecimal outputs for display on the HEX LEDs available on the FPGA development board.
Two slider switches are used to be able to change the range of the frequency measurement. The position of the slider switches are to be indicated by individual LEDs on the development board.
Outputs
On the Xilinx development board, there are 4 hexadecimal display modules. The basic setting allows us to display a frequency from 0 – 9999 Hz. It is possible to extend this range or accuracy.
How would you use the display to show that the input frequency is out of range?
To extend the range, the slider switches and LEDs can be used to “scale” the output from 0 – 99990 Hz, 0 – 999900 Hz and 0 – 9999000 Hz. 
How would you expect the accuracy of the frequency to change? How could this be improved?
Display.
A sample circuit for the display can be found on Moodle. A similar circuit has already been used when you were introduced to the Xilinx development boards as part of the EL568 introduction to VHDL and Xilinx. Details of how this interface works are available in [2] and it is important that you refer to this document. 
 
Figure 6. Suggested FREQUENCY_CALCULATOR circuit
