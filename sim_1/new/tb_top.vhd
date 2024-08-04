library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;

entity tb_top is
--  Port ( );
end tb_top;

architecture Behavioral of tb_top is

component top is
    port(clk100M,Rx,rst,send: in std_logic;
         switches: in std_logic_vector(7 downto 0);
         Tx,ready,valid: out std_logic;
         recieved_data,sel_disp_dig: out std_logic_vector(7 downto 0);
         seven_seg_disp: out std_logic_vector(6 downto 0));
end component;

signal clk: std_logic := '0';
signal Rx,rst,send,Tx,ready,valid: std_logic;
signal switches,recieved_data,sel_disp_dig: std_logic_vector(7 downto 0);
signal seven_seg_disp: std_logic_vector(6 downto 0);
signal in_test_data: std_logic_vector(9 downto 0);

constant cyc100M: time := 10ns;
constant cycUART: time := 104.166us;

begin

DUT: top port map(  clk100M => clk,
                    Rx => Rx,
                    rst => rst,
                    send => send,
                    switches => switches,
                    Tx => Tx,
                    ready => ready,
                    valid => valid,
                    recieved_data => recieved_data,
                    sel_disp_dig => sel_disp_dig,
                    seven_seg_disp => seven_seg_disp  );
                    
process begin
    clk <= not clk;
    wait for cyc100M/2;
end process;


-- The scenario in the simulation is first sending few packages of random data
-- and then receiving.
process 
variable seed1, seed2: positive;  			-- seed values for random generator
variable rand: real;              			-- random real-number value in range 0 to 1.0
variable delay,int_rand : integer;       	-- random integers value in range 0..n
variable stim: std_logic_vector(7 downto 0);
begin
    switches<=X"62"; Rx<='1'; rst<='1'; send<='0';
    wait for 4.8*cyc100M;
    rst<='0';
    wait for 3*cyc100M;
   
    -- In the loop a random pattern of on and off of the Send input is created
    -- for mimic bouncing of a phisical button
    for i in 0 to 20 loop
        uniform(seed1, seed2, rand);
        delay := integer(trunc(rand*5.0));
        send<=not send;
        wait for delay*100us;
    end loop;
    wait for 20ms;
    send<='0'; switches<=X"aa";
    wait for 30ms;
     for i in 0 to 20 loop
        uniform(seed1, seed2, rand);
        delay := integer(trunc(rand*5.0));
        send<=not send;
        wait for delay*100us;
    end loop;
    wait for 80ms;
    send<='0';
    
    in_test_data <= (others=>'0');
    wait for cyc100M/2;
    rst<='0';
    wait for 2.3*cycUART;
    for j in 0 to 10 loop
        uniform(seed1, seed2, rand);
        int_rand := integer(trunc(rand*255.0));
        stim := std_logic_vector(to_unsigned(int_rand, stim'length));
        in_test_data<='1'&stim&'0';
        wait for 1.2*cycUART;
        for i in 0 to 9 loop
            Rx<=in_test_data(i);
            wait for cycUART;
        end loop;
        wait for int_rand*10us;
    end loop;
    
    wait;
end process;

end Behavioral;
