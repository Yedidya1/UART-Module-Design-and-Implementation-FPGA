library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_transmitter is
    port(Tx_data: in std_logic_vector(7 downto 0);
         clk100M,send,rst: in std_logic;
         Tx,ready: out std_logic);
end top_transmitter;

architecture Behavioral of top_transmitter is

component state_machine_trans is
    port(send,clk,rst,rst_state: in std_logic;
         state: buffer std_logic);
end component;

component counter_trans is
    port(clk,enb: in std_logic;
         count: buffer std_logic_vector(3 downto 0));
end component;

component clk_UART_trans is
    generic(baud_rate: integer := 9600);
    Port(clk100M,rst: in std_logic;
         clk_UART: out std_logic);
end component;

component PISO_reg is
    port(d_in: in std_logic_vector(7 downto 0);
         counter: in std_logic_vector(3 downto 0);
         clk,rst,enb: in std_logic;
         serial_out: out std_logic);
end component;

component butt_debouncing is
    port(button_in,clk,rst: in std_logic;
         button_out: out std_logic);
end component;

signal state,clk_UART,end_count,stable_send,valid_send,ready_buff: std_logic;
signal count: std_logic_vector(3 downto 0);

begin

SM: state_machine_trans port map(send=>stable_send,clk=>clk100M,rst=>rst,rst_state=>end_count,state=>state);

CTR: counter_trans port map(clk=>clk_UART,enb=>state,count=>count);

UART_CLK: clk_UART_trans generic map(baud_rate=>9600)
                         port map(clk100M=>clk100M,rst=>rst,clk_UART=>clk_UART);

OUTREG: PISO_reg port map(d_in=>Tx_data,counter=>count,clk=>clk_UART,rst=>rst,enb=>state,serial_out=>Tx);

DEBOUNCE: butt_debouncing port map(clk=>clk100M,button_in=>valid_send,rst=>rst,button_out=>stable_send);

end_count <= '1' when count=X"B" else '0';
ready <= not state;
valid_send <= (not state) and send; -- valid_send <= ready & send

end Behavioral;
