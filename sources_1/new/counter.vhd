-- The file contains two designs of counter, the first is the receiver counter 
-- and the second is the transmitter counter. the designs are a little bit different 
-- from each other according to the unit needs.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- counter for reciever
entity counter_rec is
    port(clk,rst: in std_logic;
         count: buffer std_logic_vector(3 downto 0));
end counter_rec;

architecture Behavioral of counter_rec is

signal not_clk: std_logic;

begin

not_clk <= not clk;

process(not_clk,rst) begin 
    if rst='1' then
        count<=X"0";
    elsif rising_edge(not_clk) then 
        if count = X"A" then
            count<=X"0";
        else  
            count<=std_logic_vector(unsigned(count)+1);
        end if;
    end if; 
end process;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- counter for transmitter
entity counter_trans is
    port(clk,enb: in std_logic;
         count: buffer std_logic_vector(3 downto 0));
end counter_trans;

architecture Behavioral of counter_trans is

begin 

process(clk,enb) begin
    if enb='0' then 
        count<=X"0";
    else 
        if rising_edge(clk) then
            count <= std_logic_vector(unsigned(count)+1);
        end if;
    end if;
end process; 

end behavioral;
