
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.instruction_package.all;

entity one_chip_test is
 generic (d: integer := 1;
           m: integer := 3;
           n: integer := 16); 
end one_chip_test;

architecture test_chip of one_chip_test is
  component one_chip_computer is
  generic (d: integer;
           m: integer;
           n: integer);
  port(
        clkin: in std_logic;
        reset: in std_logic;
        instruction: in std_logic_vector(15 downto 0)
  );       
  end component;
  
  signal clk:    std_logic:='0';
  signal reset:  std_logic:='0';
  signal instruction: std_logic_vector(15 downto 0);
  
  begin 
  
  ONECHIP: one_chip_computer
  generic map (d => d,m => m, n => n)
  port map(clk, reset, instruction);
  
  clk <= not clk after 1 ns;
  
process 
begin
    
wait until clk='1';
instruction <= instNOP & nu & nu & nu & nu; 

wait for 10000 ns;
end process;
end architecture;