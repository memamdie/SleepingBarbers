library ieee;
use ieee.std_logic_1164.all;

-- DO NOT CHANGE ANYTHING IN THE ENTITY

entity adder is
  generic (
      width : positive    := 4
  );
  port (
    input1    : in  std_logic_vector(3 downto 0);
    input2    : in  std_logic_vector(3 downto 0);
    carry_in  : in  std_logic;
    sum       : out std_logic_vector(3 downto 0);
    carry_out : out std_logic);
end adder;

-- DEFINE A RIPPLE-CARRY ADDER USING A STRUCTURE DESCRIPTION THAT CONSISTS OF 4
-- FULL ADDERS

architecture STR of adder is
    signal carry    :   std_logic_vector(width downto 0);

begin  -- STR
      U_ADD : for i in 0 to width-1 generate
        U_FA : entity work.fa port map (
          input1    => input1(i),
          input2    => input2(i),
          carry_in  => carry(i),
          sum    => sum(i),
          carry_out => carry(i+1));
      end generate U_ADD;

      carry(0)   <= carry_in;
      carry_out  <= carry(width);

end STR;
