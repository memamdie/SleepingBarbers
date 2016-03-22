library ieee;
use ieee.std_logic_1164.all;

entity bus_4source is
  generic (
    width  :     positive := 8);
  port (
    input1 : in  std_logic_vector(width-1 downto 0);
    input2 : in  std_logic_vector(width-1 downto 0);
    input3 : in  std_logic_vector(width-1 downto 0);
    input4 : in  std_logic_vector(width-1 downto 0);
    wen    : in  std_logic_vector(3 downto 0);
    output : out std_logic_vector(width-1 downto 0));
end bus_4source;

architecture STR of bus_4source is
begin

  U_TS1 : entity work.tristate
    generic map (
      width  => width)
    port map (
      input  => input1,
      en     => wen(0),
      output => output);

  U_TS2 : entity work.tristate
    generic map (
      width  => width)
    port map (
      input  => input2,
      en     => wen(1),
      output => output);

  U_TS3 : entity work.tristate
    generic map (
      width  => width)
    port map (
      input  => input3,
      en     => wen(2),
      output => output);

  U_TS4 : entity work.tristate
    generic map (
      width  => width)
    port map (
      input  => input4,
      en     => wen(3),
      output => output);

end STR;

-- architecture BHV of bus_4source is
-- begin

--   with wen select
--     output <=
--     input1          when "0001",
--     input2          when "0010",
--     input3          when "0100",
--     input4          when "1000",
--     (others => '-') when others;

-- end BHV;
