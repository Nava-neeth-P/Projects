library ieee;
use ieee.std_logic_1164.all;

entity digilock_tb is
	generic(A : std_logic_vector(4 downto 0) := "10000";
		B : std_logic_vector(4 downto 0) := "01000";
		C : std_logic_vector(4 downto 0) := "00100";
		D : std_logic_vector(4 downto 0) := "00010");
end digilock_tb;

architecture behave_digilock_tb of digilock_tb is
signal clk,rst: bit;
signal x : std_logic_vector(4 downto 0);
signal gled, rled :  BIT;

component digilock
    	PORT ( 	clk, rst	: IN  BIT;
		x 		: in std_logic_vector(4 downto 0);
            	gled, rled 	: OUT BIT);
END component;

begin
	clk <= not clk after 2 ns;
	DUT: digilock port map(clk,rst,x,gled,rled);

	process
	begin
		rst <= '0';

		x <= "10000"; wait for 10 ns;
		x <= "01000"; wait for 10 ns;
		x <= "00100"; wait for 10 ns;
		x <= "00010"; wait for 10 ns;

		x <= "10000"; wait for 10 ns;
		x <= "00100"; wait for 10 ns;
		x <= "01110"; wait for 10 ns;
		x <= "00010"; wait for 10 ns;
		 
		x <= "10000"; wait for 10 ns;
		x <= "01000"; wait for 10 ns;
		rst <= '1'; wait for 5 ns;
		rst <= '0'; wait for 5 ns;

		x <= "10000"; wait for 10 ns;
		x <= "01000"; wait for 10 ns;
		x <= "00100"; wait for 10 ns;
		x <= "00010"; wait for 10 ns;
		
	wait;
	end process;
end behave_digilock_tb;