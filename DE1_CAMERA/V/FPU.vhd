
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity FPU is
port(
		A,B :in std_logic_vector(7 downto 0):=(others=>'0');
		Opcode: in std_logic_vector(3 downto 0):=(others=>'0');
		Output : out std_logic_vector(31 downto 0):=(others=>'0')
);
end FPU;

architecture FPU_Arch of FPU is
component FPU_conv is
	port(
	Input : in std_logic_vector( 7 downto 0);
	Converted : out std_logic_vector( 31 downto 0):=(others=>'0')
);
end component;

component FPM is
	port(
    OperandA:           in std_logic_vector (31 downto 0):=(others=>'0');
    OperandB:           in std_logic_vector (31 downto 0):=(others=>'0');
    enable:             in std_logic:='0';
    AXB_Float:          out std_logic_vector (31 downto 0):=(others=>'0')
    );
end component;
component FPA is
  port(
	OperandA_FP,OperandB_FP :  in  std_logic_vector(31 downto 0);
	FS_in: 		               in  std_logic;
	O:						   out  std_logic_vector(31 downto 0):=(others=>'0')
);
end component;
signal ConvA_out,ConvB_out,AXB_Float_tmp,A_ADD_B_Float: std_logic_vector(31 downto 0):=(others=>'0');
signal FPM_enable,FPA_enable: std_logic:='0';
begin

CONVA: FPU_conv
		port map(Input=>A,Converted=>ConvA_out);
CONVB: FPU_conv
		port map(Input=>B,Converted=>ConvB_out);

FPM_IN: FPM port map(OperandA => ConvA_out,
                     OperandB => ConvB_out,
                     enable => FPM_enable,
                     AXB_Float => AXB_Float_tmp
                     );
FPA_IN: FPA port map ( OperandA_FP=>ConvA_out,
                       OperandB_FP=>ConvB_out,
                       FS_in=>'0',
                       O=>A_ADD_B_Float);
                       
process(Opcode,AXB_Float_tmp,A_ADD_B_Float) is
  begin
    if (Opcode = "1111") then
      FPM_enable <= '1';
	    Output <= AXB_Float_tmp;
    elsif (Opcode ="1110") then
		  Output <= A_ADD_B_Float;
		  FPM_enable <= '0';
	 else 
		  Output<=(others=>'0');
		  FPM_enable <= '0';
    end if;
  end process; 
  

end FPU_Arch;


