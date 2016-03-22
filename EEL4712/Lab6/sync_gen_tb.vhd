library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.vga_lib.all;

entity sync_gen_tb is
end entity;

architecture arch of sync_gen_tb is

  signal clk25Mhz                 : std_logic := '0';
  signal rst                      : std_logic := '0';
  signal hcount, vcount           : std_logic_vector(9 downto 0);
  signal video_on, hsync, vsync   : std_logic;

begin

  UUT : entity work.sync_gen
    port map (
      clk25Mhz => clk25Mhz,
      rst => rst,
      hcount => hcount,
      hsync => hsync,
      vcount => vcount,
      vsync => vsync,
      video_on => video_on
    );

    clk25Mhz <= not clk25Mhz after 20 ns;

    testing : process
    begin
      rst <= '1';
      wait for 40 ns;

      rst <= '0';
      wait for 100 ms;

    report "DONE";
    wait;

    end process;
end architecture;
