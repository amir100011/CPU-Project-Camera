				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS IS

	PORT( reset, clock,SW					: IN 	STD_LOGIC; 
		-- Output important signals to pins for easy display in Simulator
		PC										: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,	
     	Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out, Zero_out, Memwrite_out, 
		Regwrite_out						: OUT 	STD_LOGIC;
		HEX1,HEX2,HEX3,HEX4				: out std_logic_vector(6 downto 0):=(others=>'1')
		);
		
END 	MIPS;

ARCHITECTURE structure OF MIPS IS
	COMPONENT SEG_TO_HEX 
			PORT(
			Seg_in		:	in std_logic_vector(31 downto 0);
			clk,Sw			:  in std_logic;
			HEX1,HEX2,HEX3,HEX4 :            out std_logic_vector(6 downto 0):=(others=>'1')
			);
			end component;
	COMPONENT Ifetch
   	     PORT(	Instruction			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		PC_plus_4_out 		: OUT  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		Add_result 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        		Branch 				: IN 	STD_LOGIC;--TODO Delay until new address is computed
        		Zero 			   	: IN 	STD_LOGIC;
        		PC_out 				: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		clock,reset 		: IN 	STD_LOGIC;
        		--ADDED
        		stall: in std_logic
        			 );
        	
	END COMPONENT; 

	COMPONENT Idecode
 	     PORT(	read_data_1	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			PC_plus_4 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 ); 
			ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 	: IN 	STD_LOGIC;
			MemtoReg 	: IN 	STD_LOGIC;
			RegDst 		: IN 	STD_LOGIC;
			Sign_extend : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			clock,reset	: IN 	STD_LOGIC ;
			write_register_address : out std_logic_vector(4 downto 0);
			--ADDED
			Zero 			: OUT	STD_LOGIC;
			WREG : in std_logic_vector (4 downto 0);
			Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			Zero_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ZEROOp 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			Seg					: out std_logic_vector(31 downto 0)--DOR
			);
	END COMPONENT;

	COMPONENT control
	     PORT( 	Opcode 				: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
             	RegDst 				: OUT 	STD_LOGIC;
             	ALUSrc 				: OUT 	STD_LOGIC;
             	MemtoReg 			: OUT 	STD_LOGIC;
             	RegWrite 			: OUT 	STD_LOGIC;
             	MemRead 			: OUT 	STD_LOGIC;
             	MemWrite 			: OUT 	STD_LOGIC;
             	Branch 				: OUT 	STD_LOGIC;
             	ALUop 				: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
             	clock, reset		: IN 	STD_LOGIC
					);
	END COMPONENT;

	COMPONENT  Execute
   	     PORT(	Read_data_1 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
                Read_data_2 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Sign_Extend 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Function_opcode		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
               	ALUOp 				: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
               	ALUSrc 				: IN 	STD_LOGIC;
						
               	--Zero 				: OUT	STD_LOGIC;
               	ALU_Result 			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	--Add_Result 			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
               	--PC_plus_4 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
               	clock, reset		: IN 	STD_LOGIC
						
						);
	END COMPONENT;


	COMPONENT dmemory
	     PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		address 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        		write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		MemRead, Memwrite 	: IN 	STD_LOGIC;
        		Clock,reset			: IN 	STD_LOGIC );
	END COMPONENT;
	
	--===ADDED COMPONENTS===---
	
	COMPONENT Delay is generic(
					N:integer := 2
			);
		port (
					Input,clk,En : in std_logic;
					O: out std_logic
			);
		end Component Delay;
		
			COMPONENT Stall_Comparison is port(
                                          clk:                           in std_logic := '0';
                                          instruction:                   in std_logic_vector(31 downto 0):=(others=>'0');
                                          input_Wanna_RST:               in std_logic_vector (4 downto 0) := (others=>'0');
                                          output_comp:                   out std_logic:='0'
                                        );
		end Component Stall_Comparison;
		
	COMPONENT Stall_Mux is port(
                                          Instruction:                   in std_logic_vector(31 downto 0):=(others=>'0');
                                          stall:                         in std_logic:='0';
                                          output:                        out std_logic_vector(31 downto 0):=(others=>'0')
                                        );
	end Component Stall_Mux;
			
		--===END OF ADDED COMPONENTS===--
		
		
					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	--SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	--SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend,Sign_extend_Delay 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result_EX,ALU_Result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data,read_data_WB 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUSrc ,ALUSrc_Delay				: STD_LOGIC;
	SIGNAL Branch   			: STD_LOGIC;
	SIGNAL RegDst 				: STD_LOGIC;
	SIGNAL Regwrite ,MemRead_Delayed,MemWrite_Delayed			: STD_LOGIC;
	SIGNAL Zero 				: STD_LOGIC;
	SIGNAL MemWrite 			: STD_LOGIC;
	SIGNAL MemtoReg,MemtoReg_Delayed 			: STD_LOGIC;
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL ALUop,ALUop_EX 				: STD_LOGIC_VECTOR(  1 DOWNTO 0 );
	SIGNAL Instruction,Pipe_Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	signal write_register_address,WREG1: std_logic_vector(4 downto 0);
	signal read_data_Out,read_data_In : std_logic_vector(63 downto 0);--64 bit register for read_data1 and read_data2 
	signal Pipe_Instruction_EX : std_logic_vector(5 downto 0);
	signal RegWrite_EX : std_logic;
	signal Seg_out,write_data_in : std_logic_vector(31 downto 0);
	signal HEX1_trans,HEX2_trans,HEX3_trans,HEX4_trans				:std_logic_vector(6 downto 0):=(others=>'1');
	
	--===ADDED SIGNALS===--
	signal stall_needed: std_logic:='0';
   signal Instruction_Or_Stall: std_logic_vector(31 downto 0):=(others=>'0');
	
