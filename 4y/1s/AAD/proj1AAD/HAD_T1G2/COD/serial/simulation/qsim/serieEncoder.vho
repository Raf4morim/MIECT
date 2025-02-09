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

-- DATE "11/13/2022 13:59:42"

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


LIBRARY ALTERA;
LIBRARY CYCLONEIV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIV.CYCLONEIV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	serial_encoder IS
    PORT (
	nGRst : IN std_logic;
	clk : IN std_logic;
	mIn : IN std_logic;
	code : OUT std_logic_vector(7 DOWNTO 0);
	v : OUT std_logic
	);
END serial_encoder;

-- Design Ports Information
-- code[0]	=>  Location: PIN_N4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- code[1]	=>  Location: PIN_L4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- code[2]	=>  Location: PIN_N6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- code[3]	=>  Location: PIN_M4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- code[4]	=>  Location: PIN_N8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- code[5]	=>  Location: PIN_M6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- code[6]	=>  Location: PIN_N9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- code[7]	=>  Location: PIN_L5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- v	=>  Location: PIN_K8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_J7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- nGRst	=>  Location: PIN_L7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- mIn	=>  Location: PIN_K9,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF serial_encoder IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_nGRst : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_mIn : std_logic;
SIGNAL ww_code : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_v : std_logic;
SIGNAL \clk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \con|nord|y~0clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \code[0]~output_o\ : std_logic;
SIGNAL \code[1]~output_o\ : std_logic;
SIGNAL \code[2]~output_o\ : std_logic;
SIGNAL \code[3]~output_o\ : std_logic;
SIGNAL \code[4]~output_o\ : std_logic;
SIGNAL \code[5]~output_o\ : std_logic;
SIGNAL \code[6]~output_o\ : std_logic;
SIGNAL \code[7]~output_o\ : std_logic;
SIGNAL \v~output_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputclkctrl_outclk\ : std_logic;
SIGNAL \bc|ff0|Q~0_combout\ : std_logic;
SIGNAL \nGRst~input_o\ : std_logic;
SIGNAL \con|nad2|y~0_combout\ : std_logic;
SIGNAL \con|nad2|y~1_combout\ : std_logic;
SIGNAL \bc|ff0|Q~q\ : std_logic;
SIGNAL \con|CountMem|prog~0_combout\ : std_logic;
SIGNAL \bc|ff1|Q~q\ : std_logic;
SIGNAL \bc|ff2|Q~0_combout\ : std_logic;
SIGNAL \bc|ff2|Q~q\ : std_logic;
SIGNAL \con|nord|y~0_combout\ : std_logic;
SIGNAL \con|nord|y~0clkctrl_outclk\ : std_logic;
SIGNAL \mIn~input_o\ : std_logic;
SIGNAL \ff|Q~q\ : std_logic;
SIGNAL \and8|bit0|y~combout\ : std_logic;
SIGNAL \pr8|ff0|Q~q\ : std_logic;
SIGNAL \xor8|bit0|y~combout\ : std_logic;
SIGNAL \finalpr8|ff0|Q~0_combout\ : std_logic;
SIGNAL \con|nad4|y~0_combout\ : std_logic;
SIGNAL \con|nad4|y~1_combout\ : std_logic;
SIGNAL \finalpr8|ff0|Q~q\ : std_logic;
SIGNAL \and8|bit7|y~0_combout\ : std_logic;
SIGNAL \pr8|ff1|Q~q\ : std_logic;
SIGNAL \xor8|bit1|y~combout\ : std_logic;
SIGNAL \finalpr8|ff1|Q~0_combout\ : std_logic;
SIGNAL \finalpr8|ff1|Q~q\ : std_logic;
SIGNAL \pr8|ff2|Q~feeder_combout\ : std_logic;
SIGNAL \pr8|ff2|Q~q\ : std_logic;
SIGNAL \xor8|bit2|y~0_combout\ : std_logic;
SIGNAL \xor8|bit2|y~combout\ : std_logic;
SIGNAL \finalpr8|ff2|Q~0_combout\ : std_logic;
SIGNAL \finalpr8|ff2|Q~q\ : std_logic;
SIGNAL \pr8|ff3|Q~feeder_combout\ : std_logic;
SIGNAL \pr8|ff3|Q~q\ : std_logic;
SIGNAL \xor8|bit3|y~combout\ : std_logic;
SIGNAL \finalpr8|ff3|Q~0_combout\ : std_logic;
SIGNAL \finalpr8|ff3|Q~q\ : std_logic;
SIGNAL \and8|bit2|y~0_combout\ : std_logic;
SIGNAL \pr8|ff4|Q~q\ : std_logic;
SIGNAL \xor8|bit4|y~combout\ : std_logic;
SIGNAL \finalpr8|ff4|Q~0_combout\ : std_logic;
SIGNAL \finalpr8|ff4|Q~q\ : std_logic;
SIGNAL \pr8|ff5|Q~feeder_combout\ : std_logic;
SIGNAL \pr8|ff5|Q~q\ : std_logic;
SIGNAL \xor8|bit5|y~combout\ : std_logic;
SIGNAL \finalpr8|ff5|Q~0_combout\ : std_logic;
SIGNAL \finalpr8|ff5|Q~q\ : std_logic;
SIGNAL \and8|bit6|y~0_combout\ : std_logic;
SIGNAL \pr8|ff6|Q~feeder_combout\ : std_logic;
SIGNAL \pr8|ff6|Q~q\ : std_logic;
SIGNAL \xor8|bit6|y~combout\ : std_logic;
SIGNAL \finalpr8|ff6|Q~0_combout\ : std_logic;
SIGNAL \finalpr8|ff6|Q~q\ : std_logic;
SIGNAL \pr8|ff7|Q~q\ : std_logic;
SIGNAL \xor8|bit7|y~combout\ : std_logic;
SIGNAL \finalpr8|ff7|Q~0_combout\ : std_logic;
SIGNAL \finalpr8|ff7|Q~q\ : std_logic;
SIGNAL \validOut|or2|y~combout\ : std_logic;
SIGNAL \con|nad2|ALT_INV_y~1_combout\ : std_logic;
SIGNAL \con|nad4|ALT_INV_y~1_combout\ : std_logic;
SIGNAL \finalpr8|ff7|ALT_INV_Q~q\ : std_logic;
SIGNAL \finalpr8|ff6|ALT_INV_Q~q\ : std_logic;
SIGNAL \finalpr8|ff5|ALT_INV_Q~q\ : std_logic;
SIGNAL \finalpr8|ff4|ALT_INV_Q~q\ : std_logic;
SIGNAL \finalpr8|ff3|ALT_INV_Q~q\ : std_logic;
SIGNAL \finalpr8|ff2|ALT_INV_Q~q\ : std_logic;
SIGNAL \finalpr8|ff1|ALT_INV_Q~q\ : std_logic;
SIGNAL \finalpr8|ff0|ALT_INV_Q~q\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_nGRst <= nGRst;
ww_clk <= clk;
ww_mIn <= mIn;
code <= ww_code;
v <= ww_v;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\clk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \clk~input_o\);

