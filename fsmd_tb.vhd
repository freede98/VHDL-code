library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.instruction_package.all;

entity fsmd_tb is
 generic (d: integer := 1;
           m: integer := 3;
           n: integer := 16);
end fsmd_tb;

architecture test_fsmd of fsmd_tb is
  component fsmd is
  generic  (d: integer := d;
           m: integer := m;
           n: integer := n);
  port(
        clkin: in std_logic;
        reset: in std_logic;
        din: in std_logic_vector(15 downto 0);
        instruction: in std_logic_vector(15 downto 0);
        dout:out  std_logic_vector(15 downto 0);
        pcout:out std_logic_vector(15 downto 0);
        address:out std_logic_vector(15 downto 0)
  );
  end component;

signal clk:    std_logic:='0';
signal reset:  std_logic:='0';
signal datain: std_logic_vector(15 downto 0); 
signal instruction: std_logic_vector(15 downto 0);
signal dataout:std_logic_vector(15 downto 0);
signal progcount:std_logic_vector(15 downto 0);
signal address:std_logic_vector(15 downto 0);

begin

FSMData: fsmd
generic map (d => d,m => m, n => n)
  port map(clk,reset,datain,instruction, dataout, progcount, address);

clk <= not clk after 1 ns;

process 
begin
    
wait until clk='1';
instruction <= instLDI & R0 & "000001111"; 

wait for 8 ns;
instruction <= instLDI & R1 & "000000011"; 

wait for 8 ns;
instruction <= instSUB & R2 & R0 & R1 & nu; 

wait for 8 ns;
instruction <= instLDI & R0 & "000011001"; 

wait for 8 ns;
instruction <= instLDI & R1 & "000001101"; 

wait for 8 ns;
instruction <= instLDI & R2 & "000000001"; 

wait for 8 ns;
instruction <= instLD & R4 & R2 & nu & nu; 

wait for 8 ns;
instruction <= instST & nu & R1 & R0 & nu; 

wait for 8 ns;
instruction <= instMOV & R2 & R0 & nu & nu;

wait for 8 ns;
instruction <= instADD & R3 & R0 & R1 & nu; 

wait for 8 ns;
instruction <= instSUB & R3 & R0 & R1 & nu; 

wait for 8 ns;
instruction <= instAND & R3 & R0 & R1 & nu; 

wait for 8 ns;
instruction <=  instOR & R3 & R0 & R1 & nu; 

wait for 8 ns;
instruction <= instXOR & R3 & R0 & R1 & nu; 

wait for 8 ns;
instruction <=instMOVB & R3 & R0 & R1 & nu; 

wait for 8 ns;
instruction <= instSUB & R3 & R1 & R0 & nu; 

wait for 8 ns;
instruction <= instBRN & "000000001111"; 

wait for 8 ns;
instruction <= instBRO & "000000001111"; 

wait for 8 ns;
instruction <= instBRA & "000000001111"; 

wait for 8 ns;
instruction <= instBRO & "000000001111"; 

wait for 200 ns;
end process;
end architecture;
