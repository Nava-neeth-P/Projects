library ieee;
use ieee.std_logic_1164.all;

entity top_level is
    port(
        a,b,c,d: in std_logic;
        x,y: out std_logic);
end top_level;

architecture behave_top_level of top_level is
    signal b_not: std_logic;

    component nand_gate_2
    port(
        a,b: in std_logic;
        x: out std_logic);
    end component;

    component nand_gate_3
    port(
        b3,c,d: in std_logic;
        y: out std_logic);
    end component;

    component not_gate 
    port(
        b1: in std_logic;
        b2: out std_logic);
    end component;

    begin
        module1: nand_gate_2 port map(a,b,x);
        module2: not_gate port map(b1 => b, b2 => b_not);
        module3: nand_gate_3 port map(b3 => b_not, c => c, d => d, y => y);

end behave_top_level;