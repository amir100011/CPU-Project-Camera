LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Stall_Comparison is port(--comaprosin is Asyncronus

  clk:                           in std_logic := '0';
  instruction:                   in std_logic_vector(31 downto 0):=(others=>'0');
  input_Wanna_RST:               in std_logic_vector (4 downto 0) := (others=>'0');
  output_comp:                   out std_logic:='0'
 -- out_stall:                     out std_logic_vector(31 downto 0):=(others=>'0')
  
  );
end  Stall_Comparison;

ARCHITECTURE rtl OF Stall_Comparison IS

Component Stall_Detection is port(

  input_Set:              in std_logic_vector (4 downto 0) := (others=>'0');
  input_Reset:            in std_logic_vector (4 downto 0) := (others=>'0');
  clk:                    in std_logic := '0';
  output_stall:           out std_logic_vector (31 downto 0) := (others=>'0');
  out_prev:               out std_logic_vector (31 downto 0) := (others=>'0') 
  
  );
end Component Stall_Detection;

signal output_stall_mux, output_stall_mux_prev:std_logic_vector (31 downto 0) := (others=>'0');
signal input_Wanna_SET,input_Wanna_Read_A,input_Wanna_Read_B: std_logic_vector(4 downto 0):= (others=>'0');

begin
  
  input_Wanna_SET <= instruction(15 downto 11) when instruction(31 downto 26) = "000000" --R-type
                ELSE instruction(20 downto 16) when instruction(31 downto 26) = "100011" --LW-type
                ELSE instruction(20 downto 16) when instruction(31 downto 26) = "101011" --SW-type
                ELSE "00000";--BRANCH
                 
   input_Wanna_Read_A <= instruction(25 downto 21) when instruction(31 downto 26) = "000000" --R-type
                    ELSE instruction(25 downto 21) when instruction(31 downto 26) = "101011" --SW-type
						  ELSE instruction(25 downto 21) when instruction(31 downto 26) = "000100" --BRANCH
                    ELSE "00000";--LW
               
  input_Wanna_Read_B <= instruction(20 downto 16) when instruction(31 downto 26) = "000000" --R-type
						 ELSE instruction(20 downto 16) when instruction(31 downto 26) = "000100" --BRANCH
                   ELSE "00000";--SW, LW                              
  
Stall: Stall_Detection port map(clk=>clk, input_Set=>input_Wanna_SET, input_Reset=>input_Wanna_RST,output_stall=>output_stall_mux, out_prev=>output_stall_mux_prev);
  
  
  output_comp <= '0' when (((input_Wanna_RST = input_Wanna_Read_A OR (input_Wanna_SET = input_Wanna_Read_A AND output_stall_mux_prev(to_integer(unsigned(input_Wanna_Read_A))) = '0')) AND input_Wanna_Read_A /= x"00000000" AND output_stall_mux(to_integer(unsigned(input_Wanna_Read_B))) /= '1')--wnat to reset A OR B 
                                                                              OR 
                           ((input_Wanna_RST = input_Wanna_Read_B OR(input_Wanna_SET = input_Wanna_Read_B AND output_stall_mux_prev(to_integer(unsigned(input_Wanna_Read_A))) = '0'))AND input_Wanna_Read_B /= x"00000000" AND output_stall_mux(to_integer(unsigned(input_Wanna_Read_A))) /= '1'))

                           
          else '1' when (output_stall_mux(to_integer(unsigned(input_Wanna_Read_A))) = '1' OR output_stall_mux(to_integer(unsigned(input_Wanna_Read_B))) = '1')
            
          else '0';
  
  
 
end rtl;
