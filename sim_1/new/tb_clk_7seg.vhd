library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clk_7seg is
--  Port ( );
end tb_clk_7seg;

architecture Behavioral of tb_clk_7seg is

component clk_7seg is
    port(clk100M,rst: in std_logic;
         clk200Hz: out std_logic);
end component;

signal clk100M: std_logic := '0';
signal rst,clk200Hz: std_logic;
constant cyc: time := 10ns;

begin

DUT: clk_7seg port map(clk100M=>clk100M,rst=>rst,clk200Hz=>clk200Hz);

process begin 
    clk100M<=not clk100M;
    wait for cyc/2;
end process;

process begin
    rst<='1';
    wait for cyc/2;
    rst<='0';
    wait;
end process;

end Behavioral;
