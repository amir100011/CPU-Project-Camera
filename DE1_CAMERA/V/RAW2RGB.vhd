--25.5.14
--Boris Braginsky
--==========Library===========
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all; 
--use ieee.std_logic_arith.all;


entity RAW2RGB is
port(
	oRed, oGreen, oBlue: out std_logic_vector(11 downto 0); 
	oDVAL: out std_logic; 
	iX_Cont,	iY_Cont: in std_logic_vector(10 downto 0); 
	iDATA: in std_logic_vector(11 downto 0); 
	iDVAL, iCLK, iRST: in std_logic;
	--added by amir
	
	iRGB_Arbitrator: in std_logic;
	iHistogram_SW : in std_logic;
	iEntropy_SW: in std_logic
	);
end RAW2RGB; 


architecture behv of RAW2RGB is

component Line_Buffer 
port (clken, clock: in std_logic;
		shiftin: in std_logic_vector(11 downto 0); 
		taps0x, taps1x:	out std_logic_vector(11 downto 0));
end component;

component MAGIC port (	
	OEntropy: out std_logic_vector(11 downto 0); 
	iX_Cont,	iY_Cont: in std_logic_vector(10 downto 0); 
	bad_idea: in std_logic_vector(11 downto 0); --the value in GRAYSCALE of the pixel
	iDVAL, iCLK, iRST, iEntropy_SW: in std_logic);
end component MAGIC;

signal 	mDATA_0: std_logic_vector(11 downto 0);
signal	mDATA_1: std_logic_vector(11 downto 0);
signal	mDATAd_0: std_logic_vector(11 downto 0);
signal	mDATAd_1: std_logic_vector(11 downto 0);
signal	mCCD_R: std_logic_vector(11 downto 0);
signal	mCCD_G: std_logic_vector(12 downto 0);
signal	mCCD_B: std_logic_vector(11 downto 0);
signal	mDVAL:  std_logic;
signal   temp:   std_logic_vector(1 downto 0);
signal bad_idea: std_logic_vector(11 downto 0);
signal RD : std_logic;
type Histogram_Array is array  (0 to 9) of integer;
signal Histo, Histo_Out :Histogram_Array;
type Entropy is array  (0 to 1280) of std_logic_vector(11 downto 0);
type Entropy_Array is array (0 to 959) of Entropy;
signal E_1: Entropy_Array;
type Entropy_line is array  (0 to 1279) of std_logic_vector(11 downto 0);
type Entropy_Array1 is array (0 to 4) of Entropy_line;
signal E_2: Entropy_Array1;
signal Histo1, Histo_Out1 :Histogram_Array;
signal Switch : std_logic_vector(1 downto 0 );
signal ypos:integer;
signal bad_idea2: std_logic_vector(11 downto 0);
begin

u0:Line_Buffer
port map (clken=>iDVAL, clock=>iCLK, shiftin=>iDATA, taps0x=>mDATA_1, taps1x=>mDATA_0);
u1:MAGIC 
port map (iCLK=>iCLK, iRST=>iRST, bad_idea=>bad_idea, iX_Cont=>iX_Cont, iY_Cont=>iY_Cont, iDVAL=>iDVAL, OEntropy=>bad_idea2, iEntropy_SW=>iEntropy_SW);

--oRed	<=	mCCD_R;
--oGreen <=	mCCD_G(12 downto 1);
--oBlue	<=	mCCD_B;
oDVAL	<=	mDVAL;--ready to write to memory
temp <=iY_Cont(0) & iX_Cont(0);--the lsb of (x,y) pixel location?
Switch <= iRGB_Arbitrator & iHistogram_SW;

--added by amir - trail to convert into gray scale


---------------------Convert into GRAY-SCALE-------------------------
process (mCCD_R,mCCD_G,mCCD_B)
variable oGreen_copy: std_logic_vector(11 downto 0):= (others=>'0');
begin
oGreen_copy:= mCCD_G(12 downto 1);
bad_idea<= std_logic_vector(shift_right(unsigned(mCCD_R), 2)) + std_logic_vector(shift_right(unsigned(oGreen_copy), 1)) + std_logic_vector(shift_right(unsigned(mCCD_B), 3));

end process;

---------------------HistoGRAM CALC-------------------------
process(iCLK,iRST,Switch,iX_Cont,iY_Cont)
variable X,Y : integer:=0;
begin
	X:=to_integer(unsigned(iX_Cont));
	Y:=to_integer(unsigned(iY_Cont));

