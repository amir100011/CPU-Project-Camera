library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned;

entity FPA is
port(
	OperandA_FP,OperandB_FP :  in  std_logic_vector(31 downto 0);
	FS_in: 		               in  std_logic;
	O:						   out  std_logic_vector(31 downto 0):=(others=>'0')
);
end FPA;
architecture FPA_Arch of FPA is 

signal Exp_Sub_Sign,Sign_Tag_Comp_Sign_tag,Sign_Computation_Sr,Sign_Computation_Sub,Leading_Zeros_direction : std_logic;
signal Exp_Sub_Diff,Exp_Sub_Exp_Max ,SubstractBias_Exp_Out: std_logic_vector(7 downto 0);
signal Swap_Out1,Swap_Out2 : std_logic_vector(23 downto 0);
signal ADD_SUB_O : std_logic_vector(24 downto 0);
signal Leading_Zeros_M_z : std_logic_vector(4 downto 0);
component Exp_Sub is
	port(
	E1,E2 : in std_logic_vector(7 downto 0);
	Sign : out std_logic:='0';
	Exp_Diff,Exp_Max : out std_logic_vector(7 downto 0)
);
end component;
component Swap is
port(
	f1,f2 : in std_logic_vector(23 downto 0);
	Diff : in std_logic_vector(7 downto 0);
	sign : in std_logic;
	Out1,Out2 : out std_logic_vector(23 downto 0)
);
end component;
component Sign_Computation is
	port(
	S1,S2,FS,sign_tag,sign: in std_logic;
	Sr,Sub: out std_logic
	);
end component;

component Sign_Tag_Comp is
	port(
	Swap_f1,Swap_f2 : in std_logic_vector(23 downto 0);
	sign_tag : out std_logic:='0'
	);
end component;

component ADD_SUB is
	port(
	Mf1,Mf2 : in std_logic_vector( 23 downto 0);
	Sub : in std_logic;
	O : out std_logic_vector ( 24 downto 0)
);
end component;

component Leading_Zeros is
port(
	Input : in std_logic_vector(24 downto 0):=(others=>'0');
	M_z : out std_logic_vector(4 downto 0):=(others=>'0');
	direction: out std_logic := '0'
);
end component;
component Normalize_and_Round is
port(
	Input : in std_logic_vector(24 downto 0):=(others=>'0');
	direction: in std_logic:='0';
	num_of_shifts: in std_logic_vector(4 downto 0):=(others=>'0');
	Output : out std_logic_vector(22 downto 0):=(others=>'0')
);
end component;
component SubstractBias is
	port(
      Exp_in : in std_logic_vector(7 downto 0);
      Shift_by : in std_logic_vector(4 downto 0);
      Direction : in std_logic;--1--> left   0--->right
      Exp_Out : out std_logic_vector(7 downto 0)
    );
end component;
begin
EXPSUB1:		Exp_Sub
		port map (E1=>OperandA_FP(30 downto 23),E2=>OperandB_FP(30 downto 23),Sign=>Exp_Sub_Sign,Exp_Diff=>Exp_Sub_Diff,Exp_Max=>Exp_Sub_Exp_Max);
SWAP1: 			Swap
		port map (f1(22 downto 0)=>OperandA_FP(22 downto 0),f1(23)=>'1',f2(22 downto 0)=>OperandB_FP(22 downto 0),f2(23)=>'1',Diff=>Exp_Sub_Diff,sign=>Exp_Sub_Sign,Out1=>Swap_Out1,Out2=>Swap_Out2);
SIGNTAG:		Sign_Tag_Comp
		port map (Swap_f1=>Swap_Out1,Swap_f2=>Swap_Out2,sign_tag=>Sign_Tag_Comp_Sign_tag);
SIGNCOMP: 		Sign_Computation
		port map (S1=>OperandA_FP(31),S2=>OperandB_FP(31),FS=>FS_in,sign_tag=>Sign_Tag_Comp_Sign_tag,sign=>Exp_Sub_Sign,Sr=>O(31),Sub=>Sign_Computation_Sub);
ADDSUB:	   	    ADD_SUB
		port map (Mf1 => Swap_Out1,Mf2 => Swap_Out2,Sub =>Sign_Computation_Sub,O => ADD_SUB_O);
LEADINGZEROS: 	Leading_Zeros
		port map (Input => ADD_SUB_O,M_z => Leading_Zeros_M_z,direction=>Leading_Zeros_direction);
SUBIAS: 		SubstractBias
		port map (Exp_in => Exp_Sub_Exp_Max,Shift_by => Leading_Zeros_M_z,Direction => Leading_Zeros_direction, Exp_Out => O(30 downto 23) );
NORMALIZEROUND: Normalize_and_Round
		port map (Input =>ADD_SUB_O,Direction=>Leading_Zeros_direction,num_of_shifts=>Leading_Zeros_M_z, Output=> O(22 downto 0) );
				
end FPA_Arch;
