-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;

entity top_level is
  port (
    clk, rst, en : in  std_logic;
    output       : out std_logic_vector(3 downto 0));
end top_level;

architecture STR of top_level is

begin  -- STR

  U_FSM : entity work.FSM(PROC1_1)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      output => output);

end STR;
