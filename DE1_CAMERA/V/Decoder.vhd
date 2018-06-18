LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Decoder_5X32 is port(

  input:            in std_logic_vector (4 downto 0) := (others=>'0');
  output:             out std_logic_vector (31 downto 0) := (others=>'0')
  
  );
end  Decoder_5X32;

ARCHITECTURE rtl OF Decoder_5X32 IS
  
  begin 
    
  process (input) is
    
    begin
      
      case input is
        when "00000" => output <= (others => '0');
          
        when "00001" => output <= (1=>'1' , others => '0');
        
        when "00010" => output <= (2=>'1', others => '0');
        
        when "00011" => output <= (3=>'1', others => '0');
        
        when "00100" => output <= (4=>'1', others => '0');
        
        when "00101" => output <= (5=>'1', others => '0');
        
        when "00110" => output <= (6=>'1', others => '0');
        
        when "00111" => output <= (7=>'1', others => '0');
        
        when "01000" => output <= (8=>'1', others => '0');
        
        when "01001" => output <= (9=>'1', others => '0');
        
        when "01010" => output <= (10=>'1', others => '0');
        
        when "01011" => output <= (11=>'1', others => '0');
        
        when "01100" => output <= (12=>'1', others => '0');
        
        when "01101" => output <= (13=>'1', others => '0');
        
        when "01110" => output <= (14=>'1', others => '0');
        
        when "01111" => output <= (15=>'1', others => '0');
        
        when "10000" => output <= (16=>'1', others => '0');
          
        when "10001" => output <= (17=>'1', others => '0');
        
        when "10010" => output <= (18=>'1', others => '0');
        
        when "10011" => output <= (19=>'1', others => '0');
        
        when "10100" => output <= (20=>'1', others => '0');
        
        when "10101" => output <= (21=>'1', others => '0');
        
        when "10110" => output <= (22=>'1', others => '0');
        
        when "10111" => output <= (23=>'1', others => '0');
        
        when "11000" => output <= (24=>'1', others => '0');
        
        when "11001" => output <= (25=>'1', others => '0');
        
        when "11010" => output <= (26=>'1', others => '0');
        
        when "11011" => output <= (27=>'1', others => '0');
        
        when "11100" => output <= (28=>'1', others => '0');
        
        when "11101" => output <= (29=>'1', others => '0');
        
        when "11110" => output <= (30=>'1', others => '0');
        
        when "11111" => output <= (31=>'1', others => '0');
          
        when others => output <= (others=>'0');
          
        end case;
      end process;
    end rtl;
