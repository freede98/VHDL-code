library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity one_chip_computer is
 generic (d: integer := 25*10**6;
           m: integer := 3;
           n: integer := 16);
 port(
        clkin: in std_logic;
        reset: in std_logic;
        instruction: in std_logic_vector(15 downto 0);
        LEDS: out std_logic_vector(15 downto 0)
  );           

end one_chip_computer;

architecture test_computer of one_chip_computer is
  component fsmd is
  generic  (d: integer;
            m: integer;
            n: integer);
     port(
        clkin: in std_logic;
        reset: in std_logic;
        din: in std_logic_vector(15 downto 0);
        instruction: in std_logic_vector(15 downto 0);
        dout:out  std_logic_vector(15 downto 0);
        pcout:out std_logic_vector(15 downto 0);
        address:out std_logic_vector(7 downto 0);
        Wren  :out std_logic;
        Rden  :out std_logic;
        OE:out std_logic
  );
  end component;
  
  component clk_div is
   generic (d: integer); 
   port(   
          clkin:in   std_logic;
          clkout:out  std_logic
        );
  end component;
  
  component my_GPIO is
  generic ( m: integer;
          n: integer);
  port( 
        clk:  in  std_logic;
        reset:in  std_logic;
        IE:   in  std_logic;
        OE:   in  std_logic;
        din:    in  std_logic_vector(n-1 downto 0);
        address:in  std_logic_vector(m-1 downto 0);
        dout:   out std_logic_vector(n-1 downto 0)
  );
  end component;
  
  Component ram3 IS
  PORT
	(
		address: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rden		 : IN STD_LOGIC  := '1';
		wren		 : IN STD_LOGIC ;
		q		   : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	end component;
  
  signal clk:    std_logic:='0';
  signal datain: std_logic_vector(15 downto 0) 
               := (others => '0');  
  signal dataout:std_logic_vector(15 downto 0);
  signal progcount:std_logic_vector(15 downto 0);
  signal wr:  std_logic;
  signal rd:  std_logic;
  signal oe:  std_logic;
  signal address: std_logic_vector(7 downto 0);
  
  begin 
  
  DIV: clk_div
  generic map (d => d)
  port map(clkin => clkin, clkout=> clk);
  
  FSMData: fsmd
  generic map (d => 1, m => m, n => n)
  port map(clk,reset,datain,instruction, dataout, 
            progcount, address, wr, rd, oe);
	
	ram3_component : ram3
	port map(address,clk,dataout,rd,wr,datain);
    
  GPIO:my_GPIO
  generic map ( n => n, m => 8)
  port map(clk,reset,rd,oe,dataout,address,LEDS);
  
end architecture;