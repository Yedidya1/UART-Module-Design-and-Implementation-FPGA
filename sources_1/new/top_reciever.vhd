library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity top_reciever is
    port(clk100M,Rx,rst: in std_logic;
         data_buff,sel_disp_dig: out std_logic_vector(7 downto 0);
         seven_seg_disp: out std_logic_vector(6 downto 0);
         valid: out std_logic);
end top_reciever;

architecture Behavioral of top_reciever is

component clk_UART_rec is
    generic(baud_rate: integer := 9600);
    Port(clk100M,start,rst: in std_logic;
         clk_UART: out std_logic;
         s: buffer std_logic);
end component;

component counter_rec is
    port(clk,rst: in std_logic;
         count: buffer std_logic_vector(3 downto 0));
end component;

component state_machine_rec is
    port(Rx,clk,rst: in std_logic;
         count: in std_logic_vector(3 downto 0);
         state: buffer std_logic);
end component;

component input_shift_reg is
    port(rst,clk,enb,d_in: in std_logic;
         d_out: buffer std_logic_vector(7 downto 0));
end component;

component seven_seg_decoder is
   port(d_in: in std_logic_vector(3 downto 0);
        d_out: out std_logic_vector(6 downto 0));
end component;

component anode_control is
    port(clk,rst: in std_logic;
         anode: out std_logic_vector(1 downto 0));
end component;

component clk_7seg is
    port(clk100M,rst: in std_logic;
         clk200Hz: out std_logic);
end component;

signal state,clk_UART,clk200Hz,reset_count: std_logic;
signal count: std_logic_vector(3 downto 0);
signal enb_input,enabled_UART_clk,s,sync_state : std_logic;
signal parallel_data,data_buffer: std_logic_vector(7 downto 0);
signal anode: std_logic_vector(1 downto 0);
signal mux_out: std_logic_vector(3 downto 0);


begin

UARTclk: clk_UART_rec generic map(baud_rate=>9600)
					  port map(	clk100M => clk100M,
								  start => state,
								    rst => rst,
							   clk_UART => clk_UART,
									  s => s 				);
                   
CTR: 	  counter_rec port map(		clk => enabled_UART_clk,
									rst => reset_count,
								  count => count			);

SM: state_machine_rec port map(		 Rx => Rx,
									rst => rst,
								  count => count,
								  state => sync_state,
								    clk => clk100M			);

SH_R: input_shift_reg port map(		rst => rst,
									clk => clk_UART,
									enb => enb_input,
								   d_in => Rx,
								  d_out => parallel_data	);

seg7_clk: 	 clk_7seg port map( clk100M => clk100M,
									rst => rst,
							   clk200Hz => clk200Hz);

state<=sync_state or s;

reset_count<=rst or (not state);

enb_input<='1' when (state='1' and unsigned(count)>0 and unsigned(count)<9) else '0'; 

enabled_UART_clk<=clk_UART and state and (not s);

process(state,rst) begin
    if rst='1' then
        data_buffer<=x"00";
    else
        if state='0' then 
            data_buffer<=parallel_data;
        end if;
    end if;        
end process;

process(anode) begin
    case anode(0) is
        when '0' =>
            mux_out<=data_buffer(3 downto 0);
        when others =>
            mux_out<=data_buffer(7 downto 4);
    end case;
end process;

--display modules
sev_seg_dec:   seven_seg_decoder port map(	d_in => mux_out,
										   d_out => seven_seg_disp	);

anode_control_sig: anode_control port map(   clk => clk200Hz,
											 rst => rst,
										   anode => anode			);

sel_disp_dig(1 downto 0)<=anode;
sel_disp_dig(7 downto 2)<="111111";
data_buff<=data_buffer;
valid<=not state;

end Behavioral;
