library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;    -- for uniform & trunc functions
use ieee.numeric_std.all;  -- for to_unsigned function
--use std.textio.all;

entity tb_top_reciever is
--  Port ( );
end tb_top_reciever;

architecture Behavioral of tb_top_reciever is

component top_reciever is
     port(clk100M,Rx,rst: in std_logic;
         data_buff,sel_disp_dig: out std_logic_vector(7 downto 0);
         seven_seg_disp: out std_logic_vector(6 downto 0);
         valid: out std_logic);
end component;

signal clk100M: std_logic := '0';
signal Rx,rst,Tx: std_logic := '1';
signal seven_seg_disp: std_logic_vector(6 downto 0);
signal sel_disp_dig,data_buff: std_logic_vector(7 downto 0);
signal test_data: std_logic_vector(9 downto 0);
signal valid: std_logic;

constant cyc100M: time := 10ns;
constant cycUART: time := 104.166us;

begin

DUT: top_reciever port map(clk100M=>clk100M,Rx=>Rx,rst=>rst,seven_seg_disp=>seven_seg_disp,sel_disp_dig=>sel_disp_dig,data_buff=>data_buff,valid=>valid);

process begin
    clk100M<=not clk100M;
    wait for cyc100M/2;
end process;

process 
variable seed1, seed2: positive;  -- seed values for random generator
variable rand: real;              -- random real-number value in range 0 to 1.0
variable int_rand: integer;       -- random integer value in range 0..4095
variable stim: std_logic_vector(7 downto 0);  -- random 12-bit stimulus
begin
    test_data <= (others=>'0');
    wait for cyc100M/2;
    rst<='0';
    wait for 2.3*cycUART;
    for j in 0 to 10 loop
        uniform(seed1, seed2, rand);
        int_rand := integer(trunc(rand*255.0));
        stim := std_logic_vector(to_unsigned(int_rand, stim'length));
        test_data<='1'&stim&'0';
        wait for 1.2*cycUART;
        for i in 0 to 9 loop
            Rx<=test_data(i);
            wait for cycUART;
        end loop;
        wait for int_rand*10us;
    end loop;
    wait;
end process;
    

end Behavioral;
