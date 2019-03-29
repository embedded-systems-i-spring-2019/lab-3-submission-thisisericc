library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity echo is
    Port ( clk : in STD_LOGIC;
           rdy : in STD_LOGIC;
           en : in STD_LOGIC;
           newChar : in STD_LOGIC;
           charIn : in STD_LOGIC_VECTOR (7 downto 0);
           charOut : out STD_LOGIC_VECTOR (7 downto 0);
           send : out STD_LOGIC);
end echo;

architecture Behavioral of echo is

type state is (idle, busyA, busyB, busyC);
    signal PS: state := idle;

begin

process(clk) begin
    if rising_edge(clk) then
        if en = '1' then
       
            case PS is

                when idle =>
                   
                        if newChar = '1' then
                            send <= '1';
                            charout <= charin;
                            PS <= busyA;
                        end if;
                    
                when busyA =>
                     PS <= busyB;

                when busyB =>
                
                     send <= '0';
                     PS <= busyC;    

                when busyC =>
                    if rdy = '1' then
                            PS <= idle;
                    end if;
                       
               when others =>
                    PS <= idle;
                    
            end case;
            

        end if;
    end if;
    
end process;


end Behavioral;
