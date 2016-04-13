library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.internal_lib.all;

entity cpu_tb is
end entity;

architecture TB of cpu_tb is
  constant WIDTH   : positive := 8;

  signal clk              : std_logic                          := '0';
  signal rst              : std_logic                          := '1';
  signal memory           : std_logic_vector(7 downto 0);
  signal data, control    : std_logic_vector(7 downto 0);
  signal address          : std_logic_vector(15 downto 0);
begin

    UUT : entity work.cpu
        port map (
            clk     => clk,
            rst     => rst,
            memory  => memory,
            data    => data,
            control => control,
            address => address
        );

      clk <= not clk after 20 ns;
      process
      begin
          memory <= (others => '0');
          wait for 100 ns;
          rst <= '0';

          report "DONE!!!!!!" severity note;
      end process;
end architecture;
