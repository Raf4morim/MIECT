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

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

-- DATE "11/13/2022 20:25:30"

-- 
-- Device: Altera EP4CGX15BF14C6 Package FBGA169
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIV;
LIBRARY IEEE;
USE CYCLONEIV.CYCLONEIV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_NCEO~	=>  Location: PIN_N5,	 I/O Standard: 2.5 V,	 Current Strength: 16mA
-- ~ALTERA_DATA0~	=>  Location: PIN_A5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_ASDO~	=>  Location: PIN_B5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_NCSO~	=>  Location: PIN_C5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DCLK~	=>  Location: PIN_A4,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \~ALTERA_DATA0~~padout\ : std_logic;
SIGNAL \~ALTERA_ASDO~~padout\ : std_logic;
SIGNAL \~ALTERA_NCSO~~padout\ : std_logic;
SIGNAL \~ALTERA_DATA0~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_ASDO~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_NCSO~~ibuf_o\ : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY CYCLONEIV;
LIBRARY IEEE;
USE CYCLONEIV.CYCLONEIV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	full_parallel_decoder IS
    PORT (
	y : IN std_logic_vector(7 DOWNTO 0);
	valid : BUFFER std_logic;
	m : BUFFER std_logic_vector(3 DOWNTO 0)
	);
END full_parallel_decoder;

-- Design Ports Information
-- valid	=>  Location: PIN_D12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- m[0]	=>  Location: PIN_B13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- m[1]	=>  Location: PIN_E10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- m[2]	=>  Location: PIN_D10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- m[3]	=>  Location: PIN_B10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[2]	=>  Location: PIN_C12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[6]	=>  Location: PIN_B11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[0]	=>  Location: PIN_D13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[4]	=>  Location: PIN_F9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[3]	=>  Location: PIN_C13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[7]	=>  Location: PIN_A13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[1]	=>  Location: PIN_C11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[5]	=>  Location: PIN_E13,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF full_parallel_decoder IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_y : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_valid : std_logic;
SIGNAL ww_m : std_logic_vector(3 DOWNTO 0);
SIGNAL \valid~output_o\ : std_logic;
SIGNAL \m[0]~output_o\ : std_logic;
SIGNAL \m[1]~output_o\ : std_logic;
SIGNAL \m[2]~output_o\ : std_logic;
SIGNAL \m[3]~output_o\ : std_logic;
SIGNAL \y[3]~input_o\ : std_logic;
SIGNAL \y[2]~input_o\ : std_logic;
SIGNAL \b2v_inst5|c2~0_combout\ : std_logic;
SIGNAL \y[7]~input_o\ : std_logic;
SIGNAL \y[6]~input_o\ : std_logic;
SIGNAL \b2v_inst5|c0~0_combout\ : std_logic;
SIGNAL \y[0]~input_o\ : std_logic;
SIGNAL \y[1]~input_o\ : std_logic;
SIGNAL \b2v_inst5|c3~0_combout\ : std_logic;
SIGNAL \y[4]~input_o\ : std_logic;
SIGNAL \y[5]~input_o\ : std_logic;
SIGNAL \b2v_inst5|c1~0_combout\ : std_logic;
SIGNAL \b2v_inst5|m_is_error~0_combout\ : std_logic;
SIGNAL \b2v_inst6|c3~combout\ : std_logic;
SIGNAL \b2v_inst6|c1~combout\ : std_logic;
SIGNAL \b2v_inst6|c2~combout\ : std_logic;
SIGNAL \b2v_inst6|c0~combout\ : std_logic;
SIGNAL \b2v_inst6|m_is_error~0_combout\ : std_logic;
SIGNAL \b2v_inst18|c0~combout\ : std_logic;
SIGNAL \b2v_inst18|c2~combout\ : std_logic;
SIGNAL \b2v_inst18|c1~combout\ : std_logic;
SIGNAL \b2v_inst18|c3~combout\ : std_logic;
SIGNAL \b2v_inst18|m_is_error~0_combout\ : std_logic;
SIGNAL \valid_ALTERA_SYNTHESIZED~0_combout\ : std_logic;
SIGNAL \b2v_inst5|m_is_one~0_combout\ : std_logic;
SIGNAL \b2v_inst6|m_is_one~0_combout\ : std_logic;
SIGNAL \m_ALTERA_SYNTHESIZED[2]~1_combout\ : std_logic;
SIGNAL \b2v_inst15|hA01|and20|y~combout\ : std_logic;
SIGNAL \b2v_inst15|fA10|fA0|and20|y~combout\ : std_logic;
SIGNAL \b2v_inst18|m_is_one~0_combout\ : std_logic;
SIGNAL \m_ALTERA_SYNTHESIZED[1]~0_combout\ : std_logic;
SIGNAL \d[7]~0_combout\ : std_logic;
SIGNAL \b2v_inst15|hA02|and20|y~combout\ : std_logic;
SIGNAL \b2v_inst15|fA11|fA0|xor20|y~combout\ : std_logic;
SIGNAL \b2v_inst15|fA10|fA0|xor21|y~0_combout\ : std_logic;
SIGNAL \b2v_inst15|fA10|fA0|xor21|y~combout\ : std_logic;
SIGNAL \b2v_inst15|fA11|hA0|and20|y~combout\ : std_logic;
SIGNAL \b2v_inst15|fA20|hA0|and20|y~combout\ : std_logic;
SIGNAL \b2v_inst15|fA20|fA10|or20|y~0_combout\ : std_logic;
SIGNAL \b2v_inst15|hA03|and20|y~combout\ : std_logic;
SIGNAL \m_ALTERA_SYNTHESIZED~2_combout\ : std_logic;
SIGNAL \b2v_inst|z\ : std_logic_vector(7 DOWNTO 0);
SIGNAL m_ALTERA_SYNTHESIZED : std_logic_vector(3 DOWNTO 0);
SIGNAL \ALT_INV_valid_ALTERA_SYNTHESIZED~0_combout\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_y <= y;
valid <= ww_valid;
m <= ww_m;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_valid_ALTERA_SYNTHESIZED~0_combout\ <= NOT \valid_ALTERA_SYNTHESIZED~0_combout\;
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: IOOBUF_X33_Y28_N9
\valid~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ALT_INV_valid_ALTERA_SYNTHESIZED~0_combout\,
	devoe => ww_devoe,
	o => \valid~output_o\);

