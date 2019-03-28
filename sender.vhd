library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sender is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rdy : in STD_LOGIC;
           rst : in STD_LOGIC;
           send : out STD_LOGIC;
           char : out STD_LOGIC_VECTOR (7 downto 0));
end sender;

architecture my_sender of sender is

type ID_Array is array (0 to 5) of std_logic_vector(7 downto 0);
signal NetIDArray : ID_Array := (        
         x"65",
         x"6A",
         x"72",
         x"31",
         x"33",
         x"30");

signal i : std_logic_vector(2 downto 0) := (others => '0');

type state is (idle, busyA, busyB, busyC);
    signal PS: state := idle;

begin

process(clk) begin
    if rising_edge(clk) then
        if en = '1' then

        -- resets the state machine and its outputs
        if rst = '1' then
                PS <= idle;
                send <= '0';
                char <= (others => '0');
                i <= (others => '0');
         -- end if;
          
        -- usual operation
       else
            case PS is

                when idle =>
                    if rdy = '1' then
                        if btn = '1' then
                            if (unsigned(i) < 6) then
                                send <= '1';
                                char <= NetIDArray(to_integer(unsigned(i)));
                                i <= std_logic_vector(unsigned(i) + 1);
                                PS <= busyA;
                            else
                                i <= "000";
                                PS <= idle;
                            end if;
                        end if;
                    end if;
                    
                when busyA =>
                     PS <= busyB;

                when busyB =>
                
                     send <= '0';
                     PS <= busyC;    

                when busyC =>
                    if rdy = '1' and btn = '0' then
                            PS <= idle;
                    end if;
                       
               when others =>
                    PS <= idle;
                    
            end case;
            
           end if;
        end if;
    end if;
    
end process;

end my_sender;