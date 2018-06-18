LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Stall_Mux is port(

  Instruction:            in std_logic_vector (31 downto 0) := (others=>'0');
  stall:                  in std_logic:='0';
  output:                 out std_logic_vector (31 downto 0) := (others=>'0')
  
  );
end  Stall_Mux;

ARCHITECTURE rtl OF Stall_Mux IS

  begin
    
  output<= Instruction when stall = '0' else x"00000000";
 
    end rtl;


