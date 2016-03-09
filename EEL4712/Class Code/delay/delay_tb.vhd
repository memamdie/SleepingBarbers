-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_tb is
end delay_tb;

architecture TB of delay_tb is

  constant TEST_WIDTH  : positive := 8;
  constant CYCLE_DELAY : positive := 5;

  signal clk        : std_logic                               := '0';
  signal rst        : std_logic                               := '1';
  signal en         : std_logic                               := '0';
  signal input      : std_logic_vector(TEST_WIDTH-1 downto 0) := (others => '0');
  signal output_str : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal output_bhv : std_logic_vector(TEST_WIDTH-1 downto 0);

  signal done : std_logic := '0';

begin  -- TB

  U_STR : entity work.delay(STR)
    generic map (
      width  => TEST_WIDTH,
      cycles => CYCLE_DELAY)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      input  => input,
      output => output_str);

  U_BHV : entity work.delay(BHV)
    generic map (
      width  => TEST_WIDTH,
      cycles => CYCLE_DELAY)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      input  => input,
      output => output_bhv);


  clk <= not clk and not done after 10 ns;

  process
  begin

    rst <= '1';
    en  <= '0';

    -- wait for 5 cycles
    for i in 0 to 5 loop
      wait until clk'event and clk = '1';
    end loop;  -- i

    rst <= '0';
       
    for i in 0 to 2**TEST_WIDTH-1 loop

      input <= std_logic_vector(to_unsigned(i, input'length));

      if (i mod 20 = 0) then
        en <= '0';
      else
        en <= '1';
      end if;

      wait until clk'event and clk = '1';
    end loop;

    done <= '1';
    wait;

  end process;

end TB;
