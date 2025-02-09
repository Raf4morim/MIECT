-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "11/13/2022 13:59:40"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          serial_encoder
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY serial_encoder_vhd_vec_tst IS
END serial_encoder_vhd_vec_tst;
ARCHITECTURE serial_encoder_arch OF serial_encoder_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL code : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL mIn : STD_LOGIC;
SIGNAL nGRst : STD_LOGIC;
SIGNAL v : STD_LOGIC;
COMPONENT serial_encoder
	PORT (
	clk : IN STD_LOGIC;
	code : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	mIn : IN STD_LOGIC;
	nGRst : IN STD_LOGIC;
	v : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : serial_encoder
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	code => code,
	mIn => mIn,
	nGRst => nGRst,
	v => v
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
LOOP
	clk <= '0';
	WAIT FOR 50000 ps;
	clk <= '1';
	WAIT FOR 50000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk;

-- mIn
t_prcs_mIn: PROCESS
BEGIN
	mIn <= '0';
	WAIT FOR 80000 ps;
	mIn <= '1';
	WAIT FOR 160000 ps;
	mIn <= '0';
	WAIT FOR 40000 ps;
	mIn <= '1';
	WAIT FOR 40000 ps;
	mIn <= '0';
	WAIT FOR 40000 ps;
	mIn <= '1';
	WAIT FOR 40000 ps;
	mIn <= '0';
	WAIT FOR 80000 ps;
	mIn <= '1';
	WAIT FOR 40000 ps;
	mIn <= '0';
	WAIT FOR 80000 ps;
	mIn <= '1';
	WAIT FOR 200000 ps;
	mIn <= '0';
	WAIT FOR 80000 ps;
	mIn <= '1';
WAIT;
END PROCESS t_prcs_mIn;

-- nGRst
t_prcs_nGRst: PROCESS
BEGIN
	nGRst <= '1';
WAIT;
END PROCESS t_prcs_nGRst;
END serial_encoder_arch;
