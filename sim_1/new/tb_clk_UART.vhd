library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clk_UART is
--  Port ( );
end tb_clk_UART;

architecture Behavioral of tb_clk_UART is

component clk_UART1 is
    --generic(baud_rate: integer := 9600);
    Port(clk100M,start,rst: in std_logic;
         clk_UART: out std_logic);
end component;

signal clk100M: std_logic := '0';
signal start,clk_UART: std_logic;
signal rst: std_logic := '1';
constant cyc100M: time := 10ns;
constant cyc9600: time := 104166ns;

begin

DUT: clk_UART1 port map(clk100M=>clk100M,start=>start,clk_UART=>clk_UART,rst=>rst);

process begin
    clk100M<=not clk100M;
    wait for cyc100M/2;
end process;

process begin
    start<='0';
    wait for cyc100M; 
    rst<='0';
    wait for 11*cyc9600/2;
    start<='1';
    wait for cyc100M;
    start<='0';
    wait;
end process;

end Behavioral;
