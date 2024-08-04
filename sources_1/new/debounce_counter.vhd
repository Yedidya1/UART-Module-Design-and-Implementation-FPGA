library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity debounce_counter is
    port(clk,rst,trig,enb: in std_logic;
         count: out std_logic_vector(9 downto 0));
end debounce_counter;

-- the counter statrts at 960 and counts down until 0 and holds 0 until another trigger
architecture Behavioral of debounce_counter is

signal D1,D0,Q1,Q0,preset_enb: std_logic;
signal ctr: std_logic_vector(9 downto 0);
constant preset_val: std_logic_vector(9 downto 0) := "1111000000"; -- 960 decimal 

begin

D0 <= trig or Q0;

process(clk,rst) begin 
    if rst='1' then 
        Q0<='0';
    else
        if rising_edge(clk) then 
            if D0='0' then 
                Q0<='0';
            else 
                Q0<='1';
            end if;
        end if;
    end if;
end process;

D1 <= Q0;

process(clk,rst) begin
    if rst='1' then 
        Q1<='0';
    else 
        if rising_edge(clk) then 
            if D1='1' then 
                Q1<='1';
            else 
                Q1<='0';
            end if;
        end if; 
    end if;
end process;

preset_enb <= D1 and (not Q1);

process(preset_enb,clk,rst) begin 
    if rst='1' then 
        ctr<=(others=>'0');
    elsif preset_enb='1' then 
        ctr<=preset_val;
    else
        if rising_edge(clk) then 
            if enb='1' then 
                ctr<=std_logic_vector(unsigned(ctr)-1);
            end if;
        end if;
    end if;
end process;
  
count <= ctr;

end Behavioral;
