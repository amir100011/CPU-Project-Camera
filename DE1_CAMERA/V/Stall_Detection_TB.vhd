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



entity Stall_Detection_TB is
end Stall_Detection_TB;

architecture rtl of Stall_Detection_TB is  

component Stall_Detection is port (

  input_Set:              in std_logic_vector (4 downto 0) := (others=>'0');
  input_Reset:            in std_logic_vector (4 downto 0) := (others=>'0');
  clk:                    in std_logic := '0';
  output_stall:           out std_logic_vector (31 downto 0) := (others=>'0')
		
	);-- ports declerations
end component;

signal  RST_q,SET_q : std_logic_vector (4 downto 0):=(others=>'0');
signal clk_q: std_logic:='1';
signal output_q : std_logic_vector (31 downto 0) :=(others=>'0');

for tester: Stall_Detection use entity work.Stall_Detection;

begin
        tester : Stall_Detection
        port map(clk => clk_q, input_Set => SET_q, input_Reset => RST_q , output_stall=>output_q);
        
 process
 begin
   
   --TEST 0 - no resets
      SET_q <= "00000";
      clk_q <= '1';--out = 0
      wait for 1 ns;
      clk_q <= '0';
      wait for 1 ns;
      SET_q <= "00111";
      clk_q <= '1';--out = 1
      wait for 1 ns;
      RST_q <= "00111";
      clk_q <= '0';--out = 0
      wait for 1 ns;
      SET_q <= "00111";
      clk_q <= '1';
      wait for 1 ns;
      clk_q <= '0';--out = 1
      wait for 1 ns;
      SET_q <= "01111";
      RST_q <= "00000";
      clk_q <= '1';--out = 1
      wait for 1 ns;
      assert(output_q = X"00000002") report "output_DFF error 0" severity error;
      clk_q <= '0';--out = 0
      wait for 1 ns;
      RST_q <= "00001";
      SET_q <= "00000";
      clk_q <= '1';--out = 0
      wait for 1 ns;
      clk_q <= '0';
      wait for 1 ns;
      clk_q <= '1';--out = 1
      wait for 1 ns;
      clk_q <= '0';--out = 0
      wait for 1 ns;
      clk_q <= '1';
      wait for 1 ns;
      clk_q <= '0';--out = 1
      wait for 1 ns;
      clk_q <= '1';--out = 1
      wait for 1 ns;
      assert(output_q = X"00000002") report "output_DFF error 0" severity error;
      

    end process;
         
end rtl;





