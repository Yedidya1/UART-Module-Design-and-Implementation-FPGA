library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port(clk100M,Rx,rst,send: in std_logic;
         switches: in std_logic_vector(7 downto 0);
         Tx,ready,valid: out std_logic;
         recieved_data,sel_disp_dig: out std_logic_vector(7 downto 0);
         seven_seg_disp: out std_logic_vector(6 downto 0));
end top;

architecture Behavioral of top is

component top_reciever is
    port(clk100M,Rx,rst: in std_logic;
         data_buff,sel_disp_dig: out std_logic_vector(7 downto 0);
         seven_seg_disp: out std_logic_vector(6 downto 0);
         valid: out std_logic);
end component;

component top_transmitter is
    port(Tx_data: in std_logic_vector(7 downto 0);
         clk100M,send,rst: in std_logic;
         Tx,ready: out std_logic);
end component;

begin

TOP_REC: top_reciever port map(       clk100M => clk100M,
                                           Rx => Rx,
                                          rst => rst,
                                    data_buff => recieved_data,
                                 sel_disp_dig => sel_disp_dig,
                               seven_seg_disp => seven_seg_disp,
                                        valid => valid          );
                         
TOP_TRANS: top_transmitter port map(  Tx_data => switches,
                                      clk100M => clk100M,
                                         send => send,
                                          rst => rst,
                                           Tx => Tx,
                                        ready => ready       ); 
                                       
end Behavioral;
