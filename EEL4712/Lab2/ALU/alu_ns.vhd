library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_ns is
  generic (
    WIDTH : positive := 16
  );
  port (
    input1 : in std_logic_vector(WIDTH-1 downto 0);
    input2 : in std_logic_vector(WIDTH-1 downto 0);
    sel : in std_logic_vector(3 downto 0);
    output : out std_logic_vector(WIDTH-1 downto 0);
    overflow : out std_logic
  );
end alu_ns;
-- SYNTHESIS GUIDELINE 2 FOR COMBINATIONAL LOGIC: Make sure that every path
-- through the process defines every output and internal signal.

architecture behavior of alu_ns is

  constant C_ADD  : std_logic_vector(3 downto 0) := "0000";
  constant C_SUB  : std_logic_vector(3 downto 0) := "0001";
  constant C_MUL  : std_logic_vector(3 downto 0) := "0010";
  constant C_AND  : std_logic_vector(3 downto 0) := "0011";
  constant C_OR   : std_logic_vector(3 downto 0) := "0100";
  constant C_XOR  : std_logic_vector(3 downto 0) := "0101";
  constant C_NOR  : std_logic_vector(3 downto 0) := "0110";
  constant C_NOT  : std_logic_vector(3 downto 0) := "0111";
  constant C_SHL  : std_logic_vector(3 downto 0) := "1000";
  constant C_SHR  : std_logic_vector(3 downto 0) := "1001";
  constant C_SWP  : std_logic_vector(3 downto 0) := "1010";
  constant C_REV  : std_logic_vector(3 downto 0) := "1011";


begin  -- behavior

  process(input1, input2, sel)
    variable temp    : unsigned(width downto 0);
    variable temp2   : unsigned(width*2-1 downto 0);
  begin
    overflow <= '0';
    case sel is
      when C_ADD =>
        temp := resize(unsigned(input1), WIDTH+1) + resize(unsigned(input2), WIDTH+1);
        output <= std_logic_vector(resize(temp, width));
        overflow <= temp(width);

      when C_SUB =>
        temp := resize(unsigned(input1), WIDTH+1) - resize(unsigned(input2), WIDTH+1);
        output <= std_logic_vector(resize(temp, width));
        overflow <= temp(width);

      when C_MUL =>
        --Multiply code
        temp2 := unsigned(input1) * unsigned(input2);
        temp := temp2(width downto 0);
        output <= std_logic_vector(resize(temp, width));
        overflow <= temp2(width);

      when C_AND =>
        output <= input1 and input2;

      when C_OR =>
        output <= input1 or input2;

      when C_XOR =>
        --xor code
        output <= input1 xor input2;

      when C_NOR =>
        --nor code
        output <= input1 nor input2;

      when C_NOT =>
        --not code
        output <= not input1;

      when C_SHL =>
        --shift left code
        output <= input1(width-2 downto 0) & '0';
        overflow <= input1(width-1);

      when C_SHR =>
        --shift right code
        output <= '0' & input1(width-1 downto 1);

      when C_SWP =>
        --swap code
        output <= input1((width/2)-1 downto 0) & input1(width-1 downto width/2);

      when C_REV =>
        --reverse bits code
        --for(i = 0; i <= width-1; i++)
        for i in 0 to width-1 loop
          output(i) <= input1(width-i-1);
        end loop;

      when others =>
  			for i in 0 to width-1 loop
  				output(i) <= 'U';
  			end loop;
        
    end case;
  end process;
end behavior;
