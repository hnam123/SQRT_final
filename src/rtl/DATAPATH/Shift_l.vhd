library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Shift_l is
GENERIC (DATA_WIDTH : integer := 16);
    Port (
        DIN    : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        SHIFT  : in  INTEGER range 0 to 2*DATA_WIDTH;
        DOUT   : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end Shift_l;

architecture Behavioral of Shift_l is

    signal din_s  : signed(DATA_WIDTH - 1 downto 0);
    signal dout_s : signed(DATA_WIDTH - 1 downto 0);

begin
    din_s <= signed(DIN);
    dout_s <= shift_left(din_s, SHIFT);
    DOUT <= std_logic_vector(dout_s);
end Behavioral;