-- Location: IOOBUF_X26_Y31_N9
\m[0]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \m_ALTERA_SYNTHESIZED~2_combout\,
	devoe => ww_devoe,
	o => \m[0]~output_o\);

-- Location: IOOBUF_X33_Y27_N2
\m[1]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \m_ALTERA_SYNTHESIZED[1]~0_combout\,
	devoe => ww_devoe,
	o => \m[1]~output_o\);

-- Location: IOOBUF_X33_Y27_N9
\m[2]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \m_ALTERA_SYNTHESIZED[2]~1_combout\,
	devoe => ww_devoe,
	o => \m[2]~output_o\);

-- Location: IOOBUF_X24_Y31_N9
\m[3]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => m_ALTERA_SYNTHESIZED(3),
	devoe => ww_devoe,
	o => \m[3]~output_o\);

-- Location: IOIBUF_X29_Y31_N1
\y[3]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(3),
	o => \y[3]~input_o\);

-- Location: IOIBUF_X31_Y31_N8
\y[2]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(2),
	o => \y[2]~input_o\);

-- Location: LCCOMB_X27_Y27_N26
\b2v_inst5|c2~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst5|c2~0_combout\ = \y[3]~input_o\ $ (\y[2]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \y[3]~input_o\,
	datad => \y[2]~input_o\,
	combout => \b2v_inst5|c2~0_combout\);

-- Location: IOIBUF_X26_Y31_N1
\y[7]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(7),
	o => \y[7]~input_o\);

-- Location: IOIBUF_X24_Y31_N1
\y[6]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(6),
	o => \y[6]~input_o\);

-- Location: LCCOMB_X27_Y27_N20
\b2v_inst5|c0~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst5|c0~0_combout\ = \y[7]~input_o\ $ (\y[6]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \y[7]~input_o\,
	datac => \y[6]~input_o\,
	combout => \b2v_inst5|c0~0_combout\);

-- Location: IOIBUF_X29_Y31_N8
\y[0]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(0),
	o => \y[0]~input_o\);

-- Location: IOIBUF_X31_Y31_N1
\y[1]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(1),
	o => \y[1]~input_o\);

-- Location: LCCOMB_X27_Y27_N8
\b2v_inst5|c3~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst5|c3~0_combout\ = \y[0]~input_o\ $ (\y[1]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \y[0]~input_o\,
	datad => \y[1]~input_o\,
	combout => \b2v_inst5|c3~0_combout\);

