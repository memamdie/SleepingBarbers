library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.internal_lib.all;

entity cpu is
  port (
      clk, rst, go        : in std_logic;
      memory              : in std_logic_vector(7 downto 0);
      memory_en           : out std_logic;
      ext_bus_sel         : out std_logic_vector(1 downto 0);
      data, control       : out std_logic_vector(7 downto 0);
      led_l_en, led_h_en  : out std_logic;
      address             : out std_logic_vector(15 downto 0)
  );
end entity;

architecture arch of cpu is
  signal c_en, v_en, z_en, s_en                                      : std_logic;
  signal acc_en, data_en, ir_en, pc_h_en, pc_l_en, x_h_en, x_l_en    : std_logic;
  signal addr_h_en, addr_l_en, sp_l_en, sp_h_en, alu_en              : std_logic;
  signal b_en, sp_h_sel, sp_l_sel, data_sel                          : std_logic;
  signal x_l_sel, x_h_sel                                            : std_logic;
  signal int_bus_sel					                                       : std_logic_vector(2 downto 0);
  signal addr_sel, inc_sel, index_inc_sel, sp_inc_sel                : std_logic_vector(1 downto 0);
  signal pc_h_sel, pc_l_sel, mux_acc_sel                             : std_logic_vector(1 downto 0);
  signal switch0, switch1, instruction                               : std_logic_vector(7 downto 0);
  signal status                                                      : std_logic_vector(3 downto 0);
  signal alu_sel                                                     : std_logic_vector(3 downto 0);
  signal addr : std_logic_vector(15 downto 0);
begin
  address <= addr;
  switch0 <= (others => '0');
  switch1 <= (others => '0');
  control <= instruction;
  U_CONTROLLER : entity work.controller
    port map (
        instruction       => instruction,
        address           => addr,
        status            => status,
        clk               => clk,
        rst               => rst,
        c_en              => c_en,
        v_en              => v_en,
        z_en              => z_en,
        s_en              => s_en,
        b_en              => b_en,
        alu_en            => alu_en,
        acc_en            => acc_en,
        data_en           => data_en,
        ir_en             => ir_en,
        pc_h_en           => pc_h_en,
        pc_l_en           => pc_l_en,
        x_h_en            => x_h_en,
        x_l_en            => x_l_en,
        go                => go,
        memory_en         => memory_en,
        addr_h_en         => addr_h_en,
        addr_l_en         => addr_l_en,
        led_l_en          => led_l_en,
        led_h_en          => led_h_en,
        sp_l_en           => sp_l_en,
        sp_h_en           => sp_h_en,
        pc_h_sel          => pc_h_sel,
        pc_l_sel          => pc_l_sel,
        addr_sel          => addr_sel,
        data_sel          => data_sel,
        int_bus_sel       => int_bus_sel,
        mux_acc_sel       => mux_acc_sel,
        sp_l_sel          => sp_l_sel,
        sp_h_sel          => sp_h_sel,
        sp_inc_sel        => sp_inc_sel,
        alu_sel           => alu_sel,
        inc_sel           => inc_sel,
        x_l_sel           => x_l_sel,
        x_h_sel           => x_h_sel,
        index_inc_sel     => index_inc_sel,
        ext_bus_sel       => ext_bus_sel
    );
  U_DATAPATH : entity work.datapath
    port map (
        control           => instruction,
        clk               => clk,
        rst               => rst,
        c_en              => c_en,
        v_en              => v_en,
        b_en              => b_en,
        z_en              => z_en,
        s_en              => s_en,
        alu_sel           => alu_sel,
        alu_en            => alu_en,
        acc_en            => acc_en,
        data_en           => data_en,
        data_sel          => data_sel,
        ir_en             => ir_en,
        pc_h_en           => pc_h_en,
        pc_l_en           => pc_l_en,
        x_h_en            => x_h_en,
        x_l_en            => x_l_en,
        addr_h_en         => addr_h_en,
        addr_l_en         => addr_l_en,
        sp_l_en           => sp_l_en,
        sp_h_en           => sp_h_en,
        pc_h_sel          => pc_h_sel,
        pc_l_sel          => pc_l_sel,
        addr_sel          => addr_sel,
        x_l_sel           => x_l_sel,
        x_h_sel           => x_h_sel,
        mux_acc_sel       => mux_acc_sel,
        index_inc_sel     => index_inc_sel,
        int_bus_sel       => int_bus_sel,
        sp_l_sel          => sp_l_sel,
        sp_h_sel          => sp_h_sel,
        sp_inc_sel        => sp_inc_sel,
        inc_sel           => inc_sel,
        switch0           => switch0,
        switch1           => switch1,
        RAM               => memory,
        data              => data,
        address           => addr,
        status            => status
    );


end architecture;
