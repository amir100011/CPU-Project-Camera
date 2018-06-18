library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity FPU_conv is
port(
	Input : in std_logic_vector( 7 downto 0);
	Converted : out std_logic_vector( 31 downto 0):=(others=>'0')
);
end FPU_conv;
architecture FPU_conv_Arch of FPU_conv is
begin
process(Input)
variable index : integer:= -1;
variable input_trans : std_logic_vector(7 downto 0);
variable sign : std_logic;
begin
	input_trans := Input;
	sign:= '0';
	Converted<=(others=>'0');
	if(Input(7) = '1') then
		input_trans := not(Input) + 1;
		sign := '1';
	end if;
	
	for I in 0 to 6 loop
		if(input_trans(6-I) = '1') then
			index := 6-I;
			exit;
		end if;
	end loop;
	case Index is
		when 6 => 
			Converted(31)<=sign;
			Converted(30 downto 23)<=x"83";
			Converted(22 downto 19)<= input_trans(5 downto 2);
			Converted(18 downto 17) <= input_trans(1 downto 0);
		when 5 =>
			Converted(31)<=sign;
			Converted(30 downto 23)<=X"82";
			Converted(22 downto 20) <= input_trans(4 downto 2);
			Converted(19 downto 18) <= input_trans(1 downto 0);
		when 4 =>
			Converted(31)<=sign;
			Converted(30 downto 23) <=X"81";
			Converted(22 downto 21) <= input_trans(3 downto 2);
			Converted(20 downto 19) <= input_trans(1 downto 0);
		when 3 =>
			Converted(31)<=sign;
			Converted(30 downto 23) <= X"80";
			Converted(22)<=input_trans(2);
			Converted(21 downto 20) <= input_trans(1 downto 0);
		when 2 =>
			Converted(31)<=sign;
			Converted(30 downto  23) <= X"7F";
			Converted(22 downto 21)<= input_trans(1 downto 0);
		when 1 =>
			Converted(31)<=sign;
			Converted(30 downto 23) <= X"7E";
			Converted(22)<=input_trans(0);
		when 0 => 
			Converted(31)<=sign;
			Converted(30 downto 23) <= X"7D";
		when others=>
			Converted<=X"00000000";
		end case;
		Index :=-1;
end process;
end FPU_conv_Arch;
			
		
			
	

