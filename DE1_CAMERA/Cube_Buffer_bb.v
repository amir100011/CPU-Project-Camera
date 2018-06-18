// megafunction wizard: %Shift register (RAM-based)%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: ALTSHIFT_TAPS 

// ============================================================
// File Name: Cube_Buffer.v
// Megafunction Name(s):
// 			ALTSHIFT_TAPS
//
// Simulation Library Files(s):
// 			altera_mf
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 12.1 Build 177 11/07/2012 SJ Web Edition
// ************************************************************

//Copyright (C) 1991-2012 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.

module Cube_Buffer (
	clken,
	clock,
	shiftin,
	shiftout,
	taps0x,
	taps1x,
	taps2x,
	taps3x,
	taps4x);

	input	  clken;
	input	  clock;
	input	[11:0]  shiftin;
	output	[11:0]  shiftout;
	output	[11:0]  taps0x;
	output	[11:0]  taps1x;
	output	[11:0]  taps2x;
	output	[11:0]  taps3x;
	output	[11:0]  taps4x;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1	  clken;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: ACLR NUMERIC "0"
// Retrieval info: PRIVATE: CLKEN NUMERIC "1"
// Retrieval info: PRIVATE: GROUP_TAPS NUMERIC "1"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone II"
// Retrieval info: PRIVATE: NUMBER_OF_TAPS NUMERIC "5"
// Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "1"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: TAP_DISTANCE NUMERIC "1280"
// Retrieval info: PRIVATE: WIDTH NUMERIC "12"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone II"
// Retrieval info: CONSTANT: LPM_HINT STRING "RAM_BLOCK_TYPE=M4K"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altshift_taps"
// Retrieval info: CONSTANT: NUMBER_OF_TAPS NUMERIC "5"
// Retrieval info: CONSTANT: TAP_DISTANCE NUMERIC "1280"
// Retrieval info: CONSTANT: WIDTH NUMERIC "12"
// Retrieval info: USED_PORT: clken 0 0 0 0 INPUT VCC "clken"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: USED_PORT: shiftin 0 0 12 0 INPUT NODEFVAL "shiftin[11..0]"
// Retrieval info: USED_PORT: shiftout 0 0 12 0 OUTPUT NODEFVAL "shiftout[11..0]"
// Retrieval info: USED_PORT: taps0x 0 0 12 0 OUTPUT NODEFVAL "taps0x[11..0]"
// Retrieval info: USED_PORT: taps1x 0 0 12 0 OUTPUT NODEFVAL "taps1x[11..0]"
// Retrieval info: USED_PORT: taps2x 0 0 12 0 OUTPUT NODEFVAL "taps2x[11..0]"
// Retrieval info: USED_PORT: taps3x 0 0 12 0 OUTPUT NODEFVAL "taps3x[11..0]"
// Retrieval info: USED_PORT: taps4x 0 0 12 0 OUTPUT NODEFVAL "taps4x[11..0]"
// Retrieval info: CONNECT: @clken 0 0 0 0 clken 0 0 0 0
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: @shiftin 0 0 12 0 shiftin 0 0 12 0
// Retrieval info: CONNECT: shiftout 0 0 12 0 @shiftout 0 0 12 0
// Retrieval info: CONNECT: taps0x 0 0 12 0 @taps 0 0 12 0
// Retrieval info: CONNECT: taps1x 0 0 12 0 @taps 0 0 12 12
// Retrieval info: CONNECT: taps2x 0 0 12 0 @taps 0 0 12 24
// Retrieval info: CONNECT: taps3x 0 0 12 0 @taps 0 0 12 36
// Retrieval info: CONNECT: taps4x 0 0 12 0 @taps 0 0 12 48
// Retrieval info: GEN_FILE: TYPE_NORMAL Cube_Buffer.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Cube_Buffer.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Cube_Buffer.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Cube_Buffer.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Cube_Buffer_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Cube_Buffer_bb.v TRUE
// Retrieval info: LIB_FILE: altera_mf
