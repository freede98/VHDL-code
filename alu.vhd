
library ieee;
use ieee.std_logic_1164.all;
use work.all;

Entity alu is
  port(   a,b,Cin:in   std_logic;
          op:in        std_logic_vector(2 downto 0);
          sum,Cout: out   std_logic);
end;

Architecture alumod of alu is
begin
  
  sum <= ((a xor b) xor Cin)       when op="000" else
         ((a xor (not b)) xor Cin) when op="001" else
         (a and b) when op="010" else
         (a or b)  when op="011" else
         (a xor b) when op="100" else
         --(not a)   when op="101" else
         b         when op="101" else
         a         when op="110" else
         (a xor Cin);
         
  Cout <= ((a and b) or (Cin and (a xor b)) )            when op="000" else   
          ((a and (not b)) or (Cin and (a xor (not b)))) when op="001" else
          ( Cin and a )                                  when op="111" else 
          '0';
end;

