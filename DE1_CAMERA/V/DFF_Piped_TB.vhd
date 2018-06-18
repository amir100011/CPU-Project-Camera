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



entity DFF_Piped_TB is
end DFF_Piped_TB;

architecture rtl of DFF_Piped_TB is  

component DFF_Piped is port(

  clk:                in std_logic := '0';
  set,rst:            in std_logic := '0';
  output:             out std_logic := '0'
  
  );
end component DFF_Piped;

signal  RST_q,SET_q,clk_q : std_logic:='0';
signal output_DFF : std_logic :='0';

for tester: DFF_Piped use entity work.DFF_Piped;

begin
        tester : DFF_Piped
        port map(clk => clk_q, set => SET_q, rst => RST_q , output=>output_DFF);
        
 process
 begin
   
   --TEST 0 - no resets
      RST_q <= '1';
      SET_q <= '1';
      clk_q <= '1';--out = 0
      wait for 1 ns;
      clk_q <= '0';
      wait for 1 ns;
      RST_q <= '1';
      SET_q <= '1';
      clk_q <= '1';--out = 1
      wait for 1 ns;
      assert(output_DFF = '0') report "output_DFF error 0" severity error;
      clk_q <= '0';
      wait for 1 ns;
      RST_q <= '1';
      SET_q <= '0';
      clk_q <= '1';--out = 0
      wait for 1 ns;
      assert(output_DFF = '1') report "output_DFF error 0" severity error;
      clk_q <= '0';
      wait for 1 ns;
      RST_q <= '1';
      SET_q <= '1';
      clk_q <= '1';--out 1
      wait for 1 ns;
      assert(output_DFF = '0') report "output_DFF error 0" severity error;
      clk_q <= '0';
      wait for 1 ns;
      RST_q <= '0';
      SET_q <= '0';
      clk_q <= '1';--out 1
      wait for 1 ns;
      assert(output_DFF = '1') report "output_DFF error 0" severity error;
      clk_q <= '0';
      wait for 1 ns;
      RST_q <= '1';
      SET_q <= '0';
      clk_q <= '1';--out 0
      wait for 1 ns;
      assert(output_DFF = '1') report "output_DFF error 0" severity error;
      clk_q <= '0';
      wait for 1 ns;
      RST_q <= '0';
      SET_q <= '0';
      clk_q <= '1';--out 1
      wait for 1 ns;
      assert(output_DFF = '0') report "output_DFF error 0" severity error;
      clk_q <= '0';
      wait for 1 ns;
      RST_q <= '0';
      SET_q <= '0';
      clk_q <= '1';
      wait for 1 ns;--out 1
      assert(output_DFF = '1') report "output_DFF error 0" severity error;
      clk_q <= '0';
      wait for 1 ns;
      RST_q <= '0';
      SET_q <= '0';
      clk_q <= '1';
      wait for 1 ns;
      assert(output_DFF = '1') report "output_DFF error 0" severity error;

    end process;
         
end rtl;



