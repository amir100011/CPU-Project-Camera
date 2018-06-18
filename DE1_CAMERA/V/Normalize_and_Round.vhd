library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Normalize_and_Round is
port(
	Input : in std_logic_vector(24 downto 0):=(others=>'0');
	direction: in std_logic:='0';
	num_of_shifts: in std_logic_vector(4 downto 0):=(others=>'0');
	Output : out std_logic_vector(22 downto 0):=(others=>'0')
);
end Normalize_and_Round;
architecture Normalize_and_Round_Arch of Normalize_and_Round is
signal Output_trans: std_logic_vector(24 downto 0):=(others=>'0');
begin

process(Input,direction,num_of_shifts) is 
  variable num_of_shifts_conv: integer:=0;
  
  begin
    num_of_shifts_conv:=to_integer(signed(num_of_shifts));
    
    if(direction = '0') then
        Output_trans <= std_logic_vector(UNSIGNED(Input) SLL -num_of_shifts_conv);
      else
        Output_trans <= std_logic_vector(UNSIGNED(Input) SLL num_of_shifts_conv);
  end if;
  end process;
  
  Output<=Output_trans(22 downto 0);


end Normalize_and_Round_Arch;
			
		
			
	






