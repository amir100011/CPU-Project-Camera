library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ADD_SUB is
port(
	Mf1,Mf2 : in std_logic_vector( 23 downto 0):=(OTHERS=>'0');
	Sub : in std_logic:='0';
	O : out std_logic_vector ( 24 downto 0):=(OTHERS=>'0')
);
end ADD_SUB;
architecture ADD_SUB_Arch of ADD_SUB is
signal Mf1_trans ,Mf2_trans : std_logic_vector( 24 downto 0):=(others => '0');
begin
Mf1_trans(23 downto 0) <= Mf1;
Mf2_trans(23 downto 0) <= Mf2;

process(Mf1_trans,Mf2_trans,Sub)
	begin
		if( Sub = '1') then
			O <= Mf1_trans - Mf2_trans;
		else
			O <= Mf1_trans + Mf2_trans;
		end if;
	end process;
end ADD_SUB_Arch;