\con|nord|y~0clkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \con|nord|y~0_combout\);
\con|nad2|ALT_INV_y~1_combout\ <= NOT \con|nad2|y~1_combout\;
\con|nad4|ALT_INV_y~1_combout\ <= NOT \con|nad4|y~1_combout\;
\finalpr8|ff7|ALT_INV_Q~q\ <= NOT \finalpr8|ff7|Q~q\;
\finalpr8|ff6|ALT_INV_Q~q\ <= NOT \finalpr8|ff6|Q~q\;
\finalpr8|ff5|ALT_INV_Q~q\ <= NOT \finalpr8|ff5|Q~q\;
\finalpr8|ff4|ALT_INV_Q~q\ <= NOT \finalpr8|ff4|Q~q\;
\finalpr8|ff3|ALT_INV_Q~q\ <= NOT \finalpr8|ff3|Q~q\;
\finalpr8|ff2|ALT_INV_Q~q\ <= NOT \finalpr8|ff2|Q~q\;
\finalpr8|ff1|ALT_INV_Q~q\ <= NOT \finalpr8|ff1|Q~q\;
\finalpr8|ff0|ALT_INV_Q~q\ <= NOT \finalpr8|ff0|Q~q\;
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: IOOBUF_X10_Y0_N9
\code[0]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \finalpr8|ff0|ALT_INV_Q~q\,
	devoe => ww_devoe,
	o => \code[0]~output_o\);

