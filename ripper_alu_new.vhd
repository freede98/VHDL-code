
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

Entity ripper_alu_new is
  generic (n: integer);
  port(   
          Ain: in   std_logic_vector(n-1 downto 0);
          Bin: in   std_logic_vector(n-1 downto 0);
          op:  in   std_logic_vector(2 downto 0);
          clk: in   std_logic;
          en:  in   std_logic;
          reset:in  std_logic;
          Cout:out  std_logic;
          sum: out  std_logic_vector(n-1 downto 0); 
          z:   out  std_logic;
          neg: out  std_logic
       );
end ripper_alu_new;

Architecture alu_new_structure of ripper_alu_new is
  Component alu
    port( a,b,Cin:  in   std_logic;
          op:       in   std_logic_vector(2 downto 0);
          sum,Cout: out  std_logic);
  end component;

constant empty_line : std_logic_vector(n-1 downto 0) := std_logic_vector(to_unsigned(0, n)); 
signal carry_line : std_logic_vector(n downto 0);
signal sum_line : std_logic_vector(n-1 downto 0);
signal old_line : std_logic_vector(n-1 downto 0);

begin

carry_line(0) <= '1' when op="001" else
                 '1' when op="111" else 
                 '0';  

GO:FOR i IN 0 TO N-1 GENERATE
  FA: alu port map 
  ( 
    A => Ain(i), 
    B => Bin(i),
    op => op, 
    cin => carry_line(i),
    cout => carry_line(i+1),
    sum => sum_line(i)
  );
  end generate;
  
process(reset,sum_line,EN)
begin
  
  IF RESET='1' THEN
      sum<=empty_line;
      old_line<=empty_line;
      cout<= '0';
      z <= '1';
      neg <= '0';
  ELSIF EN='1' THEN
      sum<=sum_line;
      old_line<=sum_line;
      cout<= carry_line(n);
      neg <= sum_line(n-1);
      IF (sum_line=empty_line) THEN
        z <= '1';
      ELSE z <= '0';
      END IF;
  ELSE
      sum<=old_line;
      cout<= '0';
      neg <= old_line(n-1);
      IF (old_line=empty_line) THEN
        z <= '1';
      ELSE z <= '0';
      END IF;
  END IF;
END PROCESS;        
end architecture;


