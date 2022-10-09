library ieee;
use ieee.std_logic_1164.all;

ENTITY digilock IS
	generic(A : std_logic_vector(4 downto 0) := "10000";
		B : std_logic_vector(4 downto 0) := "01000";
		C : std_logic_vector(4 downto 0) := "00100";
		D : std_logic_vector(4 downto 0) := "00010");
 
    	PORT ( 	clk, rst	: IN  BIT;
		x 		: in std_logic_vector(4 downto 0);
            	gled, rled 	: OUT BIT);
END digilock;
--------------------------------------------
ARCHITECTURE behave_digilock OF digilock IS
    TYPE state IS (standby, one, two, three, four, done, dtwo, dthree, dfour);
    SIGNAL pr_state, nx_state: state;
BEGIN
    ----- Lower section: --------------------
    PROCESS (rst,clk)
    BEGIN
        IF    (rst='1') THEN
                pr_state <= standby;
        ELSIF (clk'EVENT AND clk='1') THEN
                pr_state <= nx_state;
        END IF;
    END PROCESS;
    ---------- Upper section: ---------------
    PROCESS (x)
    BEGIN
        CASE pr_state IS
            WHEN standby =>
                IF   (x="00000") THEN nx_state <= standby;
                ELSIF (x=A) THEN nx_state <= one;
		ELSE nx_state <= done;
                END IF;
            WHEN one =>
               	IF   (x="00000") THEN nx_state <= one;
                ELSIF (x=B) THEN nx_state <= two;
		ELSE nx_state <= dtwo;
                END IF;
            WHEN two =>
                IF   (x="00000") THEN nx_state <= two;
                ELSIF (x=C) THEN nx_state <= three;
		ELSE nx_state <= dthree;
                END IF;
            WHEN three =>
                IF   (x="00000") THEN nx_state <= three;
                ELSIF (x=D) THEN nx_state <= four;
		ELSE nx_state <= dthree;
                END IF;
	    WHEN four =>
                nx_state <= standby after 5 ns;
		


            WHEN done =>
                IF   (x="00000") THEN nx_state <= done;
		ELSE nx_state <= dtwo;
                END IF;
            WHEN dtwo =>
               	IF   (x="00000") THEN nx_state <= dtwo;
		ELSE nx_state <= dthree;
                END IF;
            WHEN dthree =>
                IF   (x="00000") THEN nx_state <= dthree;
		ELSE nx_state <= dfour;
                END IF;
            WHEN dfour =>
		nx_state <= standby after 5 ns;

        END CASE;
    END PROCESS;

    PROCESS (pr_state)
    BEGIN
       CASE pr_state IS
            WHEN four =>
                gled <= '1'; rled <= '0';
            WHEN dfour =>
                gled <= '0'; rled <= '1';
	    WHEN others =>
		gled <= '0'; rled <= '0';
	END CASE;
    END PROCESS;

END behave_digilock;
