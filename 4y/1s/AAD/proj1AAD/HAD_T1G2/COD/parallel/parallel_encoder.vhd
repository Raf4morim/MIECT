LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY parallel_encoder IS
  PORT (m: IN STD_LOGIC_VECTOR(3 downto 0);
        x:   OUT STD_LOGIC_VECTOR(7 downto 0));
END parallel_encoder;

ARCHITECTURE structure OF parallel_encoder IS
SIGNAL x0, x1, x2, x3, x4, x5, x6, x7: STD_LOGIC;
BEGIN
--m4 = m(0); m3 = m(1); m2 = m(2); m1 = m(3)
	x0 <= m(0);
	x1 <= m(3) xor m(0);
	x2 <= m(2) xor m(0);
	x3 <= m(3) xor x2;
	x4 <= m(1) xor m(0);
	x5 <= m(3) xor x4;
	x6 <= m(2) xor x4;
	x7 <= m(3) xor x6;
	
x <= x0 & x1 & x2 & x3 & x4 & x5 & x6 & x7;	
	
END structure;