-- Location: IOOBUF_X8_Y0_N9
\code[1]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \finalpr8|ff1|ALT_INV_Q~q\,
	devoe => ww_devoe,
	o => \code[1]~output_o\);

-- Location: IOOBUF_X12_Y0_N2
\code[2]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \finalpr8|ff2|ALT_INV_Q~q\,
	devoe => ww_devoe,
	o => \code[2]~output_o\);

-- Location: IOOBUF_X8_Y0_N2
\code[3]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \finalpr8|ff3|ALT_INV_Q~q\,
	devoe => ww_devoe,
	o => \code[3]~output_o\);

-- Location: IOOBUF_X20_Y0_N9
\code[4]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \finalpr8|ff4|ALT_INV_Q~q\,
	devoe => ww_devoe,
	o => \code[4]~output_o\);

-- Location: IOOBUF_X12_Y0_N9
\code[5]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \finalpr8|ff5|ALT_INV_Q~q\,
	devoe => ww_devoe,
	o => \code[5]~output_o\);

-- Location: IOOBUF_X20_Y0_N2
\code[6]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \finalpr8|ff6|ALT_INV_Q~q\,
	devoe => ww_devoe,
	o => \code[6]~output_o\);

-- Location: IOOBUF_X14_Y0_N9
\code[7]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \finalpr8|ff7|ALT_INV_Q~q\,
	devoe => ww_devoe,
	o => \code[7]~output_o\);

-- Location: IOOBUF_X22_Y0_N9
\v~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \validOut|or2|y~combout\,
	devoe => ww_devoe,
	o => \v~output_o\);

-- Location: IOIBUF_X16_Y0_N15
\clk~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: CLKCTRL_G17
\clk~inputclkctrl\ : cycloneiv_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk~inputclkctrl_outclk\);

-- Location: LCCOMB_X13_Y3_N4
\bc|ff0|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \bc|ff0|Q~0_combout\ = !\bc|ff0|Q~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \bc|ff0|Q~q\,
	combout => \bc|ff0|Q~0_combout\);

-- Location: IOIBUF_X14_Y0_N1
\nGRst~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_nGRst,
	o => \nGRst~input_o\);

-- Location: LCCOMB_X14_Y3_N0
\con|nad2|y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \con|nad2|y~0_combout\ = (\bc|ff1|Q~q\ & !\bc|ff0|Q~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \bc|ff1|Q~q\,
	datad => \bc|ff0|Q~q\,
	combout => \con|nad2|y~0_combout\);

-- Location: LCCOMB_X14_Y3_N22
\con|nad2|y~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \con|nad2|y~1_combout\ = (\clk~input_o\ & (((\bc|ff2|Q~q\ & \con|nad2|y~0_combout\)) # (!\nGRst~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011000000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \bc|ff2|Q~q\,
	datab => \nGRst~input_o\,
	datac => \clk~input_o\,
	datad => \con|nad2|y~0_combout\,
	combout => \con|nad2|y~1_combout\);

-- Location: FF_X13_Y3_N5
\bc|ff0|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \bc|ff0|Q~0_combout\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \bc|ff0|Q~q\);

-- Location: LCCOMB_X13_Y3_N22
\con|CountMem|prog~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \con|CountMem|prog~0_combout\ = \bc|ff1|Q~q\ $ (\bc|ff0|Q~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \bc|ff1|Q~q\,
	datac => \bc|ff0|Q~q\,
	combout => \con|CountMem|prog~0_combout\);

-- Location: FF_X15_Y3_N29
\bc|ff1|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	asdata => \con|CountMem|prog~0_combout\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \bc|ff1|Q~q\);

