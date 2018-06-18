
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Delay is generic(
N:integer :=2
);
port (
	Input,clk,En : in std_logic;
	O: out std_logic
	);
end Delay;




architecture Behavioral of Delay is

component DFF1 is
	port(
	D,Enable : in std_logic;
	clk: in std_logic;
	Q: out std_logic
	);
end component;

signal Delay_Cycles : std_logic_vector(N-1 downto 0);

begin  
O<=Delay_Cycles(N-1);
DFFARRAY:for i in 0 to N-1 generate
				DFF0:if i = 0 generate
						  DFF00:DFF1
						  port map(D=>Input,clk=>clk,Q => Delay_Cycles(0),Enable=>En );
		        		end generate DFF0;
				DFFN:if (i>0) generate
						  DFFNN:DFF1
						  port map(D=>Delay_Cycles(i-1),clk=>clk,Q=> Delay_Cycles(i),Enable=>En );
				      end generate DFFN;
		    end generate DFFARRAY;		
end Behavioral;
