library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity TopLevelEcho is
    Port ( TXD : in STD_LOGIC;
           clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (1 downto 0);
           RXD : out STD_LOGIC;
           RTS : out STD_LOGIC;
           CTS : out STD_LOGIC);
end TopLevelEcho;

architecture Structural of TopLevelEcho is

component debounce
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           dbnc : out STD_LOGIC);
end component;

component clock_div
    Port ( clk : in STD_LOGIC;
           div : out STD_LOGIC);
end component;

component uart
    port (

    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0)

);
end component;

component echo
    Port ( clk : in STD_LOGIC;
           rdy : in STD_LOGIC;
           en : in STD_LOGIC;
           newChar : in STD_LOGIC;
           charIn : in STD_LOGIC_VECTOR (7 downto 0);
           charOut : out STD_LOGIC_VECTOR (7 downto 0);
           send : out STD_LOGIC);
end component;

signal dbnc0i, dbnc1i, divi: std_logic;
signal rdyready, sendi,newnew: std_logic;
signal charsendchar: std_logic_vector(7 downto 0);
signal charrcharin: std_logic_vector(7 downto 0);

begin

RTS <= '0';
CTS <= '0';

deb0: debounce port map (
                        clk => clk,
                        btn => btn(0),
                        dbnc => dbnc0i );
                        
deb1: debounce port map (
                        clk => clk,
                        btn => btn(1),
                        dbnc => dbnc1i );
                      
clkdiv: clock_div port map (
                        clk => clk,
                        div => divi);
                                              
                      
uart3: uart port map (
                        charSend => charsendchar ,
                        clk => clk,
                        en => divi,
                        rst => dbnc0i,
                        rx => TXD,
                        send => sendi ,
                        ready => rdyready ,
                        tx => RXD,
                        newChar => newnew,
                        charrec => charrcharin);
                        
echoer: echo port map (
                        clk => clk,
                        en => divi,
                        rdy => rdyready,
                        newchar => newnew,
                        charin => charrcharin,
                        charout => charsendchar,
                        send => sendi);

end Structural;