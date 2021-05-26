library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity fsmd is
 generic ( d: integer := 5*10**7;
			     m: integer := 3;
           n: integer := 16);
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
end fsmd;

architecture cisc of fsmd is
  component datapath_branch is
    generic (
           m: integer;
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
end component;

component microctrl_rom is
  port(
        inst: in std_logic_vector(3 downto 0);
        cond: in std_logic;
        pc: in integer range 3 downto 0;
        uInstr:out std_logic_vector(13 downto 0)
  );
end component;

component mux3 is
   port(   
          z,n,o:in std_logic;
          sel:  in std_logic_vector(1 downto 0);
          q:   out std_logic
      );
end component;

 component clk_div is
   generic (d: integer); 
   port(   
          clkin:in   std_logic;
          clkout:out  std_logic
        );
  end component;

signal clk : std_logic;
signal uPC : integer range 3 downto 0 := 3;
signal next_uPC : integer range 3 downto 0 := 0;
signal IR  : std_logic_vector(15 downto 0) := (others => '0');
--signal save_addr : std_logic_vector(7 downto 0);
signal save_oe : std_logic;
signal z_flag : std_logic;
signal n_flag : std_logic;
signal o_flag : std_logic;
signal save_z : std_logic;
signal save_n : std_logic;
signal save_o : std_logic;
signal cond   : std_logic;
signal addresses :std_logic_vector(8 downto 0);
signal ctrlsgnls :std_logic_vector(13 downto 0);
signal dpout :std_logic_vector(15 downto 0);
signal offset:std_logic_vector(15 downto 0);
signal data  :std_logic_vector(15 downto 0);

begin
  
DIV: clk_div
  generic map (d => d)
  port map(clkin => clkin, clkout=> clk);  

ZNO: mux3
  port map(save_z, save_n, save_o, IR(13 downto 12), cond);

ROM: microctrl_rom
  port map(IR(15 downto 12), cond,uPC,ctrlsgnls);

JMP: datapath_branch
generic map (m => m, n => n)
  port map(
        clk => clk,
        ie    => ctrlsgnls(11), 
        oe    => ctrlsgnls(10), 
        waddr => addresses(8 downto 6),
        writer=> ctrlsgnls(9),
        ra    => addresses(5 downto 3),
        reada => ctrlsgnls(8),
        rb    => addresses(2 downto 0),
        readb => ctrlsgnls(7),
        input => din,
        op    => ctrlsgnls(6 DOWNTO 4),
        bypass=> ctrlsgnls(3 DOWNTO 2),
        offset=> offset,
        data  => data, 
        en    => ctrlsgnls(1),
        reset => reset,
        output=> dpout,
        o_flag=> o_flag,
        z_flag=> z_flag,
        n_flag=> n_flag);  

addresses <= IR(11 downto 3);
offset <= std_logic_vector(resize(signed(IR(11 downto 0)),16));
data   <= std_logic_vector(resize(signed(IR(8 downto 0)),16));

process(clk,dpout)
begin

--if(reset='1') then
  --uPC <= 3;
  --address <= (others => '0');
if rising_edge(clk) then
	Rden <= '0';
	Wren <= '0';
	pcout<= (others => 'Z');
	--dout <= (others => 'Z');
	
	if uPC < 3 then uPC <= uPC + 1; else uPC <= 0; end if;
	
	case uPC is
		when 0 => save_oe <= ctrlsgnls(1);
		          oe <= save_oe;
					    dout <= dpout;
					    save_z  <= z_flag;
					    save_n  <= n_flag;
					    save_o  <= o_flag;
					    if (IR(15 downto 12) = "1001") then
					      address <= dpout(7 downto 0);
					    end if;

		when 1 => if (IR(15 downto 12) = "1001") then
					     dout <= dpout;
					     WREN <= '1';
					    end if;
					    IR  <= din;		
                      
		when 2 => pcout    <= dpout;
		          address  <= dpout(7 downto 0);
		          --save_addr<= dpout(7 downto 0); 
            
		when others =>--IR  <= din;
		              Rden<= '1';     
	end case;
end if;
end process;
end architecture;