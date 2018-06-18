library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Delay_TB is
end Delay_TB;

architecture rtl of Delay_TB  is
  component Delay is generic(
    N: integer :=1
    );
    port (
	   I,clk : in std_logic;
	   O: out std_logic
	   );
	end component;
	signal Input,clock,Out1 : std_logic;
	begin
	  
	DELAY: Delay 
	       generic map (N=>2)
	       port map (I=>Input,clk=>clock,O=>Out1);
	TB: process
	    begin
	    Input <= '1';
	    clock <= '0';
	    wait for 100 ps;
	    clock <= '1';--first clock
	    wait for 100 ps;
	    Input <= '0';
	    clock <= '0';
	    wait for 100 ps;
	    clock <= '1';--second clock
	    wait for 100 ps;
	    Input <= '0';
	    clock <= '0';
	    wait for 100 ps;
	    clock <= '1';
	    wait for 100 ps;
	    Input <= '0';
	    clock <= '0';
	    wait for 100 ps;
	    clock <= '1';
	    wait for 100 ps;
	  end process TB;
end rtl;


