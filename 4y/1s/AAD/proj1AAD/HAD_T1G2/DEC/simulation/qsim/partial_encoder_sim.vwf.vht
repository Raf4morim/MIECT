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
-- Generated on "11/13/2022 15:33:03"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          partial_encoder
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY partial_encoder_vhd_vec_tst IS
END partial_encoder_vhd_vec_tst;
ARCHITECTURE partial_encoder_arch OF partial_encoder_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL m1 : STD_LOGIC;
SIGNAL m2 : STD_LOGIC;
SIGNAL m3 : STD_LOGIC;
SIGNAL z : STD_LOGIC_VECTOR(7 DOWNTO 0);
COMPONENT partial_encoder
	PORT (
	m1 : IN STD_LOGIC;
	m2 : IN STD_LOGIC;
	m3 : IN STD_LOGIC;
	z : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : partial_encoder
	PORT MAP (
-- list connections between master ports and signals
	m1 => m1,
	m2 => m2,
	m3 => m3,
	z => z
	);

-- m1
t_prcs_m1: PROCESS
BEGIN
	m1 <= '0';
WAIT;
END PROCESS t_prcs_m1;

-- m2
t_prcs_m2: PROCESS
BEGIN
	m2 <= '0';
WAIT;
END PROCESS t_prcs_m2;

-- m3
t_prcs_m3: PROCESS
BEGIN
	m3 <= '1';
WAIT;
END PROCESS t_prcs_m3;
END partial_encoder_arch;
