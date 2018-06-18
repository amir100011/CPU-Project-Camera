
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  Fowarding_Detection is port(	

Write_Needed_ALU: in std_logic_vector(4 downto 0):=(others=>'0');--the current instruction needs to write to a register 
Wtire_to_REG: in std_logic:='0';--need only writing to reg bank, modified in CONTROL UNIT
Write_Needed_DM: in std_logic_vector(4 downto 0):=(others=>'0');--the current instruction needs to write to a register  
Wtire_to_Mem: in std_logic:='0';--need to write to MEM, modified in CONTROL UNIT
Rt_Address: in std_logic_vector(4 downto 0):=(others=>'0');
Rs_Address: in std_logic_vector(4 downto 0):=(others=>'0');
RST_Address_Rs: out std_logic_vector(4 downto 0):=(others=>'0');--for Stall unit
RST_Address_Rt: out std_logic_vector(4 downto 0):=(others=>'0');--for Stall unit
Rt_Delivery: out std_logic_vector(1 downto 0):="00";
Rs_Delivery: out std_logic_vector(1 downto 0):="00"

);
END Fowarding_Detection;

ARCHITECTURE rtl of Fowarding_Detection IS

signal Write_Needed_ALU_q, Write_Needed_DM_q, Rt_Address_q, Rs_Address_q: std_logic_vector(4 downto 0):=(others=>'0');

BEGIN
  
  Write_Needed_ALU_q<=Write_Needed_ALU;
  Write_Needed_DM_q<=Write_Needed_DM;
  Rt_Address_q<=Rt_Address;
  Rs_Address_q<=Rs_Address;


Rt_Delivery<="10" when Write_Needed_ALU_q = Rt_Address_q and Write_Needed_ALU_q /= x"00000000" and Wtire_to_REG = '1'--need to write in reg bank and Rd is not 0
        else "01" when Write_Needed_DM_q = Rt_Address_q and Write_Needed_DM_q /= x"00000000" and Wtire_to_Mem = '1' 
        else "00";

RST_Address_Rt <= Rt_Address_q when Write_Needed_ALU_q = Rt_Address_q and Write_Needed_ALU_q /= x"00000000" and Wtire_to_REG = '1'--need to write in reg bank and Rd is not 0
             else Rt_Address_q when Write_Needed_DM_q = Rt_Address_q and Write_Needed_DM_q /= x"00000000" and Wtire_to_Mem = '1' 
             else "00000";
          
Rs_Delivery<="10" when Write_Needed_ALU_q = Rs_Address_q and Write_Needed_ALU_q /= x"00000000" and Wtire_to_REG = '1'--need to write in reg bank and Rd is not 0
        else "01" when Write_Needed_DM_q = Rs_Address_q and Write_Needed_DM_q /= x"00000000" and Wtire_to_Mem = '1' 
        else "00";


RST_Address_Rs <= Rs_Address_q when Write_Needed_ALU_q = Rs_Address_q and Write_Needed_ALU_q /= x"00000000" and Wtire_to_REG = '1'--need to write in reg bank and Rd is not 0
             else Rs_Address_q when Write_Needed_DM_q = Rs_Address_q and Write_Needed_DM_q /= x"00000000" and Wtire_to_Mem = '1' 
             else "00000";
END rtl;


