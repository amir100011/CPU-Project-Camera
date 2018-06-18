library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity SEG_TO_HEX is
port(
	Seg_in		:	in std_logic_vector(31 downto 0);
	clk,Sw			:  in std_logic;
	HEX1,HEX2,HEX3,HEX4 :            out std_logic_vector(6 downto 0):=(others=>'1')
	);
end entity;

architecture rtl of SEG_TO_HEX is
signal LoDigits,HiDigits : std_logic_vector(7 downto 0);
begin

LoDigits <= Seg_in(7 downto 0) WHEN SW ='0' ELSE Seg_in(23 downto 16);
HiDigits <= Seg_in(15 downto 8) WHEN SW ='0' ELSE Seg_in(31 downto 24);

process(clk,Seg_in,LoDigits,HiDigits) is
begin
if(rising_edge(clk)) then

case LoDigits(3 downto 0) is
		        when X"0" => HEX1<=(6=>'1',others=>'0');
		        when X"1" =>HEX1<=(1=>'0',2=>'0',others=>'1');
		        when X"2" =>HEX1<=(1=>'0',0=>'0',6=>'0',4=>'0',3=>'0',others=>'1');
		        when X"3" =>HEX1<=(6=>'0',0=>'0',1=>'0',2=>'0',3=>'0',others=>'1');
		        when X"4" =>HEX1<=(5=>'0',6=>'0',1=>'0',2=>'0',others=>'1');
		        when X"5" =>HEX1<=(0=>'0',5=>'0',6=>'0',2=>'0',3=>'0',others=>'1');
		        when X"6" => HEX1<=(1=>'1',others=>'0');
		        when X"7" =>HEX1<=(0=>'0',1=>'0',2=>'0',others=>'1');
		        when X"8" =>HEX1<=(others=>'0');
		        when X"9" =>HEX1<=(4=>'1',3=>'1',others=>'0');
		        when X"A" =>HEX1<=(3=>'1',others=>'0');
		        when X"B" =>HEX1<=(1=>'1',0=>'1',others=>'0');
		        when X"C" =>HEX1<=(6=>'1',1=>'1',2=>'1',others=>'0');
		        when X"D" =>HEX1<=(5=>'1',0=>'1',others=>'0');
		        when X"E" =>HEX1<=(1=>'1',2=>'1',others=>'0');
		        when X"F" =>HEX1<=(1=>'1',2=>'1',3=>'1',others=>'0');
		        when others=>HEX1<=(others=>'1');      
		       end case;
		       case LoDigits(7 downto 4) is
		        when X"0" => HEX2<=(6=>'1',others=>'0');
		        when X"1" =>HEX2<=(1=>'0',2=>'0',others=>'1');
		        when X"2" =>HEX2<=(1=>'0',0=>'0',6=>'0',4=>'0',3=>'0',others=>'1');
		        when X"3" => HEX2<=(6=>'0',0=>'0',1=>'0',2=>'0',3=>'0',others=>'1');
		        when X"4" =>HEX2<=(5=>'0',6=>'0',1=>'0',2=>'0',others=>'1');
		        when X"5" =>HEX2<=(0=>'0',5=>'0',6=>'0',2=>'0',3=>'0',others=>'1');
		        when X"6" => HEX2<=(1=>'1',2=>'1',others=>'0');
		        when X"7" =>HEX2<=(0=>'0',1=>'0',2=>'0',others=>'1');
		        when X"8" =>HEX2<=(others=>'0');
		        when X"9" => HEX2<=(4=>'1',3=>'1',others=>'0');
		        when X"A" =>HEX2<=(3=>'1',others=>'0');
		        when X"B" =>HEX2<=(1=>'1',others=>'0');
		        when X"C" => HEX2<=(6=>'1',1=>'1',2=>'1',others=>'0');
		        when X"D" =>HEX2<=(5=>'1',0=>'1',others=>'0');
		        when X"E" =>HEX2<=(1=>'1',2=>'1',others=>'0');
		        when X"F" =>HEX2<=(1=>'1',2=>'1',3=>'1',others=>'0');
		        when others=>HEX2<=(others=>'1');         
		       end case;
		       
		       
		       --TWO LAST DIGITS AT SEVEN SEGMENT SCREEN
		       
		        case HiDigits(3 downto 0) is
				  when X"0" => HEX3<=(6=>'1',others=>'0');
		        when X"1" =>HEX3<=(1=>'0',2=>'0',others=>'1');
		        when X"2" =>HEX3<=(1=>'0',0=>'0',6=>'0',4=>'0',3=>'0',others=>'1');
		        when X"3" =>HEX3<=(6=>'0',0=>'0',1=>'0',2=>'0',3=>'0',others=>'1');
		        when X"4" =>HEX3<=(5=>'0',6=>'0',1=>'0',2=>'0',others=>'1');
		        when X"5" =>HEX3<=(0=>'0',5=>'0',6=>'0',2=>'0',3=>'0',others=>'1');
		        when X"6" => HEX3<=(1=>'1',2=>'1',others=>'0');
		        when X"7" =>HEX3<=(0=>'0',1=>'0',2=>'0',others=>'1');
		        when X"8" =>HEX3<=(others=>'0');
		        when X"9" =>HEX3<=(4=>'1',3=>'1',others=>'0');
		        when X"A" =>HEX3<=(3=>'1',others=>'0');
		        when X"B" =>HEX3<=(1=>'1',others=>'0');
		        when X"C" =>HEX3<=(6=>'1',1=>'1',2=>'1',others=>'0');
		        when X"D" =>HEX3<=(5=>'1',0=>'1',others=>'0');
		        when X"E" =>HEX3<=(1=>'1',2=>'1',others=>'0');
		        when X"F" =>HEX3<=(1=>'1',2=>'1',3=>'1',others=>'0');
		        when others=>HEX3<=(others=>'1');      
		       end case;
		       case HiDigits(7 downto 4) is
		        when X"0" => HEX4<=(6=>'1',others=>'0');
		        when X"1" =>HEX4<=(1=>'0',2=>'0',others=>'1');
		        when X"2" =>HEX4<=(1=>'0',0=>'0',6=>'0',4=>'0',3=>'0',others=>'1');
		        when X"3" => HEX4<=(6=>'0',0=>'0',1=>'0',2=>'0',3=>'0',others=>'1');
		        when X"4" =>HEX4<=(5=>'0',6=>'0',1=>'0',2=>'0',others=>'1');
		        when X"5" =>HEX4<=(0=>'0',5=>'0',6=>'0',2=>'0',3=>'0',others=>'1');
		        when X"6" => HEX4<=(1=>'1',2=>'1',others=>'0');
		        when X"7" =>HEX4<=(0=>'0',1=>'0',2=>'0',others=>'1');
		        when X"8" =>HEX4<=(others=>'0');
		        when X"9" => HEX4<=(4=>'1',3=>'1',others=>'0');
		        when X"A" =>HEX4<=(3=>'1',others=>'0');
		        when X"B" =>HEX4<=(1=>'1',others=>'0');
		        when X"C" => HEX4<=(6=>'1',1=>'1',2=>'1',others=>'0');
		        when X"D" =>HEX4<=(5=>'1',0=>'1',others=>'0');
		        when X"E" =>HEX4<=(1=>'1',2=>'1',others=>'0');
		        when X"F" =>HEX4<=(1=>'1',2=>'1',3=>'1',others=>'0');
		        when others=>HEX4<=(others=>'1');
				  end case;                        
				
			end if;
						 
			 
			end process;
END rtl;	