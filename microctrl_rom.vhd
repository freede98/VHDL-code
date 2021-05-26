library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.micro_assembly_code.all;
use work.all;

entity microctrl_rom is
  port(
        inst: in std_logic_vector(3 downto 0);
        cond: in std_logic;
        pc: in integer range 3 downto 0;
        uInstr:out std_logic_vector(13 downto 0)
  );
end microctrl_rom;

architecture behave of microctrl_rom is 
  
  signal instr : instruct;
  signal index : integer range 15 downto 0;
  --signal save_cond: std_logic;
  signal instrNUM : std_logic_vector(3 downto 0);
  constant incrPC : std_logic_vector(13 downto 0) := "00"&"01"&"110"&"111"&"01"&"10";
  --constant incrAddress : std_logic_vector(13 downto 0) := "00"&"01"&"010"&"111"&"01"&"10";
  constant noOper : std_logic_vector(13 downto 0) := "00"&"00"&"000"&"111"&"00"&"00";
  
  begin
    
  index <= to_integer(unsigned(inst));
  
  instr <= ROM(index);
  
  --save_cond <= cond when pc=0;
  
    uInstr <= instr.WRRD & instr.IE & instr.OE & instr.WRITER & instr.READA 
              & instr.READB & instr.ALU & instr.BYPASS & instr.EN
              & instr.RESET when (pc=0 and index < 12) else
                       
              --instr.WRRD & instr.IE & instr.OE & instr.WRITER & instr.READA 
              --& instr.READB & instr.ALU & instr.BYPASS & instr.EN
              --& instr.RESET when ((pc=0 or pc=2) and index=8) else
              
              instr.WRRD & instr.IE & instr.OE & instr.WRITER & instr.READA 
              & instr.READB & OpMovB & instr.BYPASS & instr.EN
              & instr.RESET when (pc=1 and index=9) else

              instr.WRRD & instr.IE & instr.OE & instr.WRITER & instr.READA 
              & instr.READB & instr.ALU & instr.BYPASS & instr.EN
              & instr.RESET when (pc=2 and cond='1' and index >= 12) else
              --save_cond='1' and index >= 12) else
              
              incrPC when pc=2 else
              
              --incrAddress when pc=3 else
              
              NoOper;
  end behave;