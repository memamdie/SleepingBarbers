library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
  port (
      clk, rst, go                : in std_logic;
      switch                      : in std_logic_vector(7 downto 0);
      button                      : in std_logic_vector(1 downto 0);
      led0, led1, led2, led3      : out std_logic_vector(6 downto 0)
  );
end entity;

architecture arch of top_level is
  signal control, int_to_ext, ext_to_int         : std_logic_vector(7 downto 0);
  signal mem_en                                  : std_logic;
  signal address, ram_data                       : std_logic_vector(15 downto 0);
  signal ext_bus_sel                             : std_logic_vector(1 downto 0);
  signal buttons                                 : std_logic_vector(1 downto 0);
  signal led_h_in, led_l_in    : std_logic_vector(7 downto 0);
  signal led_h_en, led_l_en , reset                     : std_logic;
begin
  ram_data <= "00000000" & int_to_ext;
  reset <= not rst;
  buttons <= not button;
  U_EXT : entity work.external_architecture
  port map (
      clk         => clk,
      rst         => reset,
      memory_en   => mem_en,
      address     => address,
      ext_bus_sel => ext_bus_sel,
      ram_data    => ram_data,
      switches    => switch,
      buttons     => buttons,
      control     => control,
      led_l_en    => led_l_en,
      led_h_en    => led_h_en,
      int_to_ext  => int_to_ext,
      led0        => led_l_in,
      led1        => led_h_in,
      ext_to_int  => ext_to_int
  );
  U_LED3 : entity work.decoder7seg port map (
      input  => led_h_in(7 downto 4),
      output => led3);

  U_LED2 : entity work.decoder7seg port map (
      input  => led_h_in(3 downto 0),
      output => led2);

  U_LED1 : entity work.decoder7seg port map (
      input  => led_l_in(7 downto 4),
      output => led1);

  U_LED0 : entity work.decoder7seg port map (
      input  => led_l_in(3 downto 0),
      output => led0);

  U_CPU : entity work.cpu
  port map (
      clk         => clk,
      rst         => reset,
      ext_bus_sel => ext_bus_sel,
      memory_en   => mem_en,
      memory      => ext_to_int,
      data        => int_to_ext,
      led_l_en    => led_l_en,
      led_h_en    => led_h_en,
      go          => go,
      control     => control,
      address     => address
  );
end architecture;
