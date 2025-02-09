LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY partial_encoder IS
  PORT (m1, m2, m3: IN STD_LOGIC;
        z:   OUT STD_LOGIC_VECTOR(7 downto 0));
END partial_encoder;

ARCHITECTURE structure OF partial_encoder IS
SIGNAL x0, x1, x2, x3, x4, x5, x6, x7: STD_LOGIC;
BEGIN

	x0 <= '0';
	x1 <= m1 xor '0';
	x2 <= m2 xor '0';
	x3 <= m1 xor x2;
	x4 <= m3 xor '0';
	x5 <= m1 xor x4;
	x6 <= m2 xor x4;
	x7 <= m1 xor x6;
	
z <= x0 & x1 & x2 & x3 & x4 & x5 & x6 & x7;	
	
END structure;


