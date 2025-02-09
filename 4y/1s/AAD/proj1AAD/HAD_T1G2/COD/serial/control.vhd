
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY flipFlopD IS
  PORT (clk, D:     IN STD_LOGIC;
        nSet, nRst: IN STD_LOGIC;
        Q, nQ:      OUT STD_LOGIC);
END flipFlopD;

ARCHITECTURE behavior OF flipFlopD IS
BEGIN
  PROCESS (clk, nSet, nRst)
  BEGIN
    IF (nRst = '0')
	    THEN Q <= '0';
		      nQ <= '1';
		 ELSIF (nSet = '0')
		       THEN Q <= '1';
		            nQ <= '0';
	          ELSIF (clk = '1') AND (clk'EVENT)
	                THEN Q <= D;
		                  nQ <= NOT D;

	 END IF;
  END PROCESS;
END behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ParReg_8bit IS
  PORT (nSet: IN STD_LOGIC;
			nRst: IN STD_LOGIC;
        clk: IN STD_LOGIC;
        D: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        Q: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END ParReg_8bit;

ARCHITECTURE structure OF ParReg_8bit IS
    COMPONENT flipFlopD
    PORT (clk, D: IN STD_LOGIC;
          nSet, nRst: IN STD_LOGIC;
          Q, nQ: OUT STD_LOGIC);
  END COMPONENT;
BEGIN
  ff0: flipFlopD PORT MAP (clk, D(0), nSet, nRst, Q(0));
  ff1: flipFlopD PORT MAP (clk, D(1), nSet, nRst, Q(1));
  ff2: flipFlopD PORT MAP (clk, D(2), nSet, nRst, Q(2));
  ff3: flipFlopD PORT MAP (clk, D(3), nSet, nRst, Q(3));
  ff4: flipFlopD PORT MAP (clk, D(4), nSet, nRst, Q(4));
  ff5: flipFlopD PORT MAP (clk, D(5), nSet, nRst, Q(5));
  ff6: flipFlopD PORT MAP (clk, D(6), nSet, nRst, Q(6));
  ff7: flipFlopD PORT MAP (clk, D(7), nSet, nRst, Q(7));

END structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY simpleLogic;
USE simpleLogic.all;

ENTITY count3b IS
  PORT (nRst: IN STD_LOGIC;
        clk:  IN STD_LOGIC;
        c:    OUT STD_LOGIC_VECTOR (2 DOWNTO 0));
END count3b;

ARCHITECTURE structure OF count3b IS
  SIGNAL pD1: STD_LOGIC;
  SIGNAL iD1, iD2: STD_LOGIC;
  SIGNAL iQ0, iQ1, iQ2: STD_LOGIC;
  SIGNAL inQ0: STD_LOGIC;
  COMPONENT gateAnd2
    PORT (x1, x2: IN STD_LOGIC;
          y:      OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT gateXor2
    PORT (x1, x2: IN STD_LOGIC;
          y:      OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT flipFlopD
    PORT (clk, D:     IN STD_LOGIC;
          nSet, nRst: IN STD_LOGIC;
          Q, nQ:      OUT STD_LOGIC);
  END COMPONENT;
BEGIN
  ad1: gateAnd2 PORT MAP (iQ0, iQ1, pD1);
  xr1: gateXor2 PORT MAP (iQ0, iQ1, iD1);
  xr2: gateXor2 PORT MAP (pD1, iQ2, iD2);
  ff0: flipFlopD PORT MAP (clk, inQ0, '1', nRst, iQ0, inQ0);
  ff1: flipFlopD PORT MAP (clk, iD1,  '1', nRst, iQ1);
  ff2: flipFlopD PORT MAP (clk, iD2,  '1', nRst, iQ2);
  c(0) <= iQ0;
  c(1) <= iQ1;
  c(2) <= iQ2;
 END structure;
 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY mem IS
  PORT (add:  IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        dOut: OUT STD_LOGIC_VECTOR (10 DOWNTO 0));
END mem;

ARCHITECTURE behavior OF mem IS
BEGIN
  PROCESS (add)
    TYPE CountMem IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR (10 DOWNTO 0);
    VARIABLE prog: CountMem := (CONV_STD_LOGIC_VECTOR (16#5#, 11),
									 CONV_STD_LOGIC_VECTOR (16#7FF#, 11),  
                            CONV_STD_LOGIC_VECTOR (16#7F#, 11),   
                            CONV_STD_LOGIC_VECTOR (16#19F#, 11),  
                            CONV_STD_LOGIC_VECTOR (16#2AE#, 11),
                            CONV_STD_LOGIC_VECTOR (16#6#, 11),   
                            CONV_STD_LOGIC_VECTOR (16#1#, 11),
									 CONV_STD_LOGIC_VECTOR (16#7#, 11)
									 );
    VARIABLE pos: INTEGER;
  BEGIN
    pos := CONV_INTEGER (add);
    dOut <= prog(pos);
  END PROCESS;
END behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY simpleLogic;
USE simpleLogic.all;

ENTITY control IS
  PORT (nGRst: IN STD_LOGIC;
        clk:   IN STD_LOGIC;
        add:   IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        nRst:  OUT STD_LOGIC;
        nSetO: OUT STD_LOGIC;
		  f:		OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        clkO:  OUT STD_LOGIC);
END control;

ARCHITECTURE structure OF control IS
  SIGNAL cLines: STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL iNRst, iNSetO: STD_LOGIC;
  COMPONENT mem
    PORT (add:  IN STD_LOGIC_VECTOR (2 DOWNTO 0);
          dOut: OUT STD_LOGIC_VECTOR (10 DOWNTO 0));
  END COMPONENT;
  COMPONENT gateNand2
    PORT (x1, x2: IN STD_LOGIC;
          y:      OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT gateNor2
    PORT (x1, x2: IN STD_LOGIC;
          y:      OUT STD_LOGIC);
  END COMPONENT;
BEGIN
  CountMem: mem   PORT MAP (add, cLines);
  nad1: gateNand2 PORT MAP (nGRst, cLines(2), iNRst);
  nad2: gateNand2 PORT MAP (clk, iNRst, nRst);
  nad3: gateNand2 PORT MAP (nGRst, cLines(1), iNSetO);
  nad4: gateNand2 PORT MAP (clk, iNSetO, nSetO);
  nord: gateNor2  PORT MAP (clk, cLines(0), clkO);
  f <= cLines(10 DOWNTO 3);
END structure;