library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Exp_Sub is
port(
	E1,E2 : in std_logic_vector(7 downto 0);
	Sign : out std_logic:='0';
	Exp_Diff,Exp_Max : out std_logic_vector(7 downto 0)
);
end Exp_Sub;
architecture Exp_Sub_Arch of Exp_Sub is
	begin
	process(E1,E2)
	begin
		if (unsigned(E1) < unsigned(E2)) then
			Sign<='1';
			Exp_Diff <= E2-E1;
			Exp_Max<=E2;
		else
		  Sign<='0';
			Exp_Diff <= E1-E2;
			Exp_Max <= E1;
		end if;
	end process;
end Exp_Sub_Arch;