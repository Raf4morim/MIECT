LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY control;
USE control.all;

LIBRARY arithmetic;
USE arithmetic.all;

LIBRARY simpleLogic;
USE simpleLogic.all;

ENTITY serial_encoder IS
  PORT (nGRst: IN STD_LOGIC;
		  clk:   IN STD_LOGIC;
		  mIn:   IN STD_LOGIC;
		  code:  OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		  v:	OUT STD_LOGIC);
END serial_encoder;

ARCHITECTURE structure OF serial_encoder IS
  SIGNAL iNSetO, iNRst, s_Q, clkO: STD_LOGIC;
  SIGNAL stat:  STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL s_Qto8, s_and2xor, s_xorIn, s_xorOut, s_f, s_code: STD_LOGIC_VECTOR (7 DOWNTO 0);
  COMPONENT flipFlopD
	 PORT (clk, D: IN STD_LOGIC;
			 nSet, nRst: IN STD_LOGIC;
			 Q, nQ: OUT STD_LOGIC);
  END COMPONENT;
	COMPONENT gateAnd8
		PORT (x1, x2: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  y:      OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
		END COMPONENT;
	COMPONENT gateXor8
		PORT (x1, x2: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  y:      OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
		END COMPONENT;
  COMPONENT ParReg_8bit
	 PORT (nSet: IN STD_LOGIC;
			nRst: IN STD_LOGIC;
        clk: IN STD_LOGIC;
        D: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        Q: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
  END COMPONENT;
  COMPONENT count3b
	 PORT (nRst: IN STD_LOGIC;
			 clk:  IN STD_LOGIC;
			 c:    OUT STD_LOGIC_VECTOR (2 DOWNTO 0));
  END COMPONENT;
  COMPONENT control
	  PORT (nGRst: IN STD_LOGIC;
        clk:   IN STD_LOGIC;
        add:   IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        nRst:  OUT STD_LOGIC;
        nSetO: OUT STD_LOGIC;
		  f:		OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        clkO:  OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT validOutput
		PORT (x1, x2, y: IN STD_LOGIC;
				z:      OUT STD_LOGIC);
  END COMPONENT;
BEGIN
  ff:  flipFlopD PORT MAP (clk, mIn, '1', iNRst, s_Q);
  s_Qto8 <= (OTHERS=>s_Q);
  and8: gateAnd8 PORT MAP (s_Qto8, s_f, s_and2xor);
  xor8: gateXor8 PORT MAP (s_and2xor, s_xorIn, s_xorOut);
  pr8:  ParReg_8bit PORT MAP ('1', iNRst, clk, s_xorOut, s_xorIn);
  bc:   count3b PORT MAP (iNRst, clk, stat);
  con:  control  PORT MAP (nGRst, clk, stat, iNRst, iNSetO, s_f, clkO);
  finalpr8: ParReg_8bit PORT MAP (iNSetO, '1', clkO, s_xorOut, s_code);
  code <= s_code;
  validOut: validOutput PORT MAP(stat(2), stat(0), clkO, v);
END structure;
