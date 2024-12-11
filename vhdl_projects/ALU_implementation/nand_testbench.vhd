library ieee;
use ieee.std_logic_1164.all;

entity nand_tb is
end nand_tb;

architecture behave_nand_tb of nand_tb is 
    signal a,b,c,d,x,y : std_logic;

    component top_level is 
        port(
            a,b,c,d: in std_logic;
            x,y: out std_logic);
    end component;

begin

    DUT: top_level port map(a,b,c,d,x,y);   -- component_port => signals

    process
    begin
        a <= '0' ; b <= '0'; c <= '0'; d <= '0';
        wait for 10 ns;

        a <= '0' ; b <= '0'; c <= '0'; d <= '1';
        wait for 10 ns;

        a <= '0' ; b <= '0'; c <= '1'; d <= '0';
        wait for 10 ns;

        a <= '0' ; b <= '0'; c <= '1'; d <= '1';
        wait for 10 ns;

        a <= '0' ; b <= '1'; c <= '0'; d <= '0';
        wait for 10 ns;

        a <= '0' ; b <= '1'; c <= '0'; d <= '1';
        wait for 10 ns;

        a <= '0' ; b <= '1'; c <= '1'; d <= '0';
        wait for 10 ns;

        a <= '0' ; b <= '1'; c <= '1'; d <= '1';
        wait for 10 ns;



        a <= '1' ; b <= '0'; c <= '0'; d <= '0';
        wait for 10 ns;

        a <= '1' ; b <= '0'; c <= '0'; d <= '1';
        wait for 10 ns;

        a <= '1' ; b <= '0'; c <= '1'; d <= '0';
        wait for 10 ns;

        a <= '1' ; b <= '0'; c <= '1'; d <= '1';
        wait for 10 ns;

        a <= '1' ; b <= '1'; c <= '0'; d <= '0';
        wait for 10 ns;

        a <= '1' ; b <= '1'; c <= '0'; d <= '1';
        wait for 10 ns;

        a <= '1' ; b <= '1'; c <= '1'; d <= '0';
        wait for 10 ns;

        a <= '1' ; b <= '1'; c <= '1'; d <= '1';
        wait for 10 ns;

        wait;
        end process;
    end behave_nand_tb;