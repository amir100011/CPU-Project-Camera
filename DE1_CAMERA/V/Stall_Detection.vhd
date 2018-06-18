LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Stall_Detection is port(

  input_Set:              in std_logic_vector (4 downto 0) := (others=>'0');
  input_Reset:            in std_logic_vector (4 downto 0) := (others=>'0');
  clk:                    in std_logic := '0';
  output_stall:           out std_logic_vector (31 downto 0) := (others=>'0');
  out_prev:               out std_logic_vector (31 downto 0) := (others=>'0')
  
  );
end  Stall_Detection;

ARCHITECTURE rtl OF Stall_Detection IS

Component Decoder_5X32 is port(

  input:            in std_logic_vector (4 downto 0) := (others=>'0');
  output:             out std_logic_vector (31 downto 0) := (others=>'0')
  
  );
end Component Decoder_5X32;

Component DFF_Piped is port(

  clk:                in std_logic := '0';
  set,rst:            in std_logic := '0';
  output:             out std_logic := '0';
  output_prev:        out std_logic := '0' 
  
  );
end component DFF_Piped;

signal SET_out, RST_out: std_logic_vector (31 downto 0):=(others=>'0');

begin
  
  RST_decoder: Decoder_5X32 port map (input=>input_Reset, output=> RST_out);

  SET_decoder: Decoder_5X32 port map (input=>input_Set, output=> SET_out);

  DFF_generator: for i in 0 to 31 generate
       Single_DFF: DFF_Piped port map (clk => clk, set => SET_out(i), rst => RST_out(i), output => output_stall(i), output_prev =>out_prev(i));
       end generate DFF_generator;
end rtl;
