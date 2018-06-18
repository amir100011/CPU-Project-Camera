
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Sign_Tag_Comp is
port(
	Swap_f1,Swap_f2 : in std_logic_vector(23 downto 0):=(OTHERS=>'0');
	sign_tag : out std_logic:='0'
	);
end Sign_Tag_Comp;
architecture Sign_Tag_Comp_Arch of Sign_Tag_Comp is
	begin
	process(Swap_f1,Swap_f2)
	begin
		if(Swap_f2 > Swap_f1) then
			sign_tag <='1';
		else
			sign_tag <='0';
		end if;
	end process;
	end Sign_Tag_Comp_Arch;
