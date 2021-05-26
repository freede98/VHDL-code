library ieee;
use ieee.std_logic_1164.all;
use work.all;

Entity mux3 is
  port(   
          z,n,o:in std_logic;
          sel:  in std_logic_vector(1 downto 0);
          q:   out std_logic
      );
end;

Architecture mux of mux3 is
begin
 q <= z when sel ="00" else
      n when sel ="01" else
      o when sel ="10" else
      '1';
end;

