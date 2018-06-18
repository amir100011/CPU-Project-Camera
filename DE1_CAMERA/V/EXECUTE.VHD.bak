--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  Execute IS
	PORT(	Read_data_1 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Function_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALUOp 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ALUSrc 			: IN 	STD_LOGIC;
		--	Zero 				: OUT	STD_LOGIC;
			ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			--Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		--	PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			clock, reset	: IN 	STD_LOGIC
			
			);
END Execute;

ARCHITECTURE behavior OF Execute IS
SIGNAL Ainput, Binput 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
signal fmp_res,fpa_res  	: std_logic_vector(31 downto 0);
--SIGNAL Branch_Add 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL ALU_ctl				: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
signal fpu_slt  : std_logic;
signal fpu_helper : std_logic;
component FPM is port(
    OperandA:           in std_logic_vector (31 downto 0):=(others=>'0');
    OperandB:           in std_logic_vector (31 downto 0):=(others=>'0');
    enable:             in std_logic:='0';
    AXB_Float:          out std_logic_vector (31 downto 0):=(others=>'0')
    );
end component;

component FPA is port(
	OperandA_FP,OperandB_FP :  in  std_logic_vector(31 downto 0);
	FS_in: 		               in  std_logic;
	O:						   out  std_logic_vector(31 downto 0):=(others=>'0')
);
end component;

BEGIN
FPM_CONS:FPM
		port map(OperandA=>Ainput,OperandB=>Binput,enable=>'1',AXB_Float=>fmp_res);
FPA_CONS:FPA
		port map(OperandA_FP=>Ainput,OperandB_FP=>Binput,FS_in=>'0',O=>fpa_res);
	--fmp_en <= '1' WHEN ALU_ctl="100" ELSE '0';
	Ainput <= Read_data_1;
						-- ALU input mux
	Binput <= Read_data_2 
		WHEN ( ALUSrc = '0' ) 
  		ELSE  Sign_extend( 31 DOWNTO 0 );
						-- Generate ALU control bits
	ALU_ctl( 0 ) <= ( Function_opcode( 0 ) OR Function_opcode( 3 ) ) AND ALUOp(1 );
	ALU_ctl( 1 ) <= ( NOT Function_opcode( 2 ) ) OR (NOT ALUOp( 1 ) );
	ALU_ctl( 2 ) <= ( Function_opcode( 1 ) AND ALUOp( 1 )) OR ALUOp( 0 );--ALUop =1 --> RFORMAT
						-- Generate Zero Flag
	--Zero <= '1' 
		--WHEN ( ALU_output_mux( 31 DOWNTO 0 ) = X"00000000"  )
		--ELSE '0';    
						-- Select ALU output        
     ALU_Result <= X"0000000" & B"000"  & fpu_slt 
							WHEN     ALU_ctl = "111" 
							ELSE fpa_res   WHEN ALU_ctl = "101"
							ELSE fmp_res	 WHEN ALU_ctl = "100"
							ELSE  	ALU_output_mux( 31 DOWNTO 0 );
		fpu_slt <=  '1' WHEN ( (Ainput(31) = '1' and Binput(31) = '0') 
								or ( (Ainput(31) = '0' and Binput(31) = '0') and ( unsigned(Ainput(30 downto 23)) < unsigned(Binput(30 downto 23)) ) )
							   or ( (Ainput(31) = '0' and Binput(31) = '0') and (Ainput(30 downto 23) = Binput(30 downto 23)) and (unsigned(Ainput(22 downto 0)) < unsigned(Binput(22 downto 0))) )
						 	   or ( (Ainput(31)= '1' and Binput(31)='1' ) and (unsigned(Ainput(30 downto 23)) > unsigned(Binput(30 downto 23))) )
								or ( (Ainput(31)= '1' and Binput(31)='1' ) and (Ainput(30 downto 23) = Binput(30 downto 23)) and ( unsigned(Ainput(22 downto 0)) > unsigned(Binput(22 downto 0))) )) 
							ELSE	'0';
	--	fpu_helper <= '1' WHEN ( Ainput(31)=Binput(31) and ( (Ainput(30 downto 23) > Binput(30 downto 23)) or (Ainput(30 downto 23) = Binput(30 downto 23) and Ainput(22 downto 0) > Binput(22 downto 0))  ) )
				--			ELSE '0';
						-- Adder to compute Branch Address
	   --Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
		--Add_result 	<= Branch_Add( 7 DOWNTO 0 );

PROCESS ( ALU_ctl, Ainput, Binput )
	BEGIN
					-- Select ALU operation
 	CASE ALU_ctl IS
						-- ALU performs ALUresult = A_input AND B_input
		WHEN "000" 	=>	ALU_output_mux 	<= Ainput AND Binput; 
						-- ALU performs ALUresult = A_input OR B_input
     	WHEN "001" 	=>	ALU_output_mux 	<= Ainput OR Binput;
						-- ALU performs ALUresult = A_input + B_input
	 	WHEN "010" 	=>	ALU_output_mux 	<= Ainput + Binput;
						-- ALU performs ?
 	 	WHEN "011" 	=>	ALU_output_mux    <= X"00000000";
						-- ALU performs ?
 	 	--WHEN "100" 	=>	ALU_output_mux 	<= fmp_res;--FPM--xor
		
 	-- 	WHEN "101" 	=>	ALU_output_mux 	<= fpa_res;--FPA--nor
						
 	 	WHEN "110" 	=>	ALU_output_mux 	<= Ainput - Binput;
						-- ALU performs SLT
  	 --	WHEN "111" 	=>	ALU_output_mux 	<= fpu_slt ;---slt
 	 	WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
  	END CASE;
  END PROCESS;
END behavior;

