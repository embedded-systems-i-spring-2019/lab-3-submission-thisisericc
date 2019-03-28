library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity clock_div is
    Port ( clk : in STD_LOGIC;
           div : out STD_LOGIC);
end clock_div;

architecture arch_clock_div of clock_div is
    signal counter: std_logic_vector(25 downto 0) := (others => '0');

begin
  
process ( clk ) begin
    if rising_edge ( clk ) then
        if ( unsigned(counter) = 1084) then
            counter <= ( others => '0');
            div <= '1';
        else
            counter <= std_logic_vector ( unsigned ( counter ) + 1) ;
            div <= '0';
        end if;
    end if;
end process ;
  
end arch_clock_div;




