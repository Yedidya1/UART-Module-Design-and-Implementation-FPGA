library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PISO_reg is
    port(d_in: in std_logic_vector(7 downto 0);
         counter: in std_logic_vector(3 downto 0);
         clk,rst,enb: in std_logic;
         serial_out: out std_logic);
end PISO_reg;

architecture Behavioral of PISO_reg is

signal out_reg: std_logic_vector(7 downto 0);

begin 

process(clk,rst) begin
    if rst='1' then
        out_reg<=(others=>'0');
    else
        if enb='0' then -- for avoiding input change while sending data
            if rising_edge(clk) then 
                out_reg<=d_in;
            end if;
        end if;
    end if;
end process;

process(counter) begin
    if enb='1' then 
        case counter is
            when X"1" =>
                serial_out<='0';
            when X"2" =>
                serial_out<=out_reg(0);
            when X"3" =>
                serial_out<=out_reg(1);
            when X"4" =>
                serial_out<=out_reg(2);
            when X"5" =>
                serial_out<=out_reg(3);
            when X"6" =>
                serial_out<=out_reg(4);
            when X"7" =>
                serial_out<=out_reg(5);
            when X"8" =>
                serial_out<=out_reg(6);
            when X"9" =>
                serial_out<=out_reg(7);
            when others =>
                serial_out<='1';
            end case;
        end if;    
end process;

end Behavioral;
