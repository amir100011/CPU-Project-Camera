
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity SubstractBias is
  port(
      Exp_in : in std_logic_vector(7 downto 0);
      Shift_by : in std_logic_vector(4 downto 0);
      Direction : in std_logic;--1--> left   0--->right
      Exp_Out : out std_logic_vector(7 downto 0)
    );
end SubstractBias;
architecture SubstractBias_Arch of SubstractBias is
begin
  process(Exp_in,Shift_by,Direction)
    begin
      if(Direction ='1') then
          Exp_Out <= Exp_in-Shift_by;
      else
          Exp_Out <= Exp_in+Shift_by;
      end if ; 
  end process;
end SubstractBias_Arch;
