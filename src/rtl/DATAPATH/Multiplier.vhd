library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Structural Q2.14 Multiplier 

entity Multiplier is
Port(

    A  : in  STD_LOGIC_VECTOR(15 downto 0);
    B  : in  STD_LOGIC_VECTOR(15 downto 0);
    Y  : out STD_LOGIC_VECTOR(15 downto 0)
);
end Multiplier;

architecture Structural of Multiplier is

    -- internal signals
    signal mult_full : signed(31 downto 0);
    signal y_int     : std_logic_vector(15 downto 0);

begin

    mult_full <= signed(A) * signed(B);

    -- Scaling
    y_int <= std_logic_vector(mult_full(29 downto 14));
    Y <= y_int;
end Structural;