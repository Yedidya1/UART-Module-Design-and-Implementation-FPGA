library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncing is
    port(clk,button_in,rst: in std_logic;
         button_out: out std_logic);
end debouncing;

architecture Behavioral of debouncing is

component debounce_counter is
    port(clk,rst,trig,enb: in std_logic;
         count: out std_logic_vector(9 downto 0));
end component;

signal enb,or_count,rst_counter,buff_butt_out: std_logic;
signal count: std_logic_vector(9 downto 0);

begin

CTR: debounce_counter port map(clk=>clk,trig=>button_in,rst=>rst_counter,enb=>enb,count=>count);

rst_counter <= rst or (not buff_butt_out);

-- or operation between the bits of count
process(count)
variable res: std_logic;
begin 
    res := '0';
    for i in 0 to 9 loop
        res := res or count(i);
    end loop;
    or_count<=res;
end process;

enb <= or_count;
buff_butt_out <= button_in or or_count; 
button_out<=buff_butt_out;

end Behavioral;
