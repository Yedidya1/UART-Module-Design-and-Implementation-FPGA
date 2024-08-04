library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_7seg is
    port(clk100M,rst: in std_logic;
         clk200Hz: out std_logic);
end clk_7seg;

-- this block generates 200Hz clock signal for the 7 segment display 
architecture Behavioral of clk_7seg is

signal count: integer range 0 to 250000:= 0;
signal clk_OBUF: std_logic := '0';

begin

process(clk100M,rst) begin
    if rst='1' then 
        count<=0;
    else
        if rising_edge(clk100M) then 
            if count=250000 then
                count<=0;
            else
                count<=count+1;
            end if;
        end if;
    end if;
end process;

process(clk100M,rst) begin 
    if rst='1' then 
        clk_OBUF<='0';
    else
        if rising_edge(clk100M) then   
            if count=0 then 
                clk_OBUF<=not clk_OBUF;
            end if;
        end if;
    end if;
end process;
    
clk200Hz<=clk_OBUF;
    
end Behavioral;
