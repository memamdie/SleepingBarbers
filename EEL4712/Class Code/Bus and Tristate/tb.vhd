library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture BHV of tb is

  constant TEST_WIDTH : integer := 16;

  signal input1 : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal input2 : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal input3 : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal input4 : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal wen    : std_logic_vector(3 downto 0);
  signal output : std_logic_vector(TEST_WIDTH-1 downto 0);

begin

  UUT : entity work.bus_4source(BHV)
    generic map (
      width  => TEST_WIDTH)
    port map (
      input1 => input1,
      input2 => input2,
      input3 => input3,
      input4 => input4,
      wen    => wen,
      output => output);

  process
  begin
    input1 <= std_logic_vector(to_unsigned(10, input1'length));
    input2 <= std_logic_vector(to_unsigned(20, input2'length));
    input3 <= std_logic_vector(to_unsigned(30, input3'length));
    input4 <= std_logic_vector(to_unsigned(40, input4'length));

    wen <= "0001";
    wait for 40 ns;
    wen <= "0010";
    wait for 40 ns;
    wen <= "0100";
    wait for 40 ns;
    wen <= "1000";
    wait for 40 ns;
  end process;
end BHV;
