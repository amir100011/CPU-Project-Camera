-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
	PORT(	SIGNAL Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        	SIGNAL Branch 			: IN 	STD_LOGIC;
        	SIGNAL Zero 			: IN 	STD_LOGIC;
  	      SIGNAL iDVAL 			: IN	STD_LOGIC_VECTOR(15 downto 0);
        	SIGNAL clock, reset 	: IN 	STD_LOGIC;
--        	=====ADDED SIGNALS====

          signal stall: in std_logic:='0'      	
        	
        	);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC, PC_plus_4 	 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL next_PC, Mem_Addr : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	signal Branch_Taken : std_logic;
	signal Instruction_trans : std_logic_vector(31 downto 0);
	--signal End_of_Frame: std_logic;
	
BEGIN
						--ROM for Instruction Memory
inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => 8,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "program.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => clock,
		address_a 	=> Mem_Addr, 
		q_a 			=> Instruction_trans );
					-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
					-- copy output signals - allows read inside module
		--PC_out 			<= PC;
		PC_plus_4_out 	<= PC_plus_4;
						-- send address to inst. memory address register
		Mem_Addr <= Next_PC;
						-- Adder to increment PC by 4        
      	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
       	PC_plus_4( 1 DOWNTO 0 )  <= "00";
						-- Mux to select Branch Address or PC + 4        
		Next_PC  <= X"00" WHEN Reset = '1' 
		Else X"00" WHEN iDval = X"0000"
		ELSE
			Add_result-1  WHEN ( ( Branch = '1' ) AND ( Zero = '1' ) ) 
			--no incrementation when we need to enter a bubble
			ELSE  PC( 9 DOWNTO 2 ) WHEN stall = '1'
		   --ELSE  PC( 9 DOWNTO 2 ) WHEN End_of_Frame = '1' 
			ELSE   PC_plus_4( 9 DOWNTO 2 );
		Branch_Taken <= Zero and Branch;
	   Instruction <=x"00000000" WHEN Branch_Taken = '1' ELSE Instruction_trans ;
	PROCESS
	variable counter: integer:= 0 ;
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
		--	IF (iDval = X"0000") then
			--	counter:= counter +1;
			--	end if;
			IF (reset = '1' OR iDval = X"0000") THEN
				   PC( 9 DOWNTO 2) <= "00000000" ; 
			ELSE 
				   PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;
	END PROCESS;
	
--PROCESS (clock, reset ,iDVAL)
--
--		variable counter: integer;
--		
--	begin
--	
--		if (reset = '1') then
--		End_of_Frame <= '0';
--		counter:= 0 ;
--		
--		elsif (rising_edge(clock) AND iDVAL = '0') then
--			
--			counter:=counter + 1;
--		
--			if(counter = 500) then	
--				End_of_Frame <= '1';
--				counter:= 0 ;
--			else
--				End_of_Frame <= '0';
--			end if;
--	end if;
--	end process;	
			
	
END behavior;


