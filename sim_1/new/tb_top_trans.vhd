library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;    -- for uniform & trunc functions
use ieee.numeric_std.all;  -- for to_unsigned function

entity tb_top_trans is
--  Port ( );
end tb_top_trans;

architecture Behavioral of tb_top_trans is

component top_transmitter is
    port(Tx_data: in std_logic_vector(7 downto 0);
         clk100M,send,rst: in std_logic;
         Tx: out std_logic);
end component;

signal Tx_data: std_logic_vector(7 downto 0);
signal send,rst,Tx: std_logic;
signal clk: std_logic := '0';

constant cyc: time := 10ns;

begin

DUT: top_transmitter port map(        Tx_data => Tx_data,
                                      clk100M => clk,
                                         send => send,
                                          rst => rst,
                                           Tx => Tx            );

process begin
    clk <= not clk;
    wait for cyc/2;
end process;

process 
variable seed1, seed2: positive;  				-- seed values for random generator
variable rand: real;              				-- random real-number value in range 0 to 1.0
variable int_rand: integer;       				-- random integer value in range 0..255
variable stim: std_logic_vector(7 downto 0);  	-- random 8-bit stimulus
variable interval: time;
begin
    rst<='1'; Tx_data<=X"AA"; send<='0';
    wait for 2.4*cyc;
    rst<='0';
    for i in 0 to 9 loop
        uniform(seed2, seed1, rand);
        int_rand := integer(trunc(rand*255.0));
        stim := std_logic_vector(to_unsigned(int_rand, stim'length));
        Tx_data<=stim;
        interval := 150us + rand*100us;
        wait for interval;
        send<='1';
        wait for rand*100us;
        send<='0';
        wait for 20ms;
    end loop;
    wait;
end process;


end Behavioral;
