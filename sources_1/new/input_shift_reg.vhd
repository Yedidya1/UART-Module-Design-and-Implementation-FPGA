library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_shift_reg is
    port(rst,clk,enb,d_in: in std_logic;
         d_out: buffer std_logic_vector(7 downto 0));
end input_shift_reg;

architecture Behavioral of input_shift_reg is

begin

process(rst,clk) begin 
    if rst='1' then 
        d_out<=(others=>'0');
    else
        if enb='1' then 
            if rising_edge(clk) then 
                d_out<=d_in&d_out(7 downto 1);
            end if;
        end if;
    end if;
end process;

end Behavioral;
