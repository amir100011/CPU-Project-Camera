						--  Idecode module (implements the register file for
LIBRARY IEEE; 			-- the MIPS computer)
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
	  PORT(	read_data_1	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			PC_plus_4 	: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 ); 
			ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 	: IN 	STD_LOGIC;
			MemtoReg 	: IN 	STD_LOGIC;
			RegDst 		: IN 	STD_LOGIC;
			Sign_extend : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			clock,reset	: IN 	STD_LOGIC ;
			write_register_address : out std_logic_vector(4 downto 0);
			--ADDED
			Zero_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			Zero 			: OUT	STD_LOGIC;
			WREG : in std_logic_vector (4 downto 0);
			Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			ZEROOp 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			Seg					: out std_logic_vector(31 downto 0)--DOR
			);
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array				: register_file;
	SIGNAL write_data					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	--SIGNAL write_register_address : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_1		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_0		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	signal sign_ex ,data_for_zero_1,data_for_zero_2,ZERO_output_mux	: std_logic_vector(31 downto 0); 		
	signal Branch_Add 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	signal ZERO_ctl				   : STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	
	

BEGIN
		read_register_1_address 	<= Instruction( 25 DOWNTO 21 );
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 );
   	write_register_address_1	<= Instruction( 15 DOWNTO 11 );
   	write_register_address_0  	<= Instruction( 20 DOWNTO 16 );
   	Instruction_immediate_value <= Instruction( 15 DOWNTO 0 );
	Seg	<=	register_array(8);
					-- Read Register 1 Operation
	data_for_zero_1 <= register_array( 
			      CONV_INTEGER( read_register_1_address ) );
	read_data_1<=data_for_zero_1;
					-- Read Register 2 Operation		 
	data_for_zero_2 <= register_array( 
			      CONV_INTEGER( read_register_2_address ) );
	read_data_2<=data_for_zero_2;	
					-- Mux for Register Write Address
    	write_register_address <= write_register_address_1 
			WHEN RegDst = '1'  			ELSE write_register_address_0;
					-- Mux to bypass data memory for Rformat instructions
	write_data <= ALU_result( 31 DOWNTO 0 ) 
			WHEN ( MemtoReg = '0' ) 	ELSE read_data;
					-- Sign Extend 16-bits to 32-bits
    	Sign_ex<= X"0000" & Instruction_immediate_value
		WHEN Instruction_immediate_value(15) = '0'
		ELSE	X"FFFF" & Instruction_immediate_value;
		--ZERO CALC AND BRANCH CALC
		Sign_extend<=Sign_ex;
		Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_ex( 7 DOWNTO 0 ) ;
		Add_result 	<= Branch_Add( 7 DOWNTO 0 );
		
		ZERO_ctl( 0 ) <= ( Zero_opcode( 0 ) OR Zero_opcode( 3 ) ) AND ZEROOp(1 );
	   ZERO_ctl( 1 ) <= ( NOT Zero_opcode( 2 ) ) OR (NOT ZEROOp( 1 ) );
	   ZERO_ctl( 2 ) <= ( Zero_opcode( 1 ) AND ZEROOp( 1 )) OR ZEROOp( 0 );
		Zero <= '1' 
			WHEN ( ZERO_output_mux( 31 DOWNTO 0 ) = X"00000000" )
			ELSE '0';   
		
PROCESS
	BEGIN
		WAIT UNTIL clock'EVENT AND clock = '1';
		IF reset = '1' THEN
					-- Initial register values on reset are register = reg#
					-- use loop to automatically generate reset logic 
					-- for all registers
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
 			END LOOP;
					-- Write back to register - don't write to register 0
  		ELSIF RegWrite = '1' AND WREG /= 0 THEN
		      register_array( CONV_INTEGER( WREG)) <= write_data;
		END IF;
	END PROCESS;
	
PROCESS ( ZERO_ctl, data_for_zero_1, data_for_zero_2 )
	BEGIN
					-- Select ALU operation
 	CASE ZERO_ctl IS
						-- ALU performs ALUresult = A_input AND B_input
	--	WHEN "000" 	=>	ZERO_output_mux 	<= data_for_zero_1 AND data_for_zero_2; 
						-- ALU performs ALUresult = A_input OR B_input
    -- 	WHEN "001" 	=>	ZERO_output_mux 	<= data_for_zero_1 OR data_for_zero_2;
						-- ALU performs ALUresult = A_input + B_input
	 	--WHEN "010" 	=>	ZERO_output_mux 	<= data_for_zero_1 + data_for_zero_2;
						-- ALU performs ?
 	 	WHEN "011" 	=>	ZERO_output_mux <= X"00000000";
						-- ALU performs ?
 	 	WHEN "100" 	=>	ZERO_output_mux 	<= X"00000000";
						-- ALU performs ?
 	 	WHEN "101" 	=>	ZERO_output_mux 	<= X"00000000";
						-- ALU performs ALUresult = A_input -B_input
 	 	WHEN "110" 	=>	ZERO_output_mux 	<= data_for_zero_1 - data_for_zero_2;
						-- ALU performs SLT
  	 	WHEN "111" 	=>	ZERO_output_mux 	<= data_for_zero_1 - data_for_zero_2 ;
 	 	WHEN OTHERS	=>	ZERO_output_mux 	<= X"00000000" ;
  	END CASE;
  END PROCESS;
END behavior;