-- Location: LCCOMB_X15_Y3_N30
\bc|ff2|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \bc|ff2|Q~0_combout\ = \bc|ff2|Q~q\ $ (((\bc|ff1|Q~q\ & \bc|ff0|Q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \bc|ff1|Q~q\,
	datac => \bc|ff2|Q~q\,
	datad => \bc|ff0|Q~q\,
	combout => \bc|ff2|Q~0_combout\);

-- Location: FF_X15_Y3_N31
\bc|ff2|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \bc|ff2|Q~0_combout\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \bc|ff2|Q~q\);

-- Location: LCCOMB_X15_Y3_N24
\con|nord|y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \con|nord|y~0_combout\ = LCELL((!\clk~input_o\ & (\bc|ff2|Q~q\ & !\bc|ff1|Q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \clk~input_o\,
	datac => \bc|ff2|Q~q\,
	datad => \bc|ff1|Q~q\,
	combout => \con|nord|y~0_combout\);

-- Location: CLKCTRL_G15
\con|nord|y~0clkctrl\ : cycloneiv_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \con|nord|y~0clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \con|nord|y~0clkctrl_outclk\);

-- Location: IOIBUF_X22_Y0_N1
\mIn~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_mIn,
	o => \mIn~input_o\);

-- Location: FF_X14_Y3_N5
\ff|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \mIn~input_o\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \ff|Q~q\);

-- Location: LCCOMB_X14_Y3_N6
\and8|bit0|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \and8|bit0|y~combout\ = (\ff|Q~q\ & (\bc|ff2|Q~q\ $ (((\bc|ff1|Q~q\) # (\bc|ff0|Q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000001100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \bc|ff2|Q~q\,
	datab => \bc|ff1|Q~q\,
	datac => \ff|Q~q\,
	datad => \bc|ff0|Q~q\,
	combout => \and8|bit0|y~combout\);

-- Location: FF_X14_Y3_N25
\pr8|ff0|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \xor8|bit0|y~combout\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr8|ff0|Q~q\);

-- Location: LCCOMB_X14_Y3_N10
\xor8|bit0|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \xor8|bit0|y~combout\ = \and8|bit0|y~combout\ $ (\pr8|ff0|Q~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \and8|bit0|y~combout\,
	datad => \pr8|ff0|Q~q\,
	combout => \xor8|bit0|y~combout\);

-- Location: LCCOMB_X14_Y3_N20
\finalpr8|ff0|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \finalpr8|ff0|Q~0_combout\ = !\xor8|bit0|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \xor8|bit0|y~combout\,
	combout => \finalpr8|ff0|Q~0_combout\);

-- Location: LCCOMB_X13_Y3_N6
\con|nad4|y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \con|nad4|y~0_combout\ = ((!\bc|ff0|Q~q\ & (\bc|ff2|Q~q\ $ (!\bc|ff1|Q~q\)))) # (!\nGRst~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011101100110111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \bc|ff2|Q~q\,
	datab => \nGRst~input_o\,
	datac => \bc|ff0|Q~q\,
	datad => \bc|ff1|Q~q\,
	combout => \con|nad4|y~0_combout\);

-- Location: LCCOMB_X13_Y3_N0
\con|nad4|y~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \con|nad4|y~1_combout\ = (\clk~input_o\ & \con|nad4|y~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \clk~input_o\,
	datad => \con|nad4|y~0_combout\,
	combout => \con|nad4|y~1_combout\);

-- Location: FF_X14_Y3_N21
\finalpr8|ff0|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \con|nord|y~0clkctrl_outclk\,
	d => \finalpr8|ff0|Q~0_combout\,
	clrn => \con|nad4|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \finalpr8|ff0|Q~q\);

-- Location: LCCOMB_X14_Y3_N24
\and8|bit7|y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \and8|bit7|y~0_combout\ = (!\bc|ff2|Q~q\ & \ff|Q~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \bc|ff2|Q~q\,
	datad => \ff|Q~q\,
	combout => \and8|bit7|y~0_combout\);

