-- Greg Stitt
-- University of Florida
--
-- This is a top_level file for the delay entity. Change the synthesized
-- architecture to verify that the structural and behavioral architectures are
-- equivalent. Also, change the default value for width and cycles to test
-- different possibilites.

library ieee;
use ieee.std_logic_1164.all;

entity top_level is
  generic (
    width      :     positive := 16;
    cycles     :     natural  := 5);
  port( clk    : in  std_logic;
        rst    : in  std_logic;
        en     : in  std_logic;
        input  : in  std_logic_vector(width-1 downto 0);
        output : out std_logic_vector(width-1 downto 0));
end top_level;

architecture str of top_level is
  constant INIT_VAL : std_logic_vector(width-1 downto 0) := (others => '0');
begin

  U_DELAY : entity work.delay(STR)
    generic map (
      width  => width,
      cycles => cycles,
      init => INIT_VAL)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      input  => input,
      output => output);

end str;
