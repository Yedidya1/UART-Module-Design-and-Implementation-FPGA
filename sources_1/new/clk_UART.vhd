library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Reciever UART clock
entity clk_UART_rec is
    generic(baud_rate: integer := 9600);
    Port(clk100M,start,rst: in std_logic;
         clk_UART: out std_logic;
         s: buffer std_logic);
end clk_UART_rec;

-- generates clk signal with frequency of 9600 Hz
architecture Behavioral of clk_UART_rec is

constant limit: integer range 0 to 5207 := 5207;
signal count: integer range 0 to limit := 0;
-- clk flips at count=5206

signal Q,tmp: std_logic := '0';
signal D: std_logic;

begin

D<=start;

process(clk100M) begin
    if rising_edge(clk100M) then 
        if D='0' then 
            Q<='0';
        else 
            Q<='1';
        end if;
    end if;
end process;

s<=start and (not Q); -- edge detector for start

process(clk100M,start,rst) begin
    if s='1' or rst ='1' then 
        count<=0;
    elsif rising_edge(clk100M) then
        if count = limit then
            count<=0;
        else 
            count<=count+1;
        end if;
    end if;
end process;

process(clk100M,start) begin
    if s='1' or rst='1' then
        tmp<='0';
    elsif rising_edge(clk100M) then
        if count = limit then 
            tmp<=not tmp;
        end if;
    end if;
end process;

clk_UART<=tmp;    

end Behavioral;


-- Transmitter UART clock
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_UART_trans is
    generic(baud_rate: integer := 9600);
    Port(clk100M,rst: in std_logic;
         clk_UART: out std_logic);
end clk_UART_trans;

architecture Behavioral of clk_UART_trans is

constant limit: integer range 0 to 5207 := 5207;
signal count: integer range 0 to limit := 0;
signal tmp: std_logic;

begin

process(clk100M,rst) begin
    if rst='1' then 
        count<=0;
    else 
        if rising_edge(clk100M) then 
            if count = limit then 
                count <= 0;
            else 
                count <= count + 1;
            end if;
        end if;
    end if;
end process;  

process(clk100M,rst) begin 
    if rst ='1' then 
        tmp<='0';
    else
        if rising_edge(clk100M) then 
            if count=limit then 
                tmp<=not tmp;
            end if;
        end if;
    end if;
end process;

clk_UART<=tmp;
    
end behavioral;