-- Location: FF_X14_Y3_N11
\pr8|ff1|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \xor8|bit1|y~combout\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr8|ff1|Q~q\);

-- Location: LCCOMB_X14_Y3_N8
\xor8|bit1|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \xor8|bit1|y~combout\ = \pr8|ff1|Q~q\ $ (((\and8|bit7|y~0_combout\ & ((\bc|ff0|Q~q\) # (\bc|ff1|Q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011011111001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \bc|ff0|Q~q\,
	datab => \and8|bit7|y~0_combout\,
	datac => \bc|ff1|Q~q\,
	datad => \pr8|ff1|Q~q\,
	combout => \xor8|bit1|y~combout\);

-- Location: LCCOMB_X13_Y3_N12
\finalpr8|ff1|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \finalpr8|ff1|Q~0_combout\ = !\xor8|bit1|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \xor8|bit1|y~combout\,
	combout => \finalpr8|ff1|Q~0_combout\);

-- Location: FF_X13_Y3_N13
\finalpr8|ff1|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \con|nord|y~0clkctrl_outclk\,
	d => \finalpr8|ff1|Q~0_combout\,
	clrn => \con|nad4|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \finalpr8|ff1|Q~q\);

-- Location: LCCOMB_X13_Y3_N30
\pr8|ff2|Q~feeder\ : cycloneiv_lcell_comb
-- Equation(s):
-- \pr8|ff2|Q~feeder_combout\ = \xor8|bit2|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \xor8|bit2|y~combout\,
	combout => \pr8|ff2|Q~feeder_combout\);

-- Location: FF_X13_Y3_N31
\pr8|ff2|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \pr8|ff2|Q~feeder_combout\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr8|ff2|Q~q\);

-- Location: LCCOMB_X13_Y3_N28
\xor8|bit2|y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \xor8|bit2|y~0_combout\ = (\bc|ff2|Q~q\ & ((\bc|ff0|Q~q\) # (\bc|ff1|Q~q\))) # (!\bc|ff2|Q~q\ & (\bc|ff0|Q~q\ $ (!\bc|ff1|Q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101010100101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \bc|ff2|Q~q\,
	datac => \bc|ff0|Q~q\,
	datad => \bc|ff1|Q~q\,
	combout => \xor8|bit2|y~0_combout\);

-- Location: LCCOMB_X13_Y3_N2
\xor8|bit2|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \xor8|bit2|y~combout\ = \pr8|ff2|Q~q\ $ (((\ff|Q~q\ & !\xor8|bit2|y~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \ff|Q~q\,
	datac => \pr8|ff2|Q~q\,
	datad => \xor8|bit2|y~0_combout\,
	combout => \xor8|bit2|y~combout\);

-- Location: LCCOMB_X13_Y3_N26
\finalpr8|ff2|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \finalpr8|ff2|Q~0_combout\ = !\xor8|bit2|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \xor8|bit2|y~combout\,
	combout => \finalpr8|ff2|Q~0_combout\);

-- Location: FF_X13_Y3_N27
\finalpr8|ff2|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \con|nord|y~0clkctrl_outclk\,
	d => \finalpr8|ff2|Q~0_combout\,
	clrn => \con|nad4|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \finalpr8|ff2|Q~q\);

-- Location: LCCOMB_X13_Y3_N24
\pr8|ff3|Q~feeder\ : cycloneiv_lcell_comb
-- Equation(s):
-- \pr8|ff3|Q~feeder_combout\ = \xor8|bit3|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \xor8|bit3|y~combout\,
	combout => \pr8|ff3|Q~feeder_combout\);

-- Location: FF_X13_Y3_N25
\pr8|ff3|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \pr8|ff3|Q~feeder_combout\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr8|ff3|Q~q\);

