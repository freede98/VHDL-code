library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity reg_file is
generic ( m: integer;
          n: integer);
 port( 
        clk:   in  std_logic;
        wd:    in  std_logic_vector(n-1 downto 0);
        waddr: in  std_logic_vector(m-1 downto 0);
        writer:in  std_logic;
        ra:    in  std_logic_vector(m-1 downto 0);
        reada: in  std_logic;
        rb:    in  std_logic_vector(m-1 downto 0);
        readb: in  std_logic;
        reset: in  std_logic;
        qa:   out  std_logic_vector(n-1 downto 0);
        qb:   out  std_logic_vector(n-1 downto 0)
  );
end reg_file;

Architecture register_file of reg_file is

type field is array ((2**m)-1 downto 0) of std_logic_vector(n-1 downto 0);

signal saveregister : field := (others => (others => '0'));
signal waddr_int : integer range (2**m)-1 downto 0;
signal ra_int : integer range (2**m)-1 downto 0;
signal rb_int : integer range (2**m)-1 downto 0;

begin
waddr_int <= to_integer(unsigned(waddr));
ra_int <= to_integer(unsigned(ra));
rb_int <= to_integer(unsigned(rb));

process(reada,readb,saveregister,ra_int,rb_int)
  begin
    IF reada='1' THEN
      qa <= saveregister(ra_int);
    ELSE qa <= (OTHERS => '0');
    END IF;
    
    IF readb='1' THEN
      qb <= saveregister(rb_int);
    ELSE qb <= (OTHERS => '0');
    END IF;
END PROCESS;

process(clk, reset, writer)
  begin
    --IF reset='1' THEN
    --  saveregister(((2**m)-1) downto 0) <= (others => (others => '0'));--break
    --ELSIF (rising_edge(clk) AND writer='1') THEN --breaks?
	 IF (rising_edge(clk) AND writer='1') THEN 
      saveregister(waddr_int) <= wd; --break 
    END IF;
END PROCESS;

end architecture;