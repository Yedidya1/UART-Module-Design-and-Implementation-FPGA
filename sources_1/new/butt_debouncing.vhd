library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity butt_debouncing is
    port(button_in,clk,rst: in std_logic;
         button_out: out std_logic);
end butt_debouncing;

architecture Behavioral of butt_debouncing is

component d_ff is 
    port(d,clk,rst,enb: in std_logic;
         q: out std_logic);
end component;

component Nbit_counter is
    generic(N: integer := 20);
    port(clk,clr,enb,rst: in std_logic;
         Cout: out std_logic);
end component;

signal q1,q2,Cout,clr,enb_ctr: std_logic;

begin

FF1: d_ff port map(d=>button_in,clk=>clk,rst=>rst,enb=>'1',q=>q1);
FF2: d_ff port map(d=>q1,clk=>clk,rst=>rst,enb=>'1',q=>q2);
FF3: d_ff port map(d=>q2,clk=>clk,rst=>rst,enb=>Cout,q=>button_out);

CTR: Nbit_counter port map(     clk=>clk,
                                clr=>clr,
                                enb=>enb_ctr,
                                rst=>rst,
                                Cout=>Cout      );

clr <= q1 xor q2;
enb_ctr <= not Cout;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_ff is
    port(d,clk,rst,enb: in std_logic;
         q: out std_logic);
end d_ff;

architecture behavioral of d_ff is 
begin 

process(rst,clk) begin
    if rst='1' then 
        q<='0';
    else 
        if rising_edge(clk) then 
            if enb='1' then 
                if d='1' then 
                    q<='1';
                else
                    q<='0';
                end if;
            end if;
        end if;
    end if;
end process;

end behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Nbit_counter is
    generic(N: integer := 10);
    port(clk,clr,enb,rst: in std_logic;
         Cout: out std_logic);
end Nbit_counter;

architecture behavioral of Nbit_counter is

signal count: std_logic_vector(N-1 downto 0);

begin 

process(clk,rst) begin 
    if rst='1' then 
        count<=(others=>'1');
    else
        if rising_edge(clk) then
            if clr='1' then 
                count<=(others=>'0');
            else 
                if enb='1' then
                    count<=std_logic_vector(unsigned(count)+1);
                end if;
            end if;
        end if;
    end if;
end process;

process(count)
variable count_and: std_logic;
begin 
    count_and:='1';
    for i in 0 to N-1 loop
        count_and := count_and and count(i);
    end loop;
    Cout<=count_and;
end process;

end behavioral;