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
--x0 = x(7); x1 = x(6); x2 = x(5); x3 = x(4)
--x4 = x(3); x5 = x(2); x6 = x(1); x7 = x(0)
	x0 <= m(0);
	x1 <= m(3) xor m(0);
	x2 <= m(2) xor m(0);
	x3 <= m(3) xor x5;
	x4 <= m(1) xor m(0);
	x5 <= m(3) xor x3;
	x6 <= m(2) xor x3;
	x7 <= m(3) xor x1;
	
x <= x0 & x1 & x2 & x3 & x4 & x5 & x6 & x7;	
	
END structure;