-- Location: LCCOMB_X13_Y3_N8
\xor8|bit3|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \xor8|bit3|y~combout\ = \pr8|ff3|Q~q\ $ (((\con|CountMem|prog~0_combout\ & (\ff|Q~q\ & !\bc|ff2|Q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110001101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \con|CountMem|prog~0_combout\,
	datab => \pr8|ff3|Q~q\,
	datac => \ff|Q~q\,
	datad => \bc|ff2|Q~q\,
	combout => \xor8|bit3|y~combout\);

-- Location: LCCOMB_X13_Y3_N16
\finalpr8|ff3|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \finalpr8|ff3|Q~0_combout\ = !\xor8|bit3|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \xor8|bit3|y~combout\,
	combout => \finalpr8|ff3|Q~0_combout\);

-- Location: FF_X13_Y3_N17
\finalpr8|ff3|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \con|nord|y~0clkctrl_outclk\,
	d => \finalpr8|ff3|Q~0_combout\,
	clrn => \con|nad4|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \finalpr8|ff3|Q~q\);

-- Location: LCCOMB_X14_Y3_N2
\and8|bit2|y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \and8|bit2|y~0_combout\ = (\bc|ff2|Q~q\ & (!\bc|ff1|Q~q\ & (\ff|Q~q\ & !\bc|ff0|Q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \bc|ff2|Q~q\,
	datab => \bc|ff1|Q~q\,
	datac => \ff|Q~q\,
	datad => \bc|ff0|Q~q\,
	combout => \and8|bit2|y~0_combout\);

-- Location: FF_X14_Y3_N1
\pr8|ff4|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \xor8|bit4|y~combout\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr8|ff4|Q~q\);

-- Location: LCCOMB_X14_Y3_N26
\xor8|bit4|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \xor8|bit4|y~combout\ = \pr8|ff4|Q~q\ $ (((\and8|bit2|y~0_combout\) # ((\and8|bit7|y~0_combout\ & \bc|ff0|Q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001111000111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \and8|bit7|y~0_combout\,
	datab => \and8|bit2|y~0_combout\,
	datac => \pr8|ff4|Q~q\,
	datad => \bc|ff0|Q~q\,
	combout => \xor8|bit4|y~combout\);

-- Location: LCCOMB_X14_Y3_N30
\finalpr8|ff4|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \finalpr8|ff4|Q~0_combout\ = !\xor8|bit4|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \xor8|bit4|y~combout\,
	combout => \finalpr8|ff4|Q~0_combout\);

-- Location: FF_X14_Y3_N31
\finalpr8|ff4|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \con|nord|y~0clkctrl_outclk\,
	d => \finalpr8|ff4|Q~0_combout\,
	clrn => \con|nad4|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \finalpr8|ff4|Q~q\);

-- Location: LCCOMB_X13_Y3_N20
\pr8|ff5|Q~feeder\ : cycloneiv_lcell_comb
-- Equation(s):
-- \pr8|ff5|Q~feeder_combout\ = \xor8|bit5|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \xor8|bit5|y~combout\,
	combout => \pr8|ff5|Q~feeder_combout\);

-- Location: FF_X13_Y3_N21
\pr8|ff5|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \pr8|ff5|Q~feeder_combout\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr8|ff5|Q~q\);

