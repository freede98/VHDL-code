library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.instruction_package.all;
use work.all;

entity externalmem is
generic ( m: integer := 8;
          n: integer := 16);
 port( 
        clk:   in  std_logic;
        rden:  in  std_logic;
        wren:  in  std_logic;
        din:    in  std_logic_vector(n-1 downto 0);
        address:in  std_logic_vector(m-1 downto 0);
        dout:   out  std_logic_vector(n-1 downto 0)
  );
end externalmem;

Architecture ext_mem of externalmem is

type field is array ((2**m)-1 downto 0) of std_logic_vector(n-1 downto 0);

signal ext_register : field := (

20 downto 19 => instNOP & nu & nu & nu & nu,
18=> instBRA & "000000000000",
17=> instST  & nu & R5 & R2 & nu,
16=> instST  & nu & R6 & R2 & nu,
15=> instBRA & "111111111100",
14=> instNOP & nu & nu & nu & nu,
13=> instBRZ & "000000000011",
12=> instSUB & R0 & R0 & R1 & nu,
11=> instADD & R2 & R2 & R1 & nu,
10=> instMOV & R2 & R0 & nu & nu,
9 => instLDI & R0 & "000001110",
8 => instLDI & R1 & "000000001",
7 => instST  & nu & R6 & R3 & nu,
6 => instLDI & R3 & "000000011",
5 => instLDI & R6 & "000100000",
4 downto  1  => instADD & R5 & R5 & R5 & nu,
0 => instLDI & R5 & "100000000",
others => (others => '0'));

signal address_int : integer range 255 downto 0;

begin
address_int <= to_integer(unsigned(address));

process(clk, ext_register, rden, address_int)
  begin
    IF rising_edge(clk) AND rden='1' THEN
      dout <= ext_register(address_int);
    ELSIF rising_edge(clk) THEN
      dout <= (others => '0');
    END IF;
END PROCESS;

process(clk, ext_register, wren, address_int)
  begin
    IF rising_edge(clk) AND wren='1' THEN
      ext_register(address_int) <= din;
    END IF;
END PROCESS;

end architecture;