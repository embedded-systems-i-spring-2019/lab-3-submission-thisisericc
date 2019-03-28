library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	-- WORKS FOR SIMULATION
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           send : in STD_LOGIC;
           rst : in STD_LOGIC;
        --   Y: out std_logic_vector(1 downto 0);
           char : in STD_LOGIC_VECTOR (7 downto 0);
           ready : out STD_LOGIC;
           tx : out STD_LOGIC);
end uart_tx;

architecture my_uart_tx of uart_tx is

    -- state type enumeration and state variable
    type state is (idle, start, data);
    signal PS, NS: state := idle;
    

    --  register to send data out
    signal d : std_logic_vector (7 downto 0) := (others => '0');

    -- counter for data state
    signal count : std_logic_vector(3 downto 0) := (others => '0');
    
    

begin

sync_process: process (clk, NS) begin
                  if rising_edge(clk) then
                        if rst = '1' then PS <= idle; 
                        elsif en = '1' then PS <= NS;
                        end if;
                  end if;
              end process sync_process;
              
comb_process: process (PS,en,send,rst) begin
                      
                       if rst = '1' then tx <= '1'; d <= (others => '0');
                       
                       elsif en = '1' then                                                   
                                case PS is
                                    when idle =>
                                        ready <= '1';
                                        tx <= '1';
                                        if send = '1' then NS <= start; d <= char;
                                        else NS <= idle;
                                        end if;
                                        
                                    when start =>
                                        ready <= '0';
                                        tx <= '0';
                                        count <= (others => '0');
                                        NS <= data; 
                                        
                                    when data =>
                                        if (unsigned(count) < 8) then
                                            tx <= d(to_integer(unsigned(count)));
                                            count <= std_logic_vector(unsigned(count)+1) ;
                                            NS <= data;
                                        else
                                            tx <= '1';
                                            NS <= idle;
                                        end if;
                                        
                                    when others =>  
                                        ready <= '0';
                                        tx <= '1';
                                        NS <= idle;
                                  end case;
                          end if;     
end process comb_process;
    
--with PS select
  --        Y <= "00" when idle,
    --           "01" when start,
      --         "10" when data,
        --       "11" when others;
end my_uart_tx;