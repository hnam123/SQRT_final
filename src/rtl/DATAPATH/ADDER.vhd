library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADDER is
GENERIC (DATA_WIDTH : integer := 16);
    Port (
        A      : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        B      : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        RESULT : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end ADDER;

architecture Behavioral of ADDER is

    signal a_s, b_s : signed(DATA_WIDTH - 1 downto 0);
    signal res_s    : signed(DATA_WIDTH - 1 downto 0);

begin

    a_s <= signed(A);
    b_s <= signed(B);
    res_s <= a_s + b_s;
    RESULT <= std_logic_vector(res_s);

end Behavioral;