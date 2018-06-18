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



entity Stall_Comparison_TB is
end Stall_Comparison_TB;

architecture rtl of Stall_Comparison_TB is  

component Stall_Comparison is port (

  clk:                           in std_logic := '0';
  input_Wanna_Read_A:            in std_logic_vector (4 downto 0) := (others=>'0');
  input_Wanna_Read_B:            in std_logic_vector (4 downto 0) := (others=>'0');
  input_Wanna_SET:               in std_logic_vector (4 downto 0) := (others=>'0');
  input_Wanna_RST:               in std_logic_vector (4 downto 0) := (others=>'0');
  output_comp:                   out std_logic:='0'
  --out_stall:                     out std_logic_vector(31 downto 0):=(others=>'0')
		
	);-- ports declerations
end component Stall_Comparison;

signal  RST_q,SET_q : std_logic_vector (4 downto 0):=(others=>'0');
signal try_take_A, try_take_B: std_logic_vector (4 downto 0):=(others=>'0');
signal clk_q: std_logic:='1';
signal output_q : std_logic:='0';
--signal out_stall_q: std_logic_vector(31 downto 0):=(others=>'0');

for tester: Stall_Comparison use entity work.Stall_Comparison;

begin
        tester : Stall_Comparison
        port map(clk => clk_q, input_Wanna_SET => SET_q, input_Wanna_RST => RST_q, output_comp=>output_q,
                 input_Wanna_Read_B=>try_take_B ,input_Wanna_Read_A=>try_take_A);
        
 process
 begin
   
      SET_q <= "00111";
      try_take_A <= "00001";
      try_take_B <= "00111";
      clk_q <= '1';--out = 0
      wait for 1 ns;
            assert(output_q = '1') report "output_Taken error 0" severity error;
      clk_q <= '0';
      wait for 1 ns;
      SET_q <= "00000";
      try_take_A <= "00111";
      try_take_B <= "01111";
      clk_q <= '1';--out = 0
      wait for 1 ns;
             assert(output_q = '0') report "output_Taken error 1" severity error;
      clk_q <= '0';
      wait for 1 ns;
      SET_q <= "00001";
      RST_q <= "00111";
      try_take_A <= "00111";
      try_take_B <= "01111";
      clk_q <= '1';--out = 0
      wait for 1 ns;
          assert(output_q = '0') report "output_Taken error 2" severity error;
      clk_q <= '0';
      wait for 1 ns;
      clk_q <= '1';--out = 0
      wait for 1 ns;
      assert(output_q = '1') report "output_Taken error 3" severity error;
      clk_q <= '0';
      wait for 1 ns;

      

    end process;
         
end rtl;







