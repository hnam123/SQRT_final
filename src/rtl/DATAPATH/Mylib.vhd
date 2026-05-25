LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE Mylib IS

COMPONENT regn IS
GENERIC ( DATA_WIDTH: INTEGER := 16 );
PORT ( Clr, CLK, En : IN STD_LOGIC ;
	D : IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
	Q : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) );
END COMPONENT ;


COMPONENT Shift_r is
    GENERIC (DATA_WIDTH : integer := 16);
    Port (
        DIN    : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        SHIFT  : in  INTEGER range 0 to 2*DATA_WIDTH;
        DOUT   : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end COMPONENT;

COMPONENT Shift_l is
    GENERIC (DATA_WIDTH : integer := 16);
    Port (
        DIN    : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        SHIFT  : in  INTEGER range 0 to 2*DATA_WIDTH;
        DOUT   : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end COMPONENT;

COMPONENT ADDER is
 GENERIC (DATA_WIDTH : integer := 16);
    Port (
        A      : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        B      : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        RESULT : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end COMPONENT;

COMPONENT SUBT is
GENERIC (DATA_WIDTH : integer := 16);
    Port (
        A      : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        B      : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        RESULT : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end COMPONENT;


COMPONENT Multiplier is
Port(

    A  : in  STD_LOGIC_VECTOR(15 downto 0);
    B  : in  STD_LOGIC_VECTOR(15 downto 0);

    Y  : out STD_LOGIC_VECTOR(15 downto 0)
);

end COMPONENT;

COMPONENT datapath IS
GENERIC(DATA_WIDTH : INTEGER := 16);
PORT(CLK,RST :IN STD_LOGIC;
	a_i 	:IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	A_ld:IN STD_LOGIC;
	Sc_sel,Sc_ld, i_sel, i_ld:IN STD_LOGIC;
	A_shift_sel,Sc_new_sel, A_sel,X_sel,Y_sel,X_ld,Y_ld	:IN STD_LOGIC;
	 Sqrt_ld, Sqrt_sel :IN STD_LOGIC;

	Sqrt_o  :OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	a_comp	:OUT STD_LOGIC;
	a_lt_0	:OUT STD_LOGIC;
	A_gt, A_lt : OUT STD_LOGIC;
	i_comp	:OUT STD_LOGIC
);
end COMPONENT;

COMPONENT controller IS
PORT(     RST,CLK    : IN STD_LOGIC;
    Start_i    : IN STD_LOGIC;

    a_comp     : IN STD_LOGIC;
    a_lt_0     : IN STD_LOGIC;
    A_gt       : IN STD_LOGIC;
    A_lt       : IN STD_LOGIC;
    i_comp     : IN STD_LOGIC;

    A_ld            : OUT STD_LOGIC;

    Sc_sel          : OUT STD_LOGIC;
    Sc_ld           : OUT STD_LOGIC;
    Sc_new_sel      : OUT STD_LOGIC;

    i_sel           : OUT STD_LOGIC;
    i_ld            : OUT STD_LOGIC;

    A_sel           : OUT STD_LOGIC;
    X_sel           : OUT STD_LOGIC;
    Y_sel           : OUT STD_LOGIC;

    X_ld            : OUT STD_LOGIC;
    Y_ld            : OUT STD_LOGIC;

    A_shift_sel     : OUT STD_LOGIC;

    Sqrt_ld         : OUT STD_LOGIC;
    Sqrt_sel        : OUT STD_LOGIC;

    Done_o          : OUT STD_LOGIC;
    err             : OUT STD_LOGIC
);
END COMPONENT;

COMPONENT SQRT IS
GENERIC(DATA_WIDTH: INTEGER := 16);
PORT(CLK,RST, Start_i :IN STD_LOGIC;
	a_i 	:IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	Done_o  :OUT STD_LOGIC;
	Sqrt_o  :OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
);
END COMPONENT;

END Mylib;