if rising_edge(iCLK) then
	if (iRST = '0') then
		Histo<=(0,0,0,0,0,0,0,0,0,0);
		Histo_Out<=(0,0,0,0,0,0,0,0,0,0);
		---counter:=0;
	end if;
	case Switch is
	when "10" => 
	--black and white
		oRed<=bad_idea;
		oGreen<=bad_idea;
		oBlue<=bad_idea;
		
	when "11" =>
	--Histogram
		
	 if iDVAL = '1'  then--pixel is valid for analysis--->its inn the active image section
		--counter:=counter+1;
			if unsigned(bad_idea) <=367 and  unsigned(bad_idea) >=0 then-->sort pixel by their "Grey scale"
				Histo(0) <=Histo(0)+1;
			end if;
			
			if  unsigned(bad_idea) >=368 and  unsigned(bad_idea) <=734 then
				Histo(1) <=Histo(1)+1;
			end if;
			
			if  unsigned(bad_idea) >=735 and  unsigned(bad_idea) <=1101 then
				Histo(2) <=Histo(2)+1;
			end if;
			
			if  unsigned(bad_idea) >=1102 and  unsigned(bad_idea) <=1468 then
				Histo(3) <=Histo(3)+1;
			end if;
			
			if  unsigned(bad_idea) >=1469 and  unsigned(bad_idea) <=1835 then
				Histo(4) <=Histo(4)+1;
			end if;
			
			if  unsigned(bad_idea) >=1836 and  unsigned(bad_idea) <=2202 then
				Histo(5) <=Histo(5)+1;
			end if;
			
			if  unsigned(bad_idea) >=2203 and  unsigned(bad_idea) <=2569 then
				Histo(6) <=Histo(6)+1;
			end if;
			
			if  unsigned(bad_idea) >=2570 and  unsigned(bad_idea) <=2936 then
				Histo(7) <=Histo(7)+1;
			end if;	
			
			if  unsigned(bad_idea) >=2937 and  unsigned(bad_idea) <=3303 then
				Histo(8) <=Histo(8)+1;
			end if;
			
			if  unsigned(bad_idea) >=3304 and  unsigned(bad_idea) <=3670 then
				Histo(9) <=Histo(9)+1;
			end if;
			
	elsif X = 0 and Y = 0 then 	
	   Histo_Out<=(0,0,0,0,0,0,0,0,0,0);
		Histo<=(0,0,0,0,0,0,0,0,0,0);
		--counter :=0;	
	else	
			Histo_Out(0) <=Histo(0);
			Histo_Out(1) <=Histo(1);
			Histo_Out(2) <=Histo(2);
			Histo_Out(3) <=Histo(3);
			Histo_Out(4) <=Histo(4);
			Histo_Out(5) <=Histo(5);
			Histo_Out(6) <=Histo(6);
			Histo_Out(7) <=Histo(7);
			Histo_Out(8) <=Histo(8);
			Histo_Out(9) <=Histo(9);
		
	end if;
	-- 1 Paint it white
	-- 0 Paint it black
	Y:=960 -Y;
	if unsigned(iX_Cont)>0 and unsigned(iX_Cont)<127 then
			if Histo_Out(0) > (320*Y) then
				oRed	<=(others=> '0'); 
				oGreen <=	(others=> '0');
				oBlue	<=(others=> '0');
			else
				oRed	<=(others=> '1'); 
				oGreen <=	(others=> '1');
				oBlue	<=(others=> '1');
			end if;
			
		elsif	unsigned(iX_Cont)>128 and unsigned(iX_Cont)<255 then
			if Histo_Out(1)> (320*Y) then
				oRed	<=(others=> '0'); 
				oGreen <=	(others=> '0');
				oBlue	<=(others=> '0');
			else
				oRed	<=(others=> '1'); 
				oGreen <=	(others=> '1');
				oBlue	<=(others=> '1');
			end if;
			
		elsif	unsigned(iX_Cont)>256 and unsigned(iX_Cont)<383 then
			if Histo_Out(2)> (320*Y) then
				oRed	<=(others=> '0'); 
				oGreen <=	(others=> '0');
				oBlue	<=(others=> '0');
			else
				oRed	<=(others=> '1'); 
				oGreen <=	(others=> '1');
				oBlue	<=(others=> '1');
			end if;	
			
		elsif	unsigned(iX_Cont)>384 and unsigned(iX_Cont)<511 then
			if Histo_Out(3)> (320*Y) then
				oRed	<=(others=> '0'); 
				oGreen <=	(others=> '0');
				oBlue	<=(others=> '0');
			else
				oRed	<=(others=> '1'); 
				oGreen <=	(others=> '1');
				oBlue	<=(others=> '1');
			end if;	
			
		elsif	unsigned(iX_Cont)>512 and unsigned(iX_Cont)<639 then
			if Histo_Out(4)> (320*Y) then
				oRed	<=(others=> '0'); 
				oGreen <=	(others=> '0');
				oBlue	<=(others=> '0');
			else
				oRed	<=(others=> '1'); 
				oGreen <=	(others=> '1');
				oBlue	<=(others=> '1');
			end if;
		
		elsif	unsigned(iX_Cont)>640 and unsigned(iX_Cont)<767 then
			if Histo_Out(5)> (320*Y) then
				oRed	<=(others=> '0'); 
				oGreen <=	(others=> '0');
				oBlue	<=(others=> '0');
			else
				oRed	<=(others=> '1'); 
				oGreen <=	(others=> '1');
				oBlue	<=(others=> '1');
			end if;	
			
		elsif	unsigned(iX_Cont)>768 and unsigned(iX_Cont)<895 then
			if Histo_Out(6)>(320*Y) then
				oRed	<=(others=> '0'); 
				oGreen <=	(others=> '0');
				oBlue	<=(others=> '0');
			else
				oRed	<=(others=> '1'); 
				oGreen <=	(others=> '1');
				oBlue	<=(others=> '1');
			end if;
			
		elsif	unsigned(iX_Cont)>896 and unsigned(iX_Cont)<1023 then
			if Histo_Out(7)> (320*Y) then
				oRed	<=(others=> '0'); 
				oGreen <=	(others=> '0');
				oBlue	<=(others=> '0');
			else
				oRed	<=(others=> '1'); 
				oGreen <=	(others=> '1');
				oBlue	<=(others=> '1');
			end if;
		elsif	unsigned(iX_Cont)>1024 and unsigned(iX_Cont)<1151 then
			if Histo_Out(8) >  (320*Y) then
				oRed	<=(others=> '0'); 
				oGreen <=	(others=> '0');
				oBlue	<=(others=> '0');
			else
				oRed	<=(others=> '1'); 
				oGreen <=	(others=> '1');
				oBlue	<=(others=> '1');
			end if;
		elsif	unsigned(iX_Cont)>1152 and unsigned(iX_Cont)<1279 then
			if Histo_Out(9) > (320*Y) then
				oRed	<=(others=> '0'); 
				oGreen <=	(others=> '0');
				oBlue	<=(others=> '0');
			else
				oRed	<=(others=> '1'); 
				oGreen <=	(others=> '1');
				oBlue	<=(others=> '1');
		end if;
	end if;--Close for the initial if and elsif
	when "01" =>
			oRed <= bad_idea2;
			oGreen <=  	bad_idea2;
			oBlue <= bad_idea2;
	
	when others =>
		oRed <= mCCD_R;
	   oGreen <=  	mCCD_G(12 downto 1) ;
      oBlue <= mCCD_B ;			
	end case;
