library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_128 is
  port (
      clk50MHz, rst : in std_logic;
      buttons       : in std_logic_vector(2 downto 0);
      red           : out std_logic_vector(3 downto 0);
      green         : out std_logic_vector(3 downto 0);
      blue          : out std_logic_vector(3 downto 0);
      hsync, vsync  : out std_logic
  );
end entity;

architecture arch of vga_128 is

component vga_rom_128
  port (
      address : in std_logic_vector(13 downto 0);
      clock   : in std_logic := '1';
      q       : out std_logic_vector(11 downto 0)
  );
end component;

component column_decoder_128
  generic (
    WIDTH : positive := 10 );
  port (
      hcount  : in std_logic_vector(WIDTH-1 downto 0);
      buttons : in std_logic_vector(2 downto 0);
      address : out std_logic_vector(6 downto 0);
      enable  : out std_logic
  );
end component;

component row_decoder_128
  generic (
    WIDTH : positive := 10 );
  port (
      vcount  : in std_logic_vector(WIDTH-1 downto 0);
      buttons : in std_logic_vector(2 downto 0);
      address : out std_logic_vector(6 downto 0);
      enable  : out std_logic
    );
end component;

component sync_gen
  generic(
      width : positive := 10);
  port (
    clk25Mhz, rst                 : in std_logic;
    hcount, vcount                : out std_logic_vector(width-1 downto 0);
    video_on, hsync, vsync        : out std_logic
  );
end component;

component clk_div
  port (
      clk_in  : in  std_logic;
      clk_out : out std_logic;
      rst     : in  std_logic);
end component;
  constant WIDTH : positive := 10;
  signal hcount, vcount                                : std_logic_vector(width-1 downto 0);
  signal column_enable, row_enable, video_on, clk25Mhz : std_logic;
  signal column_address, row_address                   : std_logic_vector(6 downto 0);
  signal rom_address												 : std_logic_vector(13 downto 0);
  signal rom_out  				                         : std_logic_vector(11 downto 0);

begin
  rom_address <= row_address & column_address;

  U_CLK_DIV : clk_div
      port map (
          clk_in  => clk50MHz,
          clk_out => clk25Mhz,
          rst     => rst
      );
  U_SYNC_GEN : sync_gen
      port map (
        clk25Mhz  => clk25Mhz,
        rst       => rst,
        hcount    => hcount,
        vcount    => vcount,
        video_on  => video_on,
        hsync     => hsync,
        vsync     => vsync
      );
  U_COL_DECODE : column_decoder_128
      port map (
        hcount    => hcount,
        buttons   => buttons,
        address   => column_address,
        enable    => column_enable
      );
  U_ROW_DECODE : row_decoder_128
      port map (
        vcount    => vcount,
        buttons   => buttons,
        address   => row_address,
        enable    => row_enable
      );
  U_ROM : vga_rom_128
      port map (
        address => rom_address,
        clock   => clk25Mhz,
        q       => rom_out
      );
combinational : process(column_enable, row_enable, video_on, rom_out)
begin

  if column_enable = '1' and row_enable = '1' and video_on = '1' then
    red <= rom_out(3 downto 0);
    green <= rom_out(7 downto 4);
    blue <= rom_out(11 downto 8);

  else
    red <= (others => '0');
    green <=  (others => '0');
    blue <=  (others => '0');
  end if;

end process;
end architecture;
