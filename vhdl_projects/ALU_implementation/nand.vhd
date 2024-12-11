library ieee;
use ieee.std_logic_1164.all;

entity nand_gate_2 is
    port(
        a,b: in std_logic;
        x: out std_logic);
end nand_gate_2;

architecture behave_nand_2 of nand_gate_2 is 
    begin 
        x <= a nand b;
end behave_nand_2;


library ieee;
use ieee.std_logic_1164.all;

entity not_gate is
    port(
        b1: in std_logic;
        b2: out std_logic);
end not_gate;

architecture behave_not of not_gate is 
    begin 
        b2 <= not b1;
end behave_not;



library ieee;
use ieee.std_logic_1164.all;

entity nand_gate_3 is
    port(
        b3,c,d: in std_logic;
        y: out std_logic);
end nand_gate_3;

architecture behave_nand_3 of nand_gate_3 is 
    begin 
        y <= not (b3 and c and d);
end behave_nand_3;

        
