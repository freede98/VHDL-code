library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity clk_div is
   generic (d: integer);
   port(   
          clkin:in   std_logic;
          clkout:out  std_logic
        );
end clk_div;

architecture clock_divider of clk_div is

signal counter : integer  := 0;
signal period  : integer  := d;

begin

clkout <=  clkin when period=1
           else'0' when clkin='1' and clkin'event and counter=0
           else '1' when clkin='1' and clkin'event and counter=period/2;

counter <= counter+1 when clkin='1' and clkin'event and counter/=period-1
           else 0 when clkin='1' and clkin'event;

end architecture;