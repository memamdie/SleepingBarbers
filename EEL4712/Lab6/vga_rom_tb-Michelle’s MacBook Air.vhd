--Same includes as all the other files
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

--The entity is empty
entity vga_rom_tb is
end entity;

architecture arch of vga_rom_tb is
  -- Here you declare all the signals you will need to port map to your entity that is under test
  signal address    : std_logic_vector(11 downto 0) := (others => '0');
  signal q          : std_logic_vector(11 downto 0);
  signal clk        : std_logic := '0';
  signal counter    : unsigned(11 downto 0) := (others => '0');
  -- Very important begin to begin the architecture
begin
  -- This is your unit under test.
  -- You then say entity work.____ fill in the blank for what entity you want to test
  U_ROM : entity work.vga_rom
  -- Do your fun port mapping bullshit
    port map (
        address   => address,
        clock     => clk,
        q         => q
    );
-- This is the clock that is 25mhz so make it look like that
    clk <= not clk after 20 ns;
    -- start a process with no sensitivity list
    process
    begin
      -- do whatever testing mess you want.
      -- here i am looping from 0 to 4095 and just checking that at each of these addresses the rom outputs some value
      -- IDGAF what the value that it outputs is
          for i in 0 to 4095 loop
              address <= std_logic_vector(counter);
              wait until clk'event and clk = '1';
              counter <= counter + 1;
          end loop;
      -- the once youre done testing say youre done
      report "DONE!";
      -- and wait forever
      wait;
    end process;

end architecture;
