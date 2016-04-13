library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.internal_lib.all;
entity decoder is
  port (
      control          : in std_logic_vector(7 downto 0);
      address          : in std_logic_vector(15 downto 0);
      ext_bus_sel      : out std_logic_vector(1 downto 0);
      out0_en, out1_en : out std_logic

  );
end entity;

architecture arch of decoder is
begin
    combinational : process(control, address)
    begin
      ext_bus_sel <= RAM_L;
      out0_en <= '0';
      out1_en <= '0';
      if control = LDAA and address = x"FFFE" then
          ext_bus_sel <= SW0;
      elsif control = LDAA and address = x"FFFF" then
          ext_bus_sel <= SW1;
      elsif control = STAA then
        ext_bus_sel <= INTERN_BUS;
        if address = x"FFFE" then
          out0_en <= '1';
        elsif address = x"FFFF" then
          out1_en <= '1';
        end if;
      elsif control = CALL then
          ext_bus_sel <= INTERN_BUS;
      end if;
    end process;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.internal_lib.all;

entity external_architecture is
  port (
    clk, rst, memory_en    : in std_logic;
    led_l_en, led_h_en     : in std_logic;
    -- in0_en, in1_en         : in std_logic;
    ext_bus_sel            : in std_logic_vector(1 downto 0);
    address, ram_data      : in std_logic_vector(15 downto 0);
    switches               : in std_logic_vector(7 downto 0);
    buttons                : in std_logic_vector(1 downto 0);
    control, int_to_ext    : in std_logic_vector(7 downto 0);
    ext_to_int             : out std_logic_vector(7 downto 0);
    -- inport0, inport1       : out std_logic_vector(7 downto 0);
    led0, led1             : out std_logic_vector(7 downto 0)
  );
end entity;

architecture arch of external_architecture is
  signal ext_bus_array                            : busIn(0 to 3);
  signal switch0, switch1                         : std_logic_vector(7 downto 0);
  signal ext_bus_out                              : std_logic_vector(7 downto 0);
  signal memory_out                               : std_logic_vector(15 downto 0);
  signal inport0, inport1 : std_logic_vector(7 downto 0);
begin
  combinational : process(switches, buttons)
  begin
    switch0 <= (others => '0');
    switch1 <= (others => '0');
    if buttons = "01" then
      switch0 <= switches(7 downto 0);
    elsif buttons = "10" then
      switch1 <= switches(7 downto 0);
    end if;
  end process;

  ext_bus_array <= (int_to_ext, inport0, inport1, memory_out(7 downto 0));
  U_INPORT0 : entity work.reg
    port map (
      input     => switch0,
      en        => buttons(0),
      clk       => clk,
      rst       => rst,
      output    => inport0
    );
  U_INPORT1 : entity work.reg
      port map (
        input     => switch1,
        en        => buttons(1),
        clk       => clk,
        rst       => rst,
        output    => inport1
      );
  U_RAM : entity work.ram
  port map (
    address       => address(7 downto 0),
    clock         => clk,
    data          => ram_data,
    wren          => memory_en,
    q             => memory_out
  );
  U_EXT_BUS : entity work.bus_8bit
    generic map (width => 4)
    port map(
    inputs    => ext_bus_array,
    sel       => ext_bus_sel,
    output    => ext_bus_out
  );
  U_EXT_TO_INT : entity work.reg
    port map (
      input     => ext_bus_out,
      en        => '1',
      clk       => clk,
      rst       => rst,
      output    => ext_to_int
    );
  U_OUTPORT0 : entity work.reg
    port map (
      input     => ext_bus_out,
      en        => led_l_en,
      clk       => clk,
      rst       => rst,
      output    => led0
    );
  U_OUTPORT1 : entity work.reg
      port map (
        input     => ext_bus_out,
        en        => led_h_en,
        clk       => clk,
        rst       => rst,
        output    => led1
      );
end architecture;