-- Location: LCCOMB_X13_Y3_N14
\xor8|bit5|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \xor8|bit5|y~combout\ = \pr8|ff5|Q~q\ $ (((!\bc|ff2|Q~q\ & (\bc|ff0|Q~q\ & \ff|Q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001101010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \pr8|ff5|Q~q\,
	datab => \bc|ff2|Q~q\,
	datac => \bc|ff0|Q~q\,
	datad => \ff|Q~q\,
	combout => \xor8|bit5|y~combout\);

-- Location: LCCOMB_X13_Y3_N10
\finalpr8|ff5|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \finalpr8|ff5|Q~0_combout\ = !\xor8|bit5|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \xor8|bit5|y~combout\,
	combout => \finalpr8|ff5|Q~0_combout\);

-- Location: FF_X13_Y3_N11
\finalpr8|ff5|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \con|nord|y~0clkctrl_outclk\,
	d => \finalpr8|ff5|Q~0_combout\,
	clrn => \con|nad4|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \finalpr8|ff5|Q~q\);

-- Location: LCCOMB_X14_Y3_N4
\and8|bit6|y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \and8|bit6|y~0_combout\ = (!\bc|ff1|Q~q\ & (\ff|Q~q\ & (\bc|ff2|Q~q\ $ (\bc|ff0|Q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \bc|ff2|Q~q\,
	datab => \bc|ff1|Q~q\,
	datac => \ff|Q~q\,
	datad => \bc|ff0|Q~q\,
	combout => \and8|bit6|y~0_combout\);

-- Location: LCCOMB_X14_Y3_N16
\pr8|ff6|Q~feeder\ : cycloneiv_lcell_comb
-- Equation(s):
-- \pr8|ff6|Q~feeder_combout\ = \xor8|bit6|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \xor8|bit6|y~combout\,
	combout => \pr8|ff6|Q~feeder_combout\);

-- Location: FF_X14_Y3_N17
\pr8|ff6|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \pr8|ff6|Q~feeder_combout\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr8|ff6|Q~q\);

-- Location: LCCOMB_X14_Y3_N18
\xor8|bit6|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \xor8|bit6|y~combout\ = \and8|bit6|y~0_combout\ $ (\pr8|ff6|Q~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \and8|bit6|y~0_combout\,
	datad => \pr8|ff6|Q~q\,
	combout => \xor8|bit6|y~combout\);

-- Location: LCCOMB_X14_Y3_N12
\finalpr8|ff6|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \finalpr8|ff6|Q~0_combout\ = !\xor8|bit6|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \xor8|bit6|y~combout\,
	combout => \finalpr8|ff6|Q~0_combout\);

-- Location: FF_X14_Y3_N13
\finalpr8|ff6|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \con|nord|y~0clkctrl_outclk\,
	d => \finalpr8|ff6|Q~0_combout\,
	clrn => \con|nad4|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \finalpr8|ff6|Q~q\);

-- Location: FF_X14_Y3_N19
\pr8|ff7|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \xor8|bit7|y~combout\,
	clrn => \con|nad2|ALT_INV_y~1_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr8|ff7|Q~q\);

-- Location: LCCOMB_X14_Y3_N28
\xor8|bit7|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \xor8|bit7|y~combout\ = \pr8|ff7|Q~q\ $ (((\bc|ff0|Q~q\ & (\and8|bit7|y~0_combout\ & !\bc|ff1|Q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000001111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \bc|ff0|Q~q\,
	datab => \and8|bit7|y~0_combout\,
	datac => \pr8|ff7|Q~q\,
	datad => \bc|ff1|Q~q\,
	combout => \xor8|bit7|y~combout\);

-- Location: LCCOMB_X14_Y3_N14
\finalpr8|ff7|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \finalpr8|ff7|Q~0_combout\ = !\xor8|bit7|y~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \xor8|bit7|y~combout\,
	combout => \finalpr8|ff7|Q~0_combout\);

-- Location: FF_X14_Y3_N15
\finalpr8|ff7|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \con|nord|y~0clkctrl_outclk\,
	d => \finalpr8|ff7|Q~0_combout\,
	clrn => \con|nad4|ALT_INV_y~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \finalpr8|ff7|Q~q\);

-- Location: LCCOMB_X15_Y3_N28
\validOut|or2|y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \validOut|or2|y~combout\ = (\con|nord|y~0_combout\) # ((\bc|ff2|Q~q\ & \bc|ff0|Q~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \con|nord|y~0_combout\,
	datab => \bc|ff2|Q~q\,
	datad => \bc|ff0|Q~q\,
	combout => \validOut|or2|y~combout\);

ww_code(0) <= \code[0]~output_o\;

ww_code(1) <= \code[1]~output_o\;

ww_code(2) <= \code[2]~output_o\;

ww_code(3) <= \code[3]~output_o\;

ww_code(4) <= \code[4]~output_o\;

ww_code(5) <= \code[5]~output_o\;

ww_code(6) <= \code[6]~output_o\;

ww_code(7) <= \code[7]~output_o\;

ww_v <= \v~output_o\;
END structure;


