library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seven_seg_decoder is
   port(d_in: in std_logic_vector(3 downto 0);
        d_out: out std_logic_vector(6 downto 0));
end seven_seg_decoder;

architecture Behavioral of seven_seg_decoder is

signal d_out_buff: std_logic_vector(6 downto 0);

begin

process(d_in) begin 
    case d_in is
        when x"0" =>
            d_out_buff<="1111110";
        when x"1" =>
            d_out_buff<="0110000";
        when x"2" =>
            d_out_buff<="1101101";
        when x"3" =>
            d_out_buff<="1111001";
        when x"4" =>
            d_out_buff<="0110011";
        when x"5" =>
            d_out_buff<="1011011";
        when x"6" =>
            d_out_buff<="1011111";
        when x"7" =>
            d_out_buff<="1110000";
        when x"8" =>
            d_out_buff<="1111111";
        when x"9" =>
            d_out_buff<="1111011";
        when x"a" =>
            d_out_buff<="1110111";
        when x"b" =>
            d_out_buff<="0011111";
        when x"c" =>
            d_out_buff<="1001110";
        when x"d" =>
            d_out_buff<="0111101";
        when x"e" =>
            d_out_buff<="1001111";
        when others =>
            d_out_buff<="1000111";
    end case;
end process;

d_out<=not d_out_buff;

end Behavioral;
