library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity FPM is port(

    OperandA:           in std_logic_vector (31 downto 0):=(others=>'0');
    OperandB:           in std_logic_vector (31 downto 0):=(others=>'0');
    enable:             in std_logic:='0';
    AXB_Float:          out std_logic_vector (31 downto 0):=(others=>'0')
    );
    
    
  end FPM;
  
  architecture Arch_FPM of FPM is
    
  begin
    
    
    process(OperandA,OperandB,enable) is
  
    variable mantissas_mul_rounded: std_logic_vector(22 downto 0):=(others=>'0');  
    variable sign: std_logic:='0';
    variable mantissaA,mantissaB:std_logic_vector(23 downto 0):=(others=>'0'); 
    variable mantissas_mul_vec: std_logic_vector(47 downto 0):=(others=>'0');
	variable exponent_vector: std_logic_vector(7 downto 0):=(others=>'0');
	variable normalized_exp: integer:=0;
	 
    begin

      if(enable = '1') then
      
        if ( OperandA = X"00000000" or OperandB = X"00000000") then
            AXB_Float <=(others =>'0');
        else
          mantissaA := '1' & OperandA(22 downto 0);
          mantissaB := '1' & OperandB(22 downto 0);     
          mantissas_mul_vec := std_logic_vector(resize(unsigned(unsigned(mantissaA) * unsigned (mantissaB)),48));
          
          if(mantissas_mul_vec(47) = '1') then
            normalized_exp := 1;
            mantissas_mul_rounded:=  mantissas_mul_vec(46 downto 24);
          else
            normalized_exp := 0;
            mantissas_mul_rounded:=  mantissas_mul_vec(45 downto 23);
          end if;
           
          --exponent compution
        
            exponent_vector := std_logic_vector(resize(signed(OperandA(30 downto 23)) + signed(OperandB(30 downto 23)) - 127 + normalized_exp,8));
          
            --sign compution
        
            sign := OperandA(31) xor OperandB(31);
        
          AXB_Float <= sign & exponent_vector & mantissas_mul_rounded;
        end if;
      
		  else--no enable
			 AXB_Float <=(others =>'0');
		  
     end if; 
      end process;
    
     
     
      end Arch_FPM;   
        
        
        
        
        
        
          
