library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity anode_control is
    port(clk,rst: in std_logic;
         anode: out std_logic_vector(1 downto 0));
end anode_control;

architecture Behavioral of anode_control is

signal s: std_logic_vector(1 downto 0) := "01";

begin

process(clk,rst) begin
    if rst='1' then
        s<="01";
    else
        if rising_edge(clk) then 
            s<=s(0)&s(1);
        end if;
    end if;
end process;

anode<=s;

end Behavioral;
