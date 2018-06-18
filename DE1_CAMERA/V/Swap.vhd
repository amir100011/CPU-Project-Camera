library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Swap is
port(
	f1,f2 : in std_logic_vector(23 downto 0):=(others=>'0');
	Diff : in std_logic_vector(7 downto 0):=(others=>'0');
	sign : in std_logic:='0';
	Out1,Out2 : out std_logic_vector(23 downto 0):=(others=>'0')
);
end Swap;
architecture Swap_Arch of Swap is
signal Swap_Out2 : std_logic_vector(23 downto 0):=(others=>'0');
begin
process(f1,f2,sign)
begin
	if(sign ='1') then
		Out1 <= f2;
		Swap_Out2  <= f1;
	else	
		Out1 <= f1;
		Swap_Out2  <= f2;
	end if;
end process;

process(Swap_Out2,Diff)
variable shiftby : integer :=0;
begin
shiftby := to_integer(unsigned(Diff));
Out2<= STD_LOGIC_VECTOR( UNSIGNED(Swap_Out2) SLL -shiftby );
end process;
end Swap_Arch;
	