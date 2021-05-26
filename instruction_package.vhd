library ieee;
use ieee.std_logic_1164.all;
use work.all;

package instruction_package is 
  subtype inst is std_logic_vector(3 downto 0); 
  subtype regs is std_logic_vector(2 downto 0); --bit 0 is Enable 
  
  type instruction is record 
    instruct:inst;
    WrReg,ReadA,ReadB,other:regs; 
  end record; 
  
  --type program is array(natural range <>) of Instruction; 
  
  constant instAdd:inst:="0000";
  constant instSub:inst:="0001";
  constant instAnd:inst:="0010"; 
  constant instOr :inst:="0011";
  constant instXor:inst:="0100"; 
  constant instMovB:inst:="0101";
  constant instMov:inst:="0110";
  constant instNop:inst:="0111";  
  constant instLD :inst:="1000";
  constant instST :inst:="1001";
  constant instLDI:inst:="1010"; 
  constant instNU :inst:="1011";
  constant instBRZ:inst:="1100"; 
  constant instBRN:inst:="1101";
  constant instBRO:inst:="1110";
  constant instBRA:inst:="1111";  
  
  --register macros 
  constant nu:regs  :="000";
  constant R0:regs  :="000";
  constant R1:regs  :="001";
  constant R2:regs  :="010";
  constant R3:regs  :="011";
  constant R4:regs  :="100";
  constant R5:regs  :="101";
  constant R6:regs  :="110";
  constant R7:regs  :="111"; 
  
end instruction_package;