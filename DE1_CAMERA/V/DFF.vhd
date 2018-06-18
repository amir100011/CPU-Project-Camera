library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity DFF1 is
port(
	D ,Enable: in std_logic;
	clk: in std_logic;
	Q: out std_logic:='0'
	);
end DFF1;

architecture behavioral of DFF1 is 
	begin
	process(D,clk)
		begin
			if (rising_edge(clk)) then
				if(Enable = '1') then
						Q<=D;
					end if;
			end if;
		end process;
end behavioral;