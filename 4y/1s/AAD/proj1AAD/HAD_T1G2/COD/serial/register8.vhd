LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY register8 IS
  PORT (Din: IN STD_LOGIC_VECTOR(7 downto 0);
		 Grst: IN STD_LOGIC;
       Qout: OUT STD_LOGIC_VECTOR(7 downto 0));
END register8;

ARCHITECTURE logicFunction OF register8 IS
	signal y_tmp : std_logic;

	component gateXOR2
		port(x0,x1 : in STD_LOGIC;
					y: out STD_LOGIC);
	end component;

BEGIN

   xor_1: gateXOR2 port map(x0,x1,y_tmp);
	xor_final: gateXOR2 port map(y_tmp,x2,y);
  
END logicFunction;