LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY DFF_Piped is port(

  clk:                in std_logic := '0';
  set,rst:            in std_logic := '0';
  output:             out std_logic := '0';
  output_prev:        out std_logic := '0'
  
  );
end  DFF_Piped;

ARCHITECTURE rtl OF DFF_Piped IS


  
  
begin
  
    process (clk)
      variable input_logic: std_logic := '0';
      variable old_out: std_logic := '0';
      begin--clears at rising and sets at falling
        if falling_edge(clk) then--from 0 to 1, or 1 to 1
            output_prev <= old_out;
            input_logic := set OR (old_out AND (not (rst)));
            old_out:=input_logic;
            output <= old_out; 
			end if;
      end process;
		
		 
		 
end rtl;
    