-- Location: IOIBUF_X33_Y25_N1
\y[4]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(4),
	o => \y[4]~input_o\);

-- Location: IOIBUF_X33_Y25_N8
\y[5]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(5),
	o => \y[5]~input_o\);

-- Location: LCCOMB_X30_Y27_N26
\b2v_inst5|c1~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst5|c1~0_combout\ = \y[4]~input_o\ $ (\y[5]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \y[4]~input_o\,
	datac => \y[5]~input_o\,
	combout => \b2v_inst5|c1~0_combout\);

-- Location: LCCOMB_X27_Y27_N6
\b2v_inst5|m_is_error~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst5|m_is_error~0_combout\ = (\b2v_inst5|c2~0_combout\ & ((\b2v_inst5|c0~0_combout\ & ((\b2v_inst5|c3~0_combout\) # (\b2v_inst5|c1~0_combout\))) # (!\b2v_inst5|c0~0_combout\ & (\b2v_inst5|c3~0_combout\ $ (!\b2v_inst5|c1~0_combout\))))) # 
-- (!\b2v_inst5|c2~0_combout\ & ((\b2v_inst5|c0~0_combout\ & (\b2v_inst5|c3~0_combout\ $ (!\b2v_inst5|c1~0_combout\))) # (!\b2v_inst5|c0~0_combout\ & ((!\b2v_inst5|c1~0_combout\) # (!\b2v_inst5|c3~0_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110100110010111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst5|c2~0_combout\,
	datab => \b2v_inst5|c0~0_combout\,
	datac => \b2v_inst5|c3~0_combout\,
	datad => \b2v_inst5|c1~0_combout\,
	combout => \b2v_inst5|m_is_error~0_combout\);

-- Location: LCCOMB_X29_Y27_N18
\b2v_inst6|c3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst6|c3~combout\ = \y[0]~input_o\ $ (\y[2]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \y[0]~input_o\,
	datad => \y[2]~input_o\,
	combout => \b2v_inst6|c3~combout\);

-- Location: LCCOMB_X29_Y27_N24
\b2v_inst6|c1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst6|c1~combout\ = \y[6]~input_o\ $ (\y[4]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[6]~input_o\,
	datad => \y[4]~input_o\,
	combout => \b2v_inst6|c1~combout\);

-- Location: LCCOMB_X29_Y27_N30
\b2v_inst6|c2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst6|c2~combout\ = \y[3]~input_o\ $ (\y[1]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \y[3]~input_o\,
	datad => \y[1]~input_o\,
	combout => \b2v_inst6|c2~combout\);

-- Location: LCCOMB_X29_Y27_N20
\b2v_inst6|c0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst6|c0~combout\ = \y[7]~input_o\ $ (\y[5]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \y[7]~input_o\,
	datad => \y[5]~input_o\,
	combout => \b2v_inst6|c0~combout\);

-- Location: LCCOMB_X29_Y27_N0
\b2v_inst6|m_is_error~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst6|m_is_error~0_combout\ = (\b2v_inst6|c3~combout\ & ((\b2v_inst6|c1~combout\ & ((\b2v_inst6|c2~combout\) # (\b2v_inst6|c0~combout\))) # (!\b2v_inst6|c1~combout\ & (\b2v_inst6|c2~combout\ $ (!\b2v_inst6|c0~combout\))))) # (!\b2v_inst6|c3~combout\ 
-- & ((\b2v_inst6|c1~combout\ & (\b2v_inst6|c2~combout\ $ (!\b2v_inst6|c0~combout\))) # (!\b2v_inst6|c1~combout\ & ((!\b2v_inst6|c0~combout\) # (!\b2v_inst6|c2~combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110100110010111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst6|c3~combout\,
	datab => \b2v_inst6|c1~combout\,
	datac => \b2v_inst6|c2~combout\,
	datad => \b2v_inst6|c0~combout\,
	combout => \b2v_inst6|m_is_error~0_combout\);

-- Location: LCCOMB_X29_Y27_N12
\b2v_inst18|c0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst18|c0~combout\ = \y[7]~input_o\ $ (\y[3]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \y[7]~input_o\,
	datad => \y[3]~input_o\,
	combout => \b2v_inst18|c0~combout\);

-- Location: LCCOMB_X29_Y27_N6
\b2v_inst18|c2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst18|c2~combout\ = \y[1]~input_o\ $ (\y[5]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \y[1]~input_o\,
	datad => \y[5]~input_o\,
	combout => \b2v_inst18|c2~combout\);

-- Location: LCCOMB_X29_Y27_N8
\b2v_inst18|c1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst18|c1~combout\ = \y[6]~input_o\ $ (\y[2]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[6]~input_o\,
	datad => \y[2]~input_o\,
	combout => \b2v_inst18|c1~combout\);

-- Location: LCCOMB_X29_Y27_N2
\b2v_inst18|c3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst18|c3~combout\ = \y[0]~input_o\ $ (\y[4]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \y[0]~input_o\,
	datad => \y[4]~input_o\,
	combout => \b2v_inst18|c3~combout\);

-- Location: LCCOMB_X30_Y27_N24
\b2v_inst18|m_is_error~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst18|m_is_error~0_combout\ = (\b2v_inst18|c0~combout\ & ((\b2v_inst18|c2~combout\ & ((\b2v_inst18|c1~combout\) # (\b2v_inst18|c3~combout\))) # (!\b2v_inst18|c2~combout\ & (\b2v_inst18|c1~combout\ $ (!\b2v_inst18|c3~combout\))))) # 
-- (!\b2v_inst18|c0~combout\ & ((\b2v_inst18|c2~combout\ & (\b2v_inst18|c1~combout\ $ (!\b2v_inst18|c3~combout\))) # (!\b2v_inst18|c2~combout\ & ((!\b2v_inst18|c3~combout\) # (!\b2v_inst18|c1~combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110100110010111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst18|c0~combout\,
	datab => \b2v_inst18|c2~combout\,
	datac => \b2v_inst18|c1~combout\,
	datad => \b2v_inst18|c3~combout\,
	combout => \b2v_inst18|m_is_error~0_combout\);

-- Location: LCCOMB_X29_Y27_N26
\valid_ALTERA_SYNTHESIZED~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \valid_ALTERA_SYNTHESIZED~0_combout\ = ((!\b2v_inst18|m_is_error~0_combout\) # (!\b2v_inst6|m_is_error~0_combout\)) # (!\b2v_inst5|m_is_error~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111011111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst5|m_is_error~0_combout\,
	datab => \b2v_inst6|m_is_error~0_combout\,
	datad => \b2v_inst18|m_is_error~0_combout\,
	combout => \valid_ALTERA_SYNTHESIZED~0_combout\);

-- Location: LCCOMB_X27_Y27_N24
\b2v_inst5|m_is_one~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst5|m_is_one~0_combout\ = (\b2v_inst5|c2~0_combout\ & ((\b2v_inst5|c0~0_combout\ & ((\b2v_inst5|c3~0_combout\) # (\b2v_inst5|c1~0_combout\))) # (!\b2v_inst5|c0~0_combout\ & (\b2v_inst5|c3~0_combout\ & \b2v_inst5|c1~0_combout\)))) # 
-- (!\b2v_inst5|c2~0_combout\ & (\b2v_inst5|c0~0_combout\ & (\b2v_inst5|c3~0_combout\ & \b2v_inst5|c1~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110100010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst5|c2~0_combout\,
	datab => \b2v_inst5|c0~0_combout\,
	datac => \b2v_inst5|c3~0_combout\,
	datad => \b2v_inst5|c1~0_combout\,
	combout => \b2v_inst5|m_is_one~0_combout\);

-- Location: LCCOMB_X29_Y27_N4
\m_ALTERA_SYNTHESIZED[3]\ : cycloneiv_lcell_comb
-- Equation(s):
-- m_ALTERA_SYNTHESIZED(3) = (\b2v_inst5|m_is_error~0_combout\ & (\b2v_inst6|m_is_error~0_combout\ & (\b2v_inst5|m_is_one~0_combout\ & \b2v_inst18|m_is_error~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst5|m_is_error~0_combout\,
	datab => \b2v_inst6|m_is_error~0_combout\,
	datac => \b2v_inst5|m_is_one~0_combout\,
	datad => \b2v_inst18|m_is_error~0_combout\,
	combout => m_ALTERA_SYNTHESIZED(3));

-- Location: LCCOMB_X29_Y27_N10
\b2v_inst6|m_is_one~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst6|m_is_one~0_combout\ = (\b2v_inst6|c3~combout\ & ((\b2v_inst6|c1~combout\ & ((\b2v_inst6|c2~combout\) # (\b2v_inst6|c0~combout\))) # (!\b2v_inst6|c1~combout\ & (\b2v_inst6|c2~combout\ & \b2v_inst6|c0~combout\)))) # (!\b2v_inst6|c3~combout\ & 
-- (\b2v_inst6|c1~combout\ & (\b2v_inst6|c2~combout\ & \b2v_inst6|c0~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110100010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst6|c3~combout\,
	datab => \b2v_inst6|c1~combout\,
	datac => \b2v_inst6|c2~combout\,
	datad => \b2v_inst6|c0~combout\,
	combout => \b2v_inst6|m_is_one~0_combout\);

-- Location: LCCOMB_X29_Y27_N28
\m_ALTERA_SYNTHESIZED[2]~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \m_ALTERA_SYNTHESIZED[2]~1_combout\ = (\b2v_inst6|m_is_one~0_combout\ & (\b2v_inst18|m_is_error~0_combout\ & (\b2v_inst6|m_is_error~0_combout\ & \b2v_inst5|m_is_error~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst6|m_is_one~0_combout\,
	datab => \b2v_inst18|m_is_error~0_combout\,
	datac => \b2v_inst6|m_is_error~0_combout\,
	datad => \b2v_inst5|m_is_error~0_combout\,
	combout => \m_ALTERA_SYNTHESIZED[2]~1_combout\);

-- Location: LCCOMB_X29_Y27_N22
\b2v_inst15|hA01|and20|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst15|hA01|and20|y~combout\ = (\m_ALTERA_SYNTHESIZED[2]~1_combout\ & (!\y[5]~input_o\ & (\y[4]~input_o\ $ (!m_ALTERA_SYNTHESIZED(3))))) # (!\m_ALTERA_SYNTHESIZED[2]~1_combout\ & (\y[5]~input_o\ & (\y[4]~input_o\ $ (m_ALTERA_SYNTHESIZED(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001001010000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[4]~input_o\,
	datab => \m_ALTERA_SYNTHESIZED[2]~1_combout\,
	datac => m_ALTERA_SYNTHESIZED(3),
	datad => \y[5]~input_o\,
	combout => \b2v_inst15|hA01|and20|y~combout\);

-- Location: LCCOMB_X27_Y27_N22
\b2v_inst15|fA10|fA0|and20|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst15|fA10|fA0|and20|y~combout\ = (\y[7]~input_o\ & (\b2v_inst15|hA01|and20|y~combout\ & (m_ALTERA_SYNTHESIZED(3) $ (\y[6]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => m_ALTERA_SYNTHESIZED(3),
	datab => \y[7]~input_o\,
	datac => \y[6]~input_o\,
	datad => \b2v_inst15|hA01|and20|y~combout\,
	combout => \b2v_inst15|fA10|fA0|and20|y~combout\);

-- Location: LCCOMB_X29_Y27_N14
\b2v_inst18|m_is_one~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst18|m_is_one~0_combout\ = (\b2v_inst18|c2~combout\ & ((\b2v_inst18|c0~combout\ & ((\b2v_inst18|c1~combout\) # (\b2v_inst18|c3~combout\))) # (!\b2v_inst18|c0~combout\ & (\b2v_inst18|c1~combout\ & \b2v_inst18|c3~combout\)))) # 
-- (!\b2v_inst18|c2~combout\ & (\b2v_inst18|c0~combout\ & (\b2v_inst18|c1~combout\ & \b2v_inst18|c3~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110100010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst18|c2~combout\,
	datab => \b2v_inst18|c0~combout\,
	datac => \b2v_inst18|c1~combout\,
	datad => \b2v_inst18|c3~combout\,
	combout => \b2v_inst18|m_is_one~0_combout\);

-- Location: LCCOMB_X29_Y27_N16
\m_ALTERA_SYNTHESIZED[1]~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \m_ALTERA_SYNTHESIZED[1]~0_combout\ = (\b2v_inst5|m_is_error~0_combout\ & (\b2v_inst6|m_is_error~0_combout\ & (\b2v_inst18|m_is_one~0_combout\ & \b2v_inst18|m_is_error~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst5|m_is_error~0_combout\,
	datab => \b2v_inst6|m_is_error~0_combout\,
	datac => \b2v_inst18|m_is_one~0_combout\,
	datad => \b2v_inst18|m_is_error~0_combout\,
	combout => \m_ALTERA_SYNTHESIZED[1]~0_combout\);

-- Location: LCCOMB_X27_Y27_N16
\d[7]~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \d[7]~0_combout\ = \m_ALTERA_SYNTHESIZED[1]~0_combout\ $ (\m_ALTERA_SYNTHESIZED[2]~1_combout\ $ (m_ALTERA_SYNTHESIZED(3) $ (\y[0]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110010110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \m_ALTERA_SYNTHESIZED[1]~0_combout\,
	datab => \m_ALTERA_SYNTHESIZED[2]~1_combout\,
	datac => m_ALTERA_SYNTHESIZED(3),
	datad => \y[0]~input_o\,
	combout => \d[7]~0_combout\);

-- Location: LCCOMB_X27_Y27_N2
\b2v_inst15|hA02|and20|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst15|hA02|and20|y~combout\ = (\m_ALTERA_SYNTHESIZED[1]~0_combout\ & (!\y[3]~input_o\ & (m_ALTERA_SYNTHESIZED(3) $ (!\y[2]~input_o\)))) # (!\m_ALTERA_SYNTHESIZED[1]~0_combout\ & (\y[3]~input_o\ & (m_ALTERA_SYNTHESIZED(3) $ (\y[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010010001000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \m_ALTERA_SYNTHESIZED[1]~0_combout\,
	datab => \y[3]~input_o\,
	datac => m_ALTERA_SYNTHESIZED(3),
	datad => \y[2]~input_o\,
	combout => \b2v_inst15|hA02|and20|y~combout\);

-- Location: LCCOMB_X30_Y27_N28
\b2v_inst|z[1]\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst|z\(1) = \m_ALTERA_SYNTHESIZED[1]~0_combout\ $ (\m_ALTERA_SYNTHESIZED[2]~1_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \m_ALTERA_SYNTHESIZED[1]~0_combout\,
	datad => \m_ALTERA_SYNTHESIZED[2]~1_combout\,
	combout => \b2v_inst|z\(1));

-- Location: LCCOMB_X27_Y27_N10
\b2v_inst15|fA11|fA0|xor20|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst15|fA11|fA0|xor20|y~combout\ = \b2v_inst15|hA02|and20|y~combout\ $ (((\d[7]~0_combout\ & (\b2v_inst|z\(1) $ (\y[1]~input_o\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100011001101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \d[7]~0_combout\,
	datab => \b2v_inst15|hA02|and20|y~combout\,
	datac => \b2v_inst|z\(1),
	datad => \y[1]~input_o\,
	combout => \b2v_inst15|fA11|fA0|xor20|y~combout\);

-- Location: LCCOMB_X27_Y27_N30
\b2v_inst15|fA10|fA0|xor21|y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst15|fA10|fA0|xor21|y~0_combout\ = (\y[6]~input_o\ & ((\b2v_inst5|c1~0_combout\ & (!m_ALTERA_SYNTHESIZED(3))) # (!\b2v_inst5|c1~0_combout\ & ((\y[7]~input_o\))))) # (!\y[6]~input_o\ & ((\b2v_inst5|c1~0_combout\ & ((\y[7]~input_o\))) # 
-- (!\b2v_inst5|c1~0_combout\ & (m_ALTERA_SYNTHESIZED(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101110011001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => m_ALTERA_SYNTHESIZED(3),
	datab => \y[7]~input_o\,
	datac => \y[6]~input_o\,
	datad => \b2v_inst5|c1~0_combout\,
	combout => \b2v_inst15|fA10|fA0|xor21|y~0_combout\);

-- Location: LCCOMB_X27_Y27_N0
\b2v_inst15|fA10|fA0|xor21|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst15|fA10|fA0|xor21|y~combout\ = \b2v_inst15|fA10|fA0|xor21|y~0_combout\ $ (\b2v_inst15|hA01|and20|y~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \b2v_inst15|fA10|fA0|xor21|y~0_combout\,
	datad => \b2v_inst15|hA01|and20|y~combout\,
	combout => \b2v_inst15|fA10|fA0|xor21|y~combout\);

-- Location: LCCOMB_X27_Y27_N14
\b2v_inst15|fA11|hA0|and20|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst15|fA11|hA0|and20|y~combout\ = (m_ALTERA_SYNTHESIZED(3) & (!\b2v_inst5|c2~0_combout\ & (\y[0]~input_o\ $ (!\y[1]~input_o\)))) # (!m_ALTERA_SYNTHESIZED(3) & (\b2v_inst5|c2~0_combout\ & (\y[0]~input_o\ $ (\y[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001100001000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => m_ALTERA_SYNTHESIZED(3),
	datab => \y[0]~input_o\,
	datac => \b2v_inst5|c2~0_combout\,
	datad => \y[1]~input_o\,
	combout => \b2v_inst15|fA11|hA0|and20|y~combout\);

-- Location: LCCOMB_X27_Y27_N28
\b2v_inst15|fA20|hA0|and20|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst15|fA20|hA0|and20|y~combout\ = (\b2v_inst5|c2~0_combout\ & (!\b2v_inst5|c3~0_combout\ & (\b2v_inst5|c0~0_combout\ $ (\b2v_inst5|c1~0_combout\)))) # (!\b2v_inst5|c2~0_combout\ & (\b2v_inst5|c3~0_combout\ & (\b2v_inst5|c0~0_combout\ $ 
-- (\b2v_inst5|c1~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001001001001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst5|c2~0_combout\,
	datab => \b2v_inst5|c0~0_combout\,
	datac => \b2v_inst5|c3~0_combout\,
	datad => \b2v_inst5|c1~0_combout\,
	combout => \b2v_inst15|fA20|hA0|and20|y~combout\);

-- Location: LCCOMB_X27_Y27_N18
\b2v_inst15|fA20|fA10|or20|y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst15|fA20|fA10|or20|y~0_combout\ = (\b2v_inst15|fA10|fA0|xor21|y~combout\ & ((\b2v_inst15|fA20|hA0|and20|y~combout\) # (\b2v_inst15|fA11|fA0|xor20|y~combout\ $ (\b2v_inst15|fA11|hA0|and20|y~combout\)))) # (!\b2v_inst15|fA10|fA0|xor21|y~combout\ & 
-- (\b2v_inst15|fA20|hA0|and20|y~combout\ & (\b2v_inst15|fA11|fA0|xor20|y~combout\ $ (\b2v_inst15|fA11|hA0|and20|y~combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101111001001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst15|fA11|fA0|xor20|y~combout\,
	datab => \b2v_inst15|fA10|fA0|xor21|y~combout\,
	datac => \b2v_inst15|fA11|hA0|and20|y~combout\,
	datad => \b2v_inst15|fA20|hA0|and20|y~combout\,
	combout => \b2v_inst15|fA20|fA10|or20|y~0_combout\);

-- Location: LCCOMB_X27_Y27_N4
\b2v_inst15|hA03|and20|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \b2v_inst15|hA03|and20|y~combout\ = (\b2v_inst|z\(1) & (!\y[1]~input_o\ & (\y[0]~input_o\ $ (!m_ALTERA_SYNTHESIZED(3))))) # (!\b2v_inst|z\(1) & (\y[1]~input_o\ & (\y[0]~input_o\ $ (m_ALTERA_SYNTHESIZED(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001010010000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst|z\(1),
	datab => \y[0]~input_o\,
	datac => m_ALTERA_SYNTHESIZED(3),
	datad => \y[1]~input_o\,
	combout => \b2v_inst15|hA03|and20|y~combout\);

-- Location: LCCOMB_X27_Y27_N12
\m_ALTERA_SYNTHESIZED~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \m_ALTERA_SYNTHESIZED~2_combout\ = \b2v_inst15|fA20|fA10|or20|y~0_combout\ $ (((\b2v_inst15|fA10|fA0|and20|y~combout\) # ((\b2v_inst15|hA03|and20|y~combout\ & \b2v_inst15|hA02|and20|y~combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011011001100110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b2v_inst15|fA10|fA0|and20|y~combout\,
	datab => \b2v_inst15|fA20|fA10|or20|y~0_combout\,
	datac => \b2v_inst15|hA03|and20|y~combout\,
	datad => \b2v_inst15|hA02|and20|y~combout\,
	combout => \m_ALTERA_SYNTHESIZED~2_combout\);

ww_valid <= \valid~output_o\;

ww_m(0) <= \m[0]~output_o\;

ww_m(1) <= \m[1]~output_o\;

ww_m(2) <= \m[2]~output_o\;

ww_m(3) <= \m[3]~output_o\;
END structure;


