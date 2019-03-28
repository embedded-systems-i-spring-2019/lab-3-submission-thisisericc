library IEEE;
use IEEE.STD_LOGIC_1164.ALL;		-- WORKS FOR DEMO
use IEEE.NUMERIC_STD.ALL;


entity uart_tx is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           send : in STD_LOGIC;
           rst : in STD_LOGIC;
           char : in STD_LOGIC_VECTOR (7 downto 0);
           ready : out STD_LOGIC;
           tx : out STD_LOGIC);
end uart_tx;

architecture my_uart_tx of uart_tx is

type state is (idle, start, data);
signal PS : state := idle;

signal d : std_logic_vector(7 downto 0) := (others => '0');

signal count: std_logic_vector(3 downto 0) := (others => '0');

begin

process(clk)

begin
    if rising_edge(clk) then
        
        if rst = '1' then
            d <= (others => '0');
            PS <= idle;
        end if;
        
        if en = '1' then
        
            case PS is
                when idle => 
                    ready <= '1';
                    tx <= '1';
                    if send = '1' then
                        d <= char;
                        PS <= start;
                    end if;
                    
                when start => 
                    ready <='0';
                    tx <= '0';

                    count <= (others => '0');
                    PS <= data;
                    
                when data =>
                    if (unsigned(count) < 8) then
                        tx <= d(to_integer(unsigned(count)));
                        count <= std_logic_vector(unsigned(count) +1);
                        PS <= data;
                    else
                        tx <= '1';
                        PS <= idle;
                    end if;
                    
                    
                when others =>
                    ready <= '0';
                    tx <= '1';
                    PS <= idle;
            end case;
            
        end if;
        
    end if;
    
end process;

end my_uart_tx;