library ieee;
use ieee.std_logic_1164.all;
use work.all;

package micro_assembly_code is 
  subtype opcode is std_logic_vector(2 downto 0); 
  subtype regs is std_logic_vector(3 downto 0); --bit 0 is Enable 
  
  type instruction is record      
    IE:std_logic; 
    WrReg,ReadA,ReadB:regs; 
    ALU,SHIFT:opcode; 
    OE:std_logic;  
  end record; 
  
  type instruct is record 
    --ctrlsgnls={writeEnable,readEnable,ie,oe,write,reada,readb, bypass,en,reset}
    WRRD:std_logic_vector(1 downto 0);
    IE,OE,WRITER,READA,READB:std_logic; 
    ALU:opcode;
    BYPASS:std_logic_vector(1 downto 0);
    EN, RESET:std_logic; 
  end record; 
  
  type program is array(natural range <>) of Instruction; 
  
  type prog is array(natural range <>) of Instruct;
  
  constant OpAdd:opcode:="000";
  constant OpSub:opcode:="001";
  constant OpAnd:opcode:="010"; 
  constant OpOr:opcode :="011";
  constant OpXor:opcode:="100"; 
  constant OpMovB:opcode:="101";
  constant OpMov:opcode:="110";
  constant OpNop:opcode:="111";   
  
  --shift instructions 
    
  constant pass:  opcode:="000"; 
  constant shiftl:opcode:="100"; 
  constant shiftr:opcode:="110"; 
  constant rotl:  opcode:="101"; 
  constant rotr:  opcode:="111";
  
  --register macros 
  constant Rx:regs  :="0000"; --bit zero is the enable signal 
  constant Zero:regs:="0001"; --R0 always zero 
  constant R1:regs  :="0011";
  constant R2:regs  :="0101";
  constant R3:regs  :="0111";
  constant R4:regs  :="1001";
  constant R5:regs  :="1011";
  constant R6:regs  :="1101";
  constant R7:regs  :="1111"; 
  
  --ctrlsgnls={ie, oe, write, reada, readb, alu, bypass, en, reset}
  constant ROM:prog :=( 
  ("00",'0','1','1','1','1',OpAdd,"00",'1','0'),--ADD 0
  ("00",'0','1','1','1','1',OpSub,"00",'1','0'),--SUB 
  ("00",'0','1','1','1','1',OpAnd,"00",'1','0'),--AND 
  ("00",'0','1','1','1','1',OpOr, "00",'1','0'),--OR  3
  ("00",'0','1','1','1','1',OpXor,"00",'1','0'),--XOR 
  ("00",'0','1','1','0','1',OpMovB,"00",'1','0'),--MOVB 
  ("00",'0','1','1','1','0',OpMov,"00",'1','0'),--MOV 6
  ("00",'0','0','0','0','0',OpNop,"00",'0','0'),--NOP 
  ("01",'1','1','1','1','0',OpMov,"00",'1','0'),--LD    r1 = mem<r2> 
  ("10",'0','1','0','1','1',OpMov,"00",'1','0'),--ST  9 mem<r2> = r1 
  ("00",'0','1','1','0','0',OpMov,"10",'1','0'),--LDI 
  ("00",'0','1','1','0','0',OpMov,"10",'1','0'),--Not used, change later
  ("00",'0','1','1','1','0',OpAdd,"01",'1','0'),--BRZ 12
  ("00",'0','1','1','1','0',OpAdd,"01",'1','0'),--BRN 
  ("00",'0','1','1','1','0',OpAdd,"01",'1','0'),--BRO 
  ("00",'0','1','1','1','0',OpAdd,"01",'1','0') --BRA 15
  ); 
  
end micro_assembly_code;
