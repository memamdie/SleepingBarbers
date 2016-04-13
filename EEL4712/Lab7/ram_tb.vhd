library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.internal_lib.all;

entity ram_tb is
end entity;

architecture TB of ram_tb is
  constant WIDTH   : positive := 8;

  signal clk                 : std_logic                          := '0';
  signal address             : std_logic_vector(7 downto 0);
  signal wren                : std_logic := '0';
  signal q, data             : std_logic_vector(15 downto 0);
begin

    UUT : entity work.ram
        port map (
            clock            => clk,
            address          => address,
            data             => data,
            wren             => wren,
            q                => q
        );

      clk <= not clk after 20 ns;
      process
      begin
          data <= (others => '0');
          address <= (others => '0');
          wait for 100 ns;

          for i in 0 to 255 loop
            address <= conv_std_logic_vector(i, address'length);
            wait for 100 ns;
          end loop;

          report "DONE!!!!!!" severity note;
      end process;
end architecture;
