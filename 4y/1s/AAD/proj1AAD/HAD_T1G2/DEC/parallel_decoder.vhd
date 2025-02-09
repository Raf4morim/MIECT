LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY parallel_decoder IS
	PORT (y: IN STD_LOGIC_VECTOR(7 downto 0);
			m: OUT STD_LOGIC_VECTOR(3 downto 0);
			valid: OUT STD_LOGIC);

END parallel_decoder;

