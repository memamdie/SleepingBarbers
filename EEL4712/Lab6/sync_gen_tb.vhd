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
  signal rgb_h_count, rgb_v_count : std_logic_vector(9 downto 0);
  signal v_pulse, h_pulse         : unsigned(6 downto 0);

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
      h_pulse <= (others => '0');
      v_pulse <= (others => '0');
      wait for 40 ns;

      rst <= '0';

      if rising_edge(clk25Mhz) then
        -- h_pulse <= (others => '0');
        -- v_pulse <= (others => '0');
        if hsync = '0' then
          h_pulse <= h_pulse + 1;
        -- else

        end if;

        if vsync = '0' then
          v_pulse <= v_pulse + 1;
        -- else

        end if;
      end if;

    report "DONE";
    wait;

    end process;
end architecture;
