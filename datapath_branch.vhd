library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity datapath_branch is
  generic (m: integer; 
			     n: integer);
   port( 
        clk: in  std_logic;
        ie:    in  std_logic;
        oe:    in  std_logic;
        waddr: in  std_logic_vector(m-1 downto 0);
        writer:in  std_logic;
        ra:    in  std_logic_vector(m-1 downto 0);
        reada: in  std_logic;
        rb:    in  std_logic_vector(m-1 downto 0);
        readb: in  std_logic;
        input: in  std_logic_vector(n-1 downto 0);
        op:    in  std_logic_vector(2 downto 0);
        bypass:in  std_logic_vector(1 downto 0);
        offset:in  std_logic_vector(n-1 downto 0);
        data:  in  std_logic_vector(n-1 downto 0);
        en:    in  std_logic;
        reset: in  std_logic;
        output:out std_logic_vector(n-1 downto 0);
        o_flag:out std_logic;
        z_flag:out std_logic;
        n_flag:out std_logic
  );
end datapath_branch;

architecture path of datapath_branch is
  component reg_file is
    generic (m: integer;
             n: integer);
     port(  
           clk:   in  std_logic;
           wd:    in  std_logic_vector(n-1 downto 0);
           waddr: in  std_logic_vector(m-1 downto 0);
           writer: in  std_logic;
           ra:    in  std_logic_vector(m-1 downto 0);
           reada: in  std_logic;
           rb:    in  std_logic_vector(m-1 downto 0);
           readb: in  std_logic;
           reset: in  std_logic;
           qa:   out  std_logic_vector(n-1 downto 0);
           qb:   out  std_logic_vector(n-1 downto 0)
        );
  end component;
  
  component ripper_alu_new is
    generic (n: integer); 
     port(  
            Ain:  in    std_logic_vector(n-1 downto 0);
            Bin:  in    std_logic_vector(n-1 downto 0);
            op:   in    std_logic_vector(2 downto 0);
            clk:  in    std_logic:='0';
            en:   in    std_logic;
            reset:in    std_logic;
            Cout:out    std_logic;
            sum: out    std_logic_vector(n-1 downto 0);
            z:   out    std_logic;
            neg: out    std_logic
        );
  end component;

  component mux_bp is
   generic (n: integer);
    port( qin,off:in std_logic_vector(n-1 downto 0);
          bp:   in   std_logic;
          qout: out  std_logic_vector(n-1 downto 0));
  end component;

signal inreg: std_logic_vector(n-1 downto 0);
signal qa: std_logic_vector(n-1 downto 0);
signal qb: std_logic_vector(n-1 downto 0);
signal a_io: std_logic_vector(n-1 downto 0);
signal b_io: std_logic_vector(n-1 downto 0);
signal waddrbp: std_logic_vector(m-1 downto 0);
signal rabp: std_logic_vector(m-1 downto 0);
signal readabp: std_logic;
signal sum: std_logic_vector(n-1 downto 0);
signal writereg: std_logic;
constant imped_line: std_logic_vector(n-1 downto 0) := (others => 'Z');

begin

inreg <= input when ie='1' else sum;
output <= sum when oe='1' else imped_line;

waddrbp <= (others => '1') when bypass(0) = '1' else waddr;
rabp <= (others => '1') when bypass(0) = '1' else ra;
readabp <= (reada or bypass(0));
        
MUX1:mux_bp
  generic map ( n => n)
  port map(
    qin => qa,
    off => data,
    bp => bypass(1),
    qout => a_io
  );
  
MUX2:mux_bp
 generic map ( n => n)
  port map(
    qin => qb,
    off => offset,
    bp => bypass(0),
    qout => b_io
  );
        
ALU: ripper_alu_new
generic map (n => n)
  port map(
    Ain  => a_io,
    Bin  => b_io,
    op   => op,
    clk  => clk,
    en   => en,
    reset=> reset,
    sum  => sum,
    cout => o_flag,
    neg  => n_flag,
    z    => z_flag
  );
  
  REG: reg_file
  generic map (m => m, n => n)
  port map(
            clk => clk, 
            wd => inreg, 
            waddr => waddrbp, 
            writer => writer, 
            ra =>rabp, 
            reada=>readabp, 
            rb=>rb, 
            readb=>readb, 
            qa=>qa, 
            qb=>qb,
            reset => reset
        );
  
end architecture;