end if;--close for if rising edge
end process;


---------------------END OF CHANGES-------------------------


---end of added by amir
process(iCLK, iRST)
begin
	if(iRST = '0') then 
		mCCD_R	<=	"000000000000";
		mCCD_G	<=	"0000000000000";
		mCCD_B	<=	"000000000000";
		mDATAd_0<=	"000000000000";
		mDATAd_1<=	"000000000000";
		mDVAL	<=	'0';
	else
		mDATAd_0	<=	mDATA_0;
		mDATAd_1	<=	mDATA_1;
		if (iY_Cont(0) = '1' or iX_Cont(0) = '1') then 
			mDVAL		<=	'0';
		else
			mDVAL    <=	iDVAL;
		end if; 
		if(temp = "10") then
			mCCD_R	<=	mDATA_0;
			mCCD_G	<=	('0' & mDATAd_0) + ('0'&mDATA_1);
			mCCD_B	<=	mDATAd_1; 
		elsif(temp ="11") then--if (x,y) are odd?!?!?!?
			mCCD_R	<=	mDATAd_0;
			mCCD_G	<=	('0'&mDATA_0)+('0'&mDATAd_1);
			mCCD_B	<=	mDATA_1;
		elsif(temp = "00") then--if (x,y) are even?!?!?!?
			mCCD_R	<=	mDATA_1;
			mCCD_G	<=	('0'&mDATA_0)+('0'&mDATAd_1);
			mCCD_B	<=	mDATAd_0;
		elsif(temp = "01") then
			mCCD_R	<=	mDATAd_1;
			mCCD_G	<=	('0'&mDATAd_0)+('0'&mDATA_1);
			mCCD_B	<=	mDATA_0;
		end if;
	end if;
end process;

end behv;