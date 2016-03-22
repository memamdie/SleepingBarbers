--- --- --- --- --- --- --- --- --- ---
--- --- ---    SYNC GEN     --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.vga_lib.all;

entity sync_gen is
  generic(
      width : positive := 10);
  port (
    clk25Mhz, rst                 : in std_logic;
    hcount, vcount                : out std_logic_vector(width-1 downto 0);
    video_on, hsync, vsync        : out std_logic
  );
end entity;

architecture behavior of sync_gen is
  component horizontal_count
    generic(
        width : positive);
    port (
        clk25Mhz, rst     : in std_logic;
        hcount            : out std_logic_vector(width-1 downto 0));
  end component;

  component vertical_count
    generic(
        width : positive);
    port (
        clk25Mhz, rst     : in std_logic;
        hcount            : in std_logic_vector(width-1 downto  0);
        vcount            : out std_logic_vector(width-1 downto 0));
  end component;

  component video_on_signal
    generic(
        width : positive := 10);
    port (
      hcount, vcount    : in std_logic_vector(width-1 downto 0);
      video_on          : out std_logic
    );
  end component;

  component horizontal_sync
    generic(
        width : positive);
    port (
      hcount      : in std_logic_vector(width-1 downto 0);
      hsync       : out std_logic
    );
  end component;

  component vertical_sync
    generic(
        width : positive);
    port (
      vcount      : in std_logic_vector(width-1 downto 0);
      vsync       : out std_logic
    );
  end component;

  signal h_count_sig, v_count_sig : std_logic_vector(width-1 downto 0);
  begin

    U_HCOUNT : horizontal_count
      generic map (
          width => 10)
      port map (
          clk25Mhz => clk25Mhz,
          rst => rst,
          hcount => h_count_sig
      );
      U_VCOUNT : vertical_count
        generic map (
          width => 10
        )

        port map (
          clk25Mhz => clk25Mhz,
          rst => rst,
          hcount => h_count_sig,
          vcount => v_count_sig
        );

      U_HSYNC : horizontal_sync
        generic map (
          width => 10
        )
        port map (
          hcount => h_count_sig,
          hsync => hsync
        );
      U_VSYNC : vertical_sync
        generic map (
          width => 10
        )
        port map (
          vcount => v_count_sig,
          vsync => vsync
        );

      U_VIDEO_ON : video_on_signal
        generic map (
          width => 10
        )

        port map (
          hcount => h_count_sig,
          vcount => v_count_sig,
          video_on => video_on
        );

        vcount <= v_count_sig;
        hcount <= h_count_sig;

end architecture;


--- --- --- --- --- --- --- --- --- ---
--- --- --- HORIZONTAL COUNT--- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.vga_lib.all;

entity horizontal_count is
  generic(
      width : positive := 10);
  port (
      clk25Mhz, rst     : in std_logic;
      hcount            : out std_logic_vector(width-1 downto 0));
end entity;

architecture arch of horizontal_count is
begin

sequential : process(clk25Mhz, rst)
  variable counter : unsigned(width-1 downto 0);
begin
  if rst = '1' then
    counter := (others => '0');
  elsif rising_edge(clk25Mhz) then
    if counter < to_unsigned(H_MAX, counter'length) then
      counter := counter + 1;
    else
      counter := (others => '0');
    end if;
  end if;
  hcount <= std_logic_vector(counter);
end process;
end architecture;


--- --- --- --- --- --- --- --- --- ---
--- --- --- VERTICAL COUNT  --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.vga_lib.all;

entity vertical_count is
  generic(
      width : positive := 10);
  port (
      clk25Mhz, rst     : in std_logic;
      hcount            : in std_logic_vector(width-1 downto  0);
      vcount            : out std_logic_vector(width-1 downto 0));
end entity;

architecture arch of vertical_count is
begin

  sequential : process(clk25Mhz, rst)
    variable counter : unsigned(width-1 downto 0);
  begin
    if rst = '1' then
      counter := (others => '0');
    elsif rising_edge(clk25Mhz) then
      if counter = to_unsigned(V_MAX, counter'length) then
        counter := (others => '0');
      elsif unsigned(hcount) = to_unsigned(H_VERT_INC, hcount'length) then
        counter := counter + 1;
      end if;
    end if;
    vcount <= std_logic_vector(counter);
  end process;
end architecture;


--- --- --- --- --- --- --- --- --- ---
--- --- ---    VIDEO ON     --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.vga_lib.all;

entity video_on_signal is
  generic(
      width : positive := 10);
  port (
    hcount, vcount    : in std_logic_vector(width-1 downto 0);
    video_on          : out std_logic
  );
end entity;

architecture arch of video_on_signal is
begin
  check : process(hcount, vcount)
  begin
    video_on <= '1';
    if ((unsigned(hcount) > to_unsigned(H_DISPLAY_END, hcount'length)) or (unsigned(vcount) > to_unsigned(V_DISPLAY_END, vcount'length))) then
      video_on <= '0';
    end if;
  end process;
end architecture;


--- --- --- --- --- --- --- --- --- ---
--- --- --- HORIZONTAL SYNC --- --- ---
--- --- --- --- --- --- --- --- --- ---

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.vga_lib.all;

entity horizontal_sync is
  generic(
      width : positive := 10);
  port (
    hcount      : in std_logic_vector(width-1 downto 0);
    hsync       : out std_logic
  );
end entity;

architecture arch of horizontal_sync is
begin

  horizontal : process(hcount)
  begin
      hsync <= '1';
      if (unsigned(hcount) > to_unsigned(HSYNC_BEGIN, hcount'length) and unsigned(hcount) < to_unsigned(HSYNC_END, hcount'length)) then
        hsync <= '0';
      end if;
  end process;
end architecture;

--- --- --- --- --- --- --- --- --- ---
--- --- ---  VERTICAL SYNC  --- --- ---
--- --- --- --- --- --- --- --- --- ---

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.vga_lib.all;

entity vertical_sync is
  generic(
      width : positive := 10);
  port (
    vcount      : in std_logic_vector(width-1 downto 0);
    vsync       : out std_logic
  );
end entity;

architecture arch of vertical_sync is
begin

vertical : process(vcount)
begin
  vsync <= '1';
  if ((unsigned(vcount) > to_unsigned(VSYNC_BEGIN, vcount'length)) and (unsigned(vcount) < to_unsigned(VSYNC_END, vcount'length))) then
    vsync <= '0';
  end if;
end process;
end architecture;
