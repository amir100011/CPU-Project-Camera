--
--	File Name:		Test_D_FlipFlop.vhd
--	Description:	Test bench for counter 
--					
--
--	Date:			30/03/2018
--	Designer:		Amir Tsur
--
-- ====================================================================
-- Test Bench for D_FlipFlop_MemoryReg.

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



entity Decoder_5X32_TB is
end Decoder_5X32_TB;

architecture rtl of Decoder_5X32_TB is  

component Decoder_5X32 is port(

  input:            in std_logic_vector (4 downto 0) := (others=>'0');
  output:             out std_logic_vector (31 downto 0) := (others=>'0')
  
  );
end component Decoder_5X32;

signal  in_q : std_logic_vector (4 downto 0) := (others=>'0');
signal out_q : std_logic_vector (31 downto 0) := (others=>'0');

for tester: Decoder_5X32 use entity work.Decoder_5X32;

begin
        tester : Decoder_5X32
        port map(input => in_q, output => out_q);
        
 process
 begin
   
    --TEST 0 - no resets
      in_q <= "00001";
      wait for 1 ns;
      assert(out_q = X"00000002") report "output_DFF error 0" severity error;
    end process;
         
end rtl;




