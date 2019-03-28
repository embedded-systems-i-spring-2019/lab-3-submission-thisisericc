library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity debounce is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           dbnc : out STD_LOGIC);
end debounce;

architecture arch_debounce of debounce is
    signal reg2: std_logic_vector(0 to 1):= (others => '0');
    signal counter: std_logic_vector(21 downto 0):= (others => '0');

begin

    
    process (clk) begin
            if rising_edge(clk) then
            
                reg2(1) <= reg2(0);
                reg2(0) <= btn;
            
                if counter = std_logic_vector(to_unsigned(2500000,22)) then
                        dbnc <= '1';
                end if;
                
                
                if reg2(1) = '1' and counter /= std_logic_vector(to_unsigned(2500000,22)) then
                      counter <= std_logic_vector(unsigned(counter) + 1 );
                      dbnc <= '0';
                elsif reg2(1) /= '1' then
                      counter <= std_logic_vector(to_unsigned(0,22));
                      dbnc <= '0';
                end if;

            end if;
    end process;       

end arch_debounce;