BEGIN
					-- copy important signals to output pins for easy 
					-- display in Simulator
   Instruction_out 	<= Instruction;
   ALU_result_out 	<= ALU_result_Ex;
   read_data_1_out 	<= read_data_Out(31 downto 0);
   read_data_2_out 	<= read_data_Out(63 downto 32);
   write_data_out  	<= read_data WHEN MemtoReg = '1' ELSE ALU_result;
   Branch_out 			<= Branch;
   Zero_out 			<= Zero;
   RegWrite_out 		<= RegWrite;
   MemWrite_out 		<= MemWrite;	
					-- connect the 5 MIPS components
					

	
SEG2HEX: SEG_TO_HEX
			port map(Seg_in =>Seg_out,clk=>clock,Sw=>SW,HEX1=>HEX1_trans,HEX2=>HEX2_trans,HEX3=>HEX3_trans,HEX4=>HEX4_trans);
	
	HEX1 <= HEX1_trans;
	HEX2 <= HEX2_trans;
	HEX3 <= HEX3_trans;
	HEX4 <= HEX4_trans;
	
  IFE : Ifetch
	PORT MAP (	Instruction 	=> Instruction,
    	    	PC_plus_4_out  	=> PC_plus_4,
				Add_result 		   => Add_result,
				Branch 			   => Branch,
				Zero 		       	=> Zero,
				PC_out 		   	=> PC,        		
				clock 			   => clock,  
				reset 		   	=> reset,
				--ADDED
				stall => stall_needed
				 );
				
	DELAYFETCH: for i in 0 to 31 generate--Fetch Reg  cycle
						DELAYARRAYF: Delay 
								generic map(N=>1)
								port map(Input=>Instruction_Or_Stall(i) , En=>'1' , clk=>clock , O =>Pipe_Instruction(i));
					end generate DELAYFETCH;
					
		STALL_OR_Instruction: Stall_Mux port map (Instruction =>Instruction, stall=>stall_needed, output=>Instruction_Or_Stall);--mux for stalling
					
   ID : Idecode
   	PORT MAP (	
				read_data_1 	=> read_data_Out(31 downto 0),
        		read_data_2 	=> read_data_Out(63 downto 32),
        		Instruction 	=> Pipe_Instruction,
				read_data 		=> read_data,
				ALU_result 		=> ALU_result_EX,
				RegWrite 		=> RegWrite_EX,
				MemtoReg 		=> MemtoReg_Delayed,
				RegDst 			=> RegDst,
				Sign_extend 	=> Sign_extend,
        		clock 			=> clock,  
				reset 			=> reset,
				write_register_address => write_register_address,
				WREG	=>	WREG1,
				Zero 	=>Zero,
				Add_Result 		=> Add_Result,
				PC_plus_4		=> PC_plus_4,
				Zero_opcode =>Pipe_Instruction(5 downto 0),--for zero calc
				ZEROOp => ALUop,
				Seg 	=> seg_out
				);
 
							
DELAYWRITEREG: for i in 0 to 4 generate--Write_reg delay to sync with write_data 3 cycles
						DELAYARRAYDE: Delay
							generic map(N=>2)
								port map(Input=>write_register_address(i) , En=>'1' , clk=>clock , O =>WREG1(i));
					end generate DELAYWRITEREG;
				
