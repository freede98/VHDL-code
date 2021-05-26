library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity my_GPIO is
generic ( m: integer := 8;
          n: integer := 16);
 port( 
        clk:  in  std_logic;
        reset:in  std_logic;
        IE:   in  std_logic;
        OE:   in  std_logic;
        din:    in  std_logic_vector(n-1 downto 0);
        address:in  std_logic_vector(m-1 downto 0);
        dout:   out std_logic_vector(n-1 downto 0)
  );
end my_GPIO;

Architecture gpio_run of my_GPIO is

signal storeData,Q : std_logic_vector(n-1 downto 0) := (others => '0');
signal z_line : std_logic_vector(n-1 downto 0) := (others => 'Z');

begin

process(clk,reset,IE)
begin
  if(reset='1') then
    storeData <= (others =>'0');
  elsif rising_edge(clk) then
    if (IE = '1') then
      storeData <= din;
    else
      storeData <= Q;
    end if;
  end if;
end process;
  
process(OE,storeData)
begin
  if (OE='1') then
    Q <= storeData;
  else
    Q <= (others =>'0');
  --if (storeData=z_line) then
  --  Q <= (others =>'0');
  --else 
  --  Q <= storeData;
  end if;
end process;

dout <= Q;

end architecture;