library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Leading_Zeros is
port(
	Input : in std_logic_vector(24 downto 0):=(others=>'0');
	M_z : out std_logic_vector(4 downto 0):=(others=>'0');
	direction: out std_logic := '0'
);
end Leading_Zeros;
architecture Leading_Zeros_Arch of Leading_Zeros is

begin

process(Input) is 
  variable in_conv: std_logic_vector(24 downto 0):=(others=>'0');
  variable bool: integer:=0;
  begin
    in_conv := input;
    if (in_conv(24) = '1') then
      M_z<="00001";
      direction <= '0';
    elsif(in_conv(23) = '1') then
      M_z<="00000";
      direction<= '0';
    else
      find_one: for i in 1 to 22 loop
        if(in_conv(23-i)='1' and bool=0) then
          M_z<=std_logic_vector(to_unsigned(i,5));
          direction <= '1';
          bool := 1;
			 exit;
        elsif(i=23 and bool = 0) then
              M_z<="00000";
              direction<= '0';
		   else
				  M_z<="00000";
              direction<= '0';	
        end if;
      end loop find_one;
    end if;
    bool := 0;
  end process;



end Leading_Zeros_Arch;
			
		
			
	




