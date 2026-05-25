LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY regn IS
 GENERIC (DATA_WIDTH : integer := 16);
 PORT (
	Clr, CLK : IN STD_LOGIC;
	En : IN STD_LOGIC;
	D: IN STD_LOGIC_VECTOR(DATA_WIDTH -  1 DOWNTO 0);
	Q: OUT STD_LOGIC_VECTOR(DATA_WIDTH -  1 DOWNTO 0)
	);
END regn;
ARCHITECTURE RTL OF regn IS
BEGIN
 PROCESS (CLK, Clr)
  BEGIN
   IF (Clr = '1') THEN
	Q <= (OTHERS => '0');
   ELSIF (CLK'EVENT AND CLK = '1') THEN
      IF (En = '1') THEN
	Q <= D;
      END IF;
   END IF;  		
  END PROCESS;
END RTL;

