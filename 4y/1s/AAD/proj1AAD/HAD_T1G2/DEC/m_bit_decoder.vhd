LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY m_bit_decoder IS 
	PORT
	(
		y0 :  IN  STD_LOGIC;
		y1 :  IN  STD_LOGIC;
		y2 :  IN  STD_LOGIC;
		y3 :  IN  STD_LOGIC;
		y4 :  IN  STD_LOGIC;
		y5 :  IN  STD_LOGIC;
		y6 :  IN  STD_LOGIC;
		y7 :  IN  STD_LOGIC;
		m_is_one :  OUT  STD_LOGIC;
		m_is_error :  OUT  STD_LOGIC
	);
END m_bit_decoder;

ARCHITECTURE bdf_type OF m_bit_decoder IS 

SIGNAL	c0 :  STD_LOGIC;
SIGNAL	c1 :  STD_LOGIC;
SIGNAL	c1_c0_sum_c3c2 :  STD_LOGIC;
SIGNAL	c2 :  STD_LOGIC;
SIGNAL	c3 :  STD_LOGIC;
SIGNAL	c3_c2_sum_c0c1 :  STD_LOGIC;
SIGNAL	is_error :  STD_LOGIC;
SIGNAL	is_one :  STD_LOGIC;
SIGNAL	is_zero :  STD_LOGIC;
SIGNAL	nc0 :  STD_LOGIC;
SIGNAL	nc1 :  STD_LOGIC;
SIGNAL	nc1_nc0_sum_nc3nc2 :  STD_LOGIC;
SIGNAL	nc2 :  STD_LOGIC;
SIGNAL	nc3 :  STD_LOGIC;
SIGNAL	nc3_nc2_sum_nc0nc1 :  STD_LOGIC;
SIGNAL	sum_c0c1 :  STD_LOGIC;
SIGNAL	sum_c3c2 :  STD_LOGIC;
SIGNAL	sum_nc0nc1 :  STD_LOGIC;
SIGNAL	sum_nc3nc2 :  STD_LOGIC;


BEGIN 

c0 <= y0 XOR y1;
c1 <= y2 XOR y3;
c2 <= y4 XOR y5;
c3 <= y6 XOR y7;

nc0 <= NOT(c0);
nc1 <= NOT(c1);
nc2 <= NOT(c2);
nc3 <= NOT(c3);

sum_c0c1 <= c1 OR c0;
sum_c3c2 <= c3 OR c2;
sum_nc0nc1 <= nc1 OR nc0;
sum_nc3nc2 <= nc3 OR nc2;

c1_c0_sum_c3c2 <= c0 AND c1 AND sum_c3c2;
c3_c2_sum_c0c1 <= sum_c0c1 AND c3 AND c2;
nc1_nc0_sum_nc3nc2 <= nc0 AND nc1 AND sum_nc3nc2;
nc3_nc2_sum_nc0nc1 <= sum_nc0nc1 AND nc3 AND nc2;

is_one <= c1_c0_sum_c3c2 OR c3_c2_sum_c0c1;
is_zero <= nc1_nc0_sum_nc3nc2 OR nc3_nc2_sum_nc0nc1;

m_is_one <= is_one;
m_is_error <= NOT(is_zero OR is_one);

END bdf_type;