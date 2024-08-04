library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clk_UART_trans is
--  Port ( );
end tb_clk_UART_trans;

architecture Behavioral of tb_clk_UART_trans is

component clk_UART_trans is
    generic(baud_rate: integer := 9600);
    Port(clk100M,rst: in std_logic;
         clk_UART: out std_logic);
end component;

signal clk: std_logic := '0';
signal rst: std_logic := '1';
constant cyc: time := 10ns;
signal clk_UART: std_logic;

begin

DUT: clk_UART_trans port map(clk100M=>clk,rst=>rst,clk_UART=>clk_UART);

process begin 
    clk <= not clk;
    wait for cyc/2;
end process;

process begin 
    wait for 1.3*cyc;
    rst <= '0';
    wait;
end process;

end Behavioral;
