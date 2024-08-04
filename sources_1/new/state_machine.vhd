-- This file contain two state machine designs, one of the receiver and the second of the transmitter

-- Receiver state machine:
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity state_machine_rec is
    port(Rx,clk,rst: in std_logic;
         count: in std_logic_vector(3 downto 0);
         state: buffer std_logic);
end state_machine_rec;

architecture Behavioral of state_machine_rec is

begin

process(clk,rst) begin
    if rst='1' then
        state<='0';
    else
        if rising_edge(clk) then
            if state='0' then 
                if Rx='0' then
                    state<='1';
                end if;
            else 
                if count=X"A" then 
                    state<='0';
                end if;
            end if; 
        end if;
    end if;   
end process;

end Behavioral;


-- transmitter state machine: 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity state_machine_trans is
    port(send,clk,rst,rst_state: in std_logic;
         state: buffer std_logic);
end state_machine_trans;

architecture Behavioral of state_machine_trans is

signal t,Q: std_logic := '0';

begin

-- edge detector
process(clk,rst) begin 
    if rst='1' then     
        Q<='0';
    else
        if rising_edge(clk) then 
            if send='0' then 
                Q<='0';
            else 
                Q<='1';
            end if;
        end if;
    end if;
end process;

T<=send and not Q;

 -- one flop state machine
process(clk,rst_state,rst) begin 
    if rst='1' or rst_state='1' then 
        state<='0';
    else 
        if rising_edge(clk) then
            if T='1' then 
                state<=not state;
            end if;
        end if;
    end if;
end process;


end behavioral;
