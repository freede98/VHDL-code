library ieee;
use ieee.std_logic_1164.all;
use work.all;

Entity mux_bp is
  generic (n: integer);
  port(   qin,off:in std_logic_vector(n-1 downto 0);
          bp:   in   std_logic;
          qout: out  std_logic_vector(n-1 downto 0));
end;

Architecture mux of mux_bp is
begin
 qout <= qin when bp ='0' else
          off;
 
end;