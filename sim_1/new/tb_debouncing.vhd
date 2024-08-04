library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;

entity tb_debouncing is
--  Port ( );
end tb_debouncing;

architecture Behavioral of tb_debouncing is

component butt_debouncing is
    port(button_in,clk,rst: in std_logic;
         button_out: out std_logic);
end component;

signal clk: std_logic := '0';
signal button_in,rst,button_out: std_logic;
constant cyc9600: time := 104.16us;
constant cyc100M: time := 10ns;

begin

DUT: butt_debouncing port map(clk=>clk,button_in=>button_in,rst=>rst,button_out=>button_out);

process begin 
    clk <= not clk;
    wait for cyc100M/2;
end process;

process 
variable seed1, seed2: positive;  -- seed values for random generator
variable rand: real;              -- random real-number value in range 0 to 1.0
variable delay : integer;         -- random integer value in range 0..5
begin 
    rst<='1'; button_in<='0';
    wait for 1.3*cyc9600;
    rst<='0';
    wait for 13.3*cyc9600;
    -- creation of random bouncing pattern
    for i in 0 to 20 loop
        uniform(seed1, seed2, rand);
        delay := integer(trunc(rand*5.0));
        button_in<=not button_in;
        wait for delay*100us;
    end loop;
    wait for 15ms;
    button_in<='0';
    wait for 20ms;
     for i in 0 to 20 loop
        uniform(seed1, seed2, rand);
        delay := integer(trunc(rand*5.0));
        button_in<=not button_in;
        wait for delay*100us;
    end loop;
    wait for 50ms;
    button_in<='0';
    wait;
end process;    
end Behavioral;
