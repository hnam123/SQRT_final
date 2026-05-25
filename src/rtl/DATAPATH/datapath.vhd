Library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Mylib.all;
Entity datapath IS
GENERIC(DATA_WIDTH : INTEGER := 16);
PORT( CLK,RST :IN STD_LOGIC;
	a_i 	:IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	A_ld:IN STD_LOGIC;
	Sc_sel,Sc_ld, i_sel, i_ld:IN STD_LOGIC;
	A_shift_sel,Sc_new_sel, A_sel,X_sel,Y_sel,X_ld,Y_ld	:IN STD_LOGIC;
	 Sqrt_ld, Sqrt_sel :IN STD_LOGIC;

	Sqrt_o  :OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	a_comp	:OUT STD_LOGIC;
	a_lt_0	:OUT STD_LOGIC;
	A_gt, A_lt : OUT STD_LOGIC;
	i_comp:OUT STD_LOGIC
);
end datapath;

ARCHITECTURE arc of datapath IS
SIGNAL  A_shift,A_shift_right,X_ADD,X_SUB,Y_ADD,Y_SUB, A_shift_left,X_shift_right,Y_shift_right, A_src, X_src, Y_src, X_a, Y_a, A, X, Y, X_new, Y_new, X_shift, Y_shift, Sqrt, Sqrt_src, Sqrt_shift,Sqrt_shift_right,Sqrt_shift_left, K : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
SIGNAL i_src, i, i_add, Sc_src, Sc, Sc_new,Sc_ADD,Sc_SUB :STD_LOGIC_VECTOR(5 downto 0);
SIGNAL shift_val_1, shift_val_2 :integer range 0 to 32;
SIGNAL Sc_lt, Y_comp: STD_LOGIC;
Begin
--comp a_i vs 0
a_comp <= '1' when (signed(a_i) = to_signed(0,DATA_WIDTH)) else '0';
a_lt_0 <= '1' when (signed(a_i) < to_signed(0,DATA_WIDTH)) else '0';
--21mux A
A_src <= a_i when A_sel = '0' else A_shift;

--shift A
Shift_right_A: Shift_r
GENERIC MAP(DATA_WIDTH)
port map(
    DIN   => A,
    SHIFT => 2,
    DOUT  => A_shift_right
);
Shift_left_A: Shift_l
GENERIC MAP(DATA_WIDTH)
port map(
    DIN   => A,
    SHIFT => 2,
    DOUT  => A_shift_left
);
A_shift <= A_shift_left when A_shift_sel = '0' else A_shift_right;

--regA
RegA : regn
Generic MAP (DATA_WIDTH)
PORT map (RST,CLK,A_ld,A_src,A);

-- so sánh A v?i 0.5 và 2.0
A_lt <= '1' when (signed(A) < to_signed(8192, 16)) else '0';
-- A >= 2.0
A_gt <= '1' when (signed(A) >=to_signed(32767, 16)) else '0';

--scale
Sc_src <= Sc_new  when (Sc_sel = '1') else (others => '0');
--reg Scale
RegSc : regn
Generic MAP (6)
PORT map (RST,CLK,Sc_ld,Sc_src,Sc);
--add/sub scale
Sc_ADD <= std_logic_vector(signed(Sc) + 1);
Sc_SUB <= std_logic_vector(signed(Sc) - 1);
Sc_new <= Sc_SUB when Sc_new_sel = '0' else Sc_ADD;
Sc_lt <= '1' when signed(Sc) < to_signed(0,6) else '0';

--x = a + 0.25, y = a - 0.25
X_a <= std_logic_vector(signed(A) + to_signed(4096, 16));
Y_a <= std_logic_vector(signed(A) - to_signed(4096, 16));
X_src <= X_a when X_sel = '0' else X_new;
Y_src <= Y_a when Y_sel = '0' else Y_new;

--regX
RegX : regn
Generic MAP (DATA_WIDTH)
PORT map (RST,CLK,X_ld,X_src,X);

--regY
RegY : regn
Generic MAP (DATA_WIDTH)
PORT map (RST,CLK,Y_ld,Y_src,Y);

--i
i_src <= "000001" when (i_sel = '0') else i_add;
--reg i
Regi : regn
Generic MAP (6)
PORT map (RST,CLK,i_ld,i_src,i);
--add i
i_add <= std_logic_vector(unsigned(i) + 1);
--comp i_add vs 32
i_comp <= '1' when (unsigned(i) = 32) else '0';

--comp Y vs 0 <0 +, >0 -
Y_comp <= '1' when (signed(Y) < 0 ) else '0';
shift_val_1 <= to_integer(unsigned(i));
shift_val_2 <=  abs(to_integer(signed(Sc)));

--shift X
Shift_right_X: Shift_r
GENERIC MAP(DATA_WIDTH)
port map(
    DIN   => X,
    SHIFT => shift_val_1,
    DOUT  => X_shift
);

--shift Y
Shift_right_Y: Shift_r
GENERIC MAP(DATA_WIDTH)
port map(
    DIN   => Y,
    SHIFT => shift_val_1,
    DOUT  => Y_shift
);

--X_new
ADD_X: ADDER
GENERIC MAP(DATA_WIDTH)
Port map (
        A	=> X,
        B 	=> Y_shift,
        RESULT	=> X_ADD
    );
SUB_X: SUBT
GENERIC MAP(DATA_WIDTH)
Port map (
        A	=> X,
        B 	=> Y_shift,
        RESULT	=> X_SUB
    );
X_new <= X_SUB when Y_Comp = '0' else X_ADD;
--Y_new
ADD_Y: ADDER
GENERIC MAP(DATA_WIDTH)
Port map (
        A	=> Y,
        B 	=> X_shift,
        RESULT	=> Y_ADD
    );
SUB_Y: SUBT
GENERIC MAP(DATA_WIDTH)
Port map (
        A	=> Y,
        B 	=> X_shift,
        RESULT	=> Y_SUB
    );
Y_new <= Y_SUB when Y_Comp= '0' else Y_ADD;

--Multiply with 1/K 1 / 0.828159 in Q8.8 = "0000 0001 0011 0101"
K <=  std_logic_vector(to_signed(19776, 16));
SQRT_MUL: Multiplier
PORT MAP( X, K, Sqrt);

--Shift Sqrt
Shift_right_Sqrt: Shift_r
GENERIC MAP(DATA_WIDTH)
port map(
    DIN   => Sqrt,
    SHIFT => shift_val_2,
    DOUT  => Sqrt_shift_right
);
Shift_left_Sqrt: Shift_l
GENERIC MAP(DATA_WIDTH)
port map(
    DIN   => Sqrt,
    SHIFT => shift_val_2,
    DOUT  => Sqrt_shift_left
);
Sqrt_shift <= Sqrt_shift_left when Sc_lt = '0' else Sqrt_shift_right;


-- MUX 2-to-1 
Sqrt_src <= Sqrt_shift when Sqrt_sel = '1' else "0000000000000000"; 

--reg SQRT
RegSQRT : regn
Generic MAP (DATA_WIDTH)
PORT map (RST, CLK, Sqrt_ld, Sqrt_src, Sqrt_o);

end arc;
