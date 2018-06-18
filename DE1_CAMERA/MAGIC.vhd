--15.6.18
--Amir Tsur
--==========Library===========
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all; 
--use ieee.std_logic_arith.all;

Entity MAGIC is port(

	OEntropy: out std_logic_vector(11 downto 0); 
	iX_Cont,	iY_Cont: in std_logic_vector(10 downto 0); 
	bad_idea: in std_logic_vector(11 downto 0); --the value in GRAYSCALE of the pixel
	iDVAL, iCLK, iRST, iEntropy_SW: in std_logic
);
end MAGIC;

architecture behv of MAGIC is

type Lookup_table is array (0 to 25) of std_logic_vector (11 downto 0);
signal lookup :Lookup_table;
--type Lookup_table_int is array (0 to 25) of integer;
--signal lookup_int :Lookup_table_int;
Type Five_on_five is Array (0 to 4, 0 to 4) of integer;
Type Entropy_prob is Array (0 to 24) of integer;
signal Rule_of_five,Rule_of_five1: Five_on_five;
signal taps0x,taps1x,taps2x,taps3x,taps4x,shiftout: std_logic_vector (11 downto 0):=(others=>'0');


component Cube_Buffer IS
	PORT
	(
		clken		: IN STD_LOGIC  := '1';
		clock		: IN STD_LOGIC ;
		shiftin		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		shiftout		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		taps0x		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		taps1x		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		taps2x		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		taps3x		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		taps4x		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
END component Cube_Buffer;

signal Target_Pixel_Value_DOR: integer:=0;
signal Pixel0_Histo_Row, Pixel1_Histo_Row : integer := 0;
signal	Pixel2_Histo_Row, Pixel3_Histo_Row : integer := 0;
signal	Pixel4_Histo_Row: integer := 0;


begin

--PORT MAP FOR CUBE_BUFFER
Fill_UP: Cube_Buffer port map(clken=>iDVAL, 
										clock=>iCLK, 
										shiftin=>bad_idea,
										shiftout=> shiftout, 
										taps0x=>taps0x, 
										taps1x=>taps1x,
										taps2x=>taps2x,
										taps3x=>taps3x,
										taps4x=>taps4x
										);



process (iCLK, iDVAL,iEntropy_SW)
--variable X,Y: integer:=0;



begin

	--X:=to_integer(unsigned(iX_Cont));
	--Y:=to_integer(unsigned(iY_Cont));

--Histogram calc for WHOLE COULMNE of the cube 
if (rising_edge (iCLK) AND iDVAL = '1') then

		Hist_CALC: for i in 0 to 11 loop
								if taps0x >=341*i and taps0x <341*(i+1) then
									Pixel0_Histo_Row<=i;
								end if;
								if taps1x >=341*i and taps1x <341*(i+1) then
									Pixel1_Histo_Row<=i;
								end if;
								if taps2x >=341*i and taps2x <341*(i+1) then
									Pixel2_Histo_Row<=i;
								end if;
								if taps3x >=341*i and taps3x <341*(i+1) then
									Pixel3_Histo_Row<=i;
								end if;
								if taps4x >=341*i and taps4x <341*(i+1) then
									Pixel4_Histo_Row<=i;
								end if;
							end loop;

---END OF HISTO CALC		

			
--	if (iEntropy_SW = '0') then
			OEntropy <=  std_logic_vector(to_unsigned(Target_Pixel_Value_DOR, OEntropy'length));
--	else
--		 OEntropy <= std_logic_vector(to_unsigned(
--		 Rule_of_five1(0,0)+Rule_of_five1(0,1)+Rule_of_five1(0,2)+Rule_of_five1(0,3)+Rule_of_five1(0,4)+
--		 Rule_of_five1(1,0)+Rule_of_five1(1,1)+Rule_of_five1(1,2)+Rule_of_five1(1,3)+Rule_of_five1(1,4)+
--		 Rule_of_five1(2,0)+Rule_of_five1(2,1)+Rule_of_five1(2,2)+Rule_of_five1(2,3)+Rule_of_five1(2,4)+
--		 Rule_of_five1(3,0)+Rule_of_five1(3,1)+Rule_of_five1(3,2)+Rule_of_five1(3,3)+Rule_of_five1(3,4)+ 
--		 Rule_of_five1(4,0)+Rule_of_five1(4,1)+Rule_of_five1(4,2)+Rule_of_five1(4,3)+Rule_of_five1(4,4)
--		 ,12))-X"010";  
--		 end if;
					  	 
		
	end if;
end process;

process(Pixel4_Histo_Row,Pixel3_Histo_Row,Pixel2_Histo_Row,Pixel1_Histo_Row,Pixel0_Histo_Row)	is

begin
		
		
--- Prep for next Window Iteration
				
--			for i in 0 to 4 loop
--				Rule_of_five(i,4)<=Rule_of_five(i,3);	
--				Rule_of_five(i,3)<=Rule_of_five(i,2);
--				Rule_of_five(i,2)<=Rule_of_five(i,1);	
--				Rule_of_five(i,1)<=Rule_of_five(i,0);
--			end loop;	
		
			Rule_of_five(0,0)<=Pixel4_Histo_Row;	
			Rule_of_five(1,0)<=Pixel3_Histo_Row;
			Rule_of_five(2,0)<=Pixel2_Histo_Row;	
			Rule_of_five(3,0)<=Pixel1_Histo_Row;
			Rule_of_five(4,0)<=Pixel0_Histo_Row;
			
			Rule_of_five(0,1)<=Rule_of_five(0,0);	
			Rule_of_five(1,1)<=Rule_of_five(1,0);
			Rule_of_five(2,1)<=Rule_of_five(2,0);	
			Rule_of_five(3,1)<=Rule_of_five(3,0);
			Rule_of_five(4,1)<=Rule_of_five(4,0);
			
			Rule_of_five(0,2)<=Rule_of_five(0,1);	
			Rule_of_five(1,2)<=Rule_of_five(1,1);
			Rule_of_five(2,2)<=Rule_of_five(2,1);	
			Rule_of_five(3,2)<=Rule_of_five(3,1);
			Rule_of_five(4,2)<=Rule_of_five(4,1);
			
			Rule_of_five(0,3)<=Rule_of_five(0,2);	
			Rule_of_five(1,3)<=Rule_of_five(1,2);
			Rule_of_five(2,3)<=Rule_of_five(2,2);	
			Rule_of_five(3,3)<=Rule_of_five(3,2);
			Rule_of_five(4,3)<=Rule_of_five(4,2);
			
			Rule_of_five(0,4)<=Rule_of_five(0,3);	
			Rule_of_five(1,4)<=Rule_of_five(1,3);
			Rule_of_five(2,4)<=Rule_of_five(2,3);	
			Rule_of_five(3,4)<=Rule_of_five(3,3);
			Rule_of_five(4,4)<=Rule_of_five(4,3);
		
end process;
		
--END OF Prep for next Window Iteration		
	
	--if ( X >= 2 AND  X < 1278) and (Y >= 2 AND  Y < 958) then	
	
	
	
	
	
--GIGO SKIPPING
		
process (iCLK,iDVAL,iEntropy_SW)

--variable X,Y: integer:=0;	
variable Target_Pixel_Value,Target_Pixel_Counter,Target_Pixel_Value_DOR1: integer := 0;
variable prob : Entropy_prob;

	begin
	
if (falling_edge (iCLK) AND iDVAL = '1') then			
	

	--X:=to_integer(unsigned(iX_Cont));
	--Y:=to_integer(unsigned(iY_Cont));
	Target_Pixel_Value_DOR1:=Target_Pixel_Value_DOR;

	
--if ( X >= 2 AND  X < 1278) and (Y >= 2 AND  Y < 958) then		

--if (iEntropy_SW = '1') then
--
--	for j in 0 to 4 loop			
--		for i in 0 to 4 loop	
--			Target_Pixel_Value:=(Rule_of_five(j,i));
--			for k in 0 to 4 loop			
--				for h in 0 to 4 loop	
--					if (Rule_of_five(k,h) = Target_Pixel_Value) then
--						Target_Pixel_Counter:= Target_Pixel_Counter + 1;
--					end if;
--				end loop;
--			end loop;
--							--Rule_of_five1(j,i)<=to_integer(unsigned(lookup(Target_Pixel_Counter + 26)));
--							Rule_of_five1(j,i)<= lookup_int(Target_Pixel_Counter);
--							Target_Pixel_Counter:= 0;
--					end loop;
--			end loop;	
--			
--		
--else

for i in 0 to 24 loop
				prob(i) := 0;
			end loop;
		
			for j in 0 to 4 loop	--calc prob for current-window
						for i in 0 to 4 loop
						case (Rule_of_five(j,i)) is--(col,row)
							when 0 => 		prob(0):=prob(0) + 1;
							when 1 => 		prob(1):= prob(1) +1;
							when 2 => 		prob(2):= prob(2) +1;
							when 3 => 		prob(3):= prob(3) +1;
							when 4 => 		prob(4):= prob(4) +1;
							when 5 => 		prob(5):= prob(5) +1;
							when 6 => 		prob(6):= prob(6) +1;
							when 7 => 		prob(7):= prob(7) +1;
							when 8 => 		prob(8):= prob(8) +1;
							when 9 => 		prob(9):= prob(9) +1;
							when 10 => 		prob(10):= prob(10) +1;
							when 11 => 		prob(11):= prob(11) +1;
							when 12 => 		prob(12):= prob(12) +1;
							when 13 => 		prob(13):= prob(13) +1;
							when 14 => 		prob(14):= prob(14) +1;
							when 15 => 		prob(15):= prob(15) +1;
							when 16 => 		prob(16):= prob(16) +1;
							when 17 => 		prob(17):= prob(17) +1;
							when 18 => 		prob(18):= prob(18) +1;
							when 19 => 		prob(19):= prob(19) +1;
							when 20 => 		prob(20):= prob(20) +1;
							when 21 => 		prob(21):= prob(21) +1;
							when 22 => 		prob(22):= prob(22) +1;
							when 23 => 		prob(23):= prob(23) +1;
							when 24 => 		prob(24):= prob(24) +1;
							when others => prob(24):= prob(24) +1;
							end case;
						end loop;
					end loop;
				Target_Pixel_Value_DOR1:=0;		
				for i in 0 to 24 loop
					Target_Pixel_Value_DOR1 := Target_Pixel_Value_DOR1 + (to_integer(unsigned(lookup(prob(i)))));
					--Target_Pixel_Value_DOR1 := Target_Pixel_Value_DOR1 + lookup_int(prob(i));
				end loop;
				Target_Pixel_Value_DOR<=Target_Pixel_Value_DOR1;
end if;
--end if;
end process;
	




lookup(0) <= X"000";--230;
lookup(1) <= X"0E3";--230;   1280(log(p))*(i/25) when the pool is 25 ---> 5x5 window
lookup(2) <= X"142";--370;
lookup(3) <= X"180";--400;
lookup(4) <= X"1D6";--470;
lookup(5) <= X"208";--520;
lookup(6) <= X"230";--560;
lookup(7) <= X"244";--580;
lookup(8) <= X"258";--600;
lookup(9) <= X"262";--610;
lookup(10) <= X"294";--660;
lookup(11) <= X"28A";--650;
lookup(12) <= X"26C";--620;
lookup(13) <= X"226";--550;
lookup(14) <= X"208";--520;
lookup(15) <= X"1EA";--490;
lookup(16) <= X"1C2";--450;
lookup(17) <= X"1AE";--430;
lookup(18) <= X"17C";--380;
lookup(19) <= X"140";--320;
lookup(20) <= X"104";--260;
lookup(21) <= X"062";--210;
lookup(22) <= X"042";--130;
lookup(23) <= X"026";--70;
lookup(24) <= X"01E";--30;
lookup(25) <= X"000";--0;
--
--lookup(26) <= X"000";--0;
--lookup(27) <= X"053";--230;   1280(log(p))*(i/25) when the pool is 25 ---> 5x5 window
--lookup(28) <= X"072";--370;
--lookup(29) <= X"090";--400;
--lookup(30) <= X"0D6";--470;
--lookup(31) <= X"108";--520;
--lookup(32) <= X"130";--560;
--lookup(33) <= X"144";--580;
--lookup(34) <= X"158";--600;
--lookup(35) <= X"162";--610;
--lookup(36) <= X"194";--660;
--lookup(37) <= X"18A";--650;
--lookup(38) <= X"16C";--620;
--lookup(39) <= X"126";--550;
--lookup(40) <= X"008";--520;
--lookup(41) <= X"0EA";--490;
--lookup(42) <= X"0C2";--450;
--lookup(43) <= X"0AE";--430;
--lookup(44) <= X"07C";--380;
--lookup(45) <= X"040";--320;
--lookup(46) <= X"0A4";--260;
--lookup(47) <= X"062";--210;
--lookup(48) <= X"042";--130;
--lookup(49) <= X"026";--70;
--lookup(50) <= X"00E";--30;
--lookup(51) <= X"000";--0;



--lookup_int(0) <= 0;
--lookup_int(1) <= 185;
--lookup_int(2) <= 291;
--lookup_int(3) <= 367;
--lookup_int(4) <= 423;
--lookup_int(5) <= 464;
--lookup_int(6) <= 494;
--lookup_int(7) <= 514;
--lookup_int(8) <= 526;
--lookup_int(9) <= 530;
--lookup_int(10) <= 528;
--lookup_int(11) <= 521;
--lookup_int(12) <= 507;
--lookup_int(13) <= 490;
--lookup_int(14) <= 468;
--lookup_int(15) <= 442;
--lookup_int(16) <= 412;
--lookup_int(17) <= 378;
--lookup_int(18) <= 341;
--lookup_int(19) <= 300;
--lookup_int(20) <= 257;
--lookup_int(21) <= 211;
--lookup_int(22) <= 162;
--lookup_int(23) <= 110;
--lookup_int(24) <= 56;
--lookup_int(25) <= 0;

end behv;

