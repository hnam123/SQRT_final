LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Mylib.all;

ENTITY SQRT_tb IS
END SQRT_tb;

ARCHITECTURE bev OF SQRT_tb IS
 Constant DATA_WIDTH : integer := 16;
 SIGNAL RST, CLK :  STD_LOGIC := '0';
 SIGNAL	Start_i:  STD_LOGIC;
 SIGNAL	a_i:  STD_LOGIC_VECTOR(DATA_WIDTH -  1 downto 0);
 SIGNAL	SQRT_o: 	 STD_LOGIC_VECTOR(DATA_WIDTH -  1 downto 0);
 SIGNAL	Done_o,err :  STD_LOGIC;
COMPONENT SQRT IS
PORT(CLK,RST, Start_i :IN STD_LOGIC;
	a_i 	:IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	Done_o,err  :OUT STD_LOGIC;
	Sqrt_o  :OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
);
END COMPONENT;
BEGIN

UUT: SQRT
 PORT MAP(CLK,RST, Start_i ,
	a_i ,
	Done_o ,err,
	Sqrt_o
);
CLK <= not CLK  after 10 ns;
-- stimulus
Stimulus: PROCESS
 BEGIN
--case 0
  START_i <= '0';
  RST <= '1'; wait for 20 ns;
  RST <= '0'; wait for 20 ns;
--case 1 a_i = 0
  a_i <= "0000000000000000";
  Start_i <= '1';
  wait until Done_o = '1';
  Start_i <= '0';
  wait for 100 ns;
--case 2 a_i = 0.25
  a_i <= "0001000000000000";
  Start_i <= '1';
  wait until Done_o = '1';
  Start_i <= '0';
  wait for 100 ns;
--case 3 a_i = 0.5
  a_i <= "0010000000000000";
  Start_i <= '1';
  wait until Done_o = '1';
  Start_i <= '0';
  wait for 100 ns;
--case 4 a_i = 1
  a_i <= "0100000000000000";
  Start_i <= '1';
  wait until Done_o = '1';
  Start_i <= '0';
  wait for 100 ns;
--case 5 a_i = 1.25
  a_i <= "0101000000000000";
  Start_i <= '1';
  wait until Done_o = '1';
  Start_i <= '0';
  wait for 100 ns;
--case 6 a_i = -0.25
  a_i <= "1111000000000000";
  Start_i <= '1';
  wait until Done_o = '1';
  Start_i <= '0';
  wait for 100 ns;
--case 6 a_i = 0.75
  a_i <= "0011000000000000";
  Start_i <= '1';
  wait until Done_o = '1';
  Start_i <= '0';
  wait for 100 ns;
--case 7 a_i = 1.75
  a_i <= "0111000000000000";
  Start_i <= '1';
  wait until Done_o = '1';
  Start_i <= '0';
--case 8 a_i = 1.99994
  a_i <= "0111111111111111";
  Start_i <= '1';
  wait until Done_o = '1';
  Start_i <= '0';
  wait for 100 ns;
END PROCESS;
END BEV;