DELAYSIGNEXTENED: for i in 0 to 31 generate--Sign Exteneded
						DELAYARRAY4: Delay
								generic map(N=>1)
								port map(Input=>Sign_extend(i) , En=>'1' , clk=>clock , O =>Sign_extend_Delay(i));
					end generate DELAYSIGNEXTENED;
					
DELAY_DECODE_2_ALU: for i in 0 to 63 generate
						DELAYARRAY1: Delay
								generic map(N=>1)
								port map(Input=>read_data_Out(i) , En=>'1' , clk=>clock , O =>read_data_In(i));
					end generate DELAY_DECODE_2_ALU;

   CTL:   control
	PORT MAP ( 	Opcode 		=> Pipe_Instruction( 31 DOWNTO 26 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 			=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch,
				ALUop 			=> ALUop,
            clock 			=> clock,
				reset 			=> reset
				);

				
DELAY_FUNCTION_OPCODE: for i in 0 to 5 generate
						DELAY_FUNC: Delay
								generic map(N=>1)
								port map(Input=>Pipe_Instruction(i) , En=>'1' , clk=>clock , O =>Pipe_Instruction_EX(i));
					end generate DELAY_FUNCTION_OPCODE;
DELAYREGWRITE: Delay
						generic map(N=>2)
						port map(Input=>RegWrite , En=>'1' , clk=>clock , O =>RegWrite_EX);
DELAYIDEXALUOP:for i in 0 to 1 generate	
						DELAYTWO: Delay
								generic map(N=>1)
							   port map(Input=>ALUop(i) , En=>'1' , clk=>clock , O =>ALUop_EX(i));
						end generate DELAYIDEXALUOP;
DELAY_MEMREAD:Delay
					 generic map(N=>2)
					 port map(Input=>MemRead, En=>'1' , clk=>clock , O =>MemRead_Delayed);
DELAY_MEMTOREG:Delay
					 generic map(N=>2)
					 port map(Input=>MemtoReg, En=>'1' , clk=>clock , O =>MemtoReg_Delayed);
DELAY_ALUSRC: Delay
					 generic map(N=>1)
					 port map(Input=>ALUSrc, En=>'1' , clk=>clock , O =>ALUSrc_Delay);
					 
DELAY_MemWrite:Delay
					 generic map(N=>2)
					 port map(Input=>MemWrite, En=>'1' , clk=>clock , O =>MemWrite_Delayed);
					 
  EXE:  Execute
   	PORT MAP (		Read_data_1 	=> read_data_In(31 downto 0),
							Read_data_2 	=> read_data_In(63 downto 32),
							Sign_extend 	=> Sign_extend_Delay,
							Function_opcode	=>Pipe_Instruction_EX, --Pipe_Instruction( 5 DOWNTO 0 ),--todo
							ALUOp 			=> ALUop_EX,
							ALUSrc 			=> ALUSrc_Delay,
							--Zero 				=> Zero,
							ALU_Result		=> ALU_Result,
						--	Add_Result 		=> Add_Result,
					   	--PC_plus_4		=> PC_plus_4,
							Clock				=> clock,
							Reset				=> reset
						);
	DELAYIDEXALU:for i in 0 to 31 generate
						DELAYARRAY2: Delay
								generic map(N=>1)
								port map(Input=>ALU_Result(i) , En=>'1' , clk=>clock , O =>ALU_result_EX(i));
					end generate DELAYIDEXALU;
	DELAY_WRITEDATA: for i in 0 to 31 generate
						DELAYARRAY9: Delay
								generic map(N=>1)
								port map(Input=>read_data_in(32+i) , En=>'1' , clk=>clock , O =>write_data_in(i));
					end generate DELAY_WRITEDATA;

   MEM:  dmemory
	PORT MAP (	read_data 		=> read_data,
				address 				=> ALU_result_EX (9 DOWNTO 2),--jump memory address by 4
				write_data 			=> write_data_in,
				MemRead 				=> MemRead_Delayed, 
				Memwrite 			=> MemWrite_Delayed, 
            clock 			 	=> clock,  
				reset 				=> reset );
				
				
				
				--======ADDED FOR STALL=====--
				
			Stall_Unit: Stall_Comparison port map (clk =>	clock, 
			                                       instruction => Instruction,
			                                       input_Wanna_RST => WREG1,--TODO ADD SIGNAL
			                                       output_comp => stall_needed
			                                       );
			                                       	
				
END structure;


