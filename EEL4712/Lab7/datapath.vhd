library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.internal_lib.all;

entity datapath is
  port (
  clk, rst                                                   : in std_logic;
  c_en, v_en, z_en, s_en                                     : in std_logic;
  acc_en, data_en, ir_en, pc_h_en, pc_l_en, x_h_en, x_l_en   : in std_logic;
  addr_h_en, addr_l_en, sp_l_en, sp_h_en, alu_en, b_en       : in std_logic;
  x_h_sel, x_l_sel, data_sel                                 : in std_logic;
  int_bus_sel					                                       : in std_logic_vector(2 downto 0);
  addr_sel, inc_sel,   index_inc_sel, pc_h_sel, pc_l_sel     : in std_logic_vector(1 downto 0);
  switch0, switch1, RAM                                      : in std_logic_vector(7 downto 0);
  alu_sel                                                    : in std_logic_vector(3 downto 0);
  sp_h_sel, sp_l_sel                                         : in std_logic;
  sp_inc_sel, mux_acc_sel                                    : in std_logic_vector(1 downto 0);
  control                                                    : out std_logic_vector(7 downto 0);
  data                                                       : out std_logic_vector(7 downto 0);
  address                                                    : out std_logic_vector(15 downto 0);
  status                                                     : out std_logic_vector(3 downto 0)
  );
end entity;

architecture arch of datapath is
  signal internal_bus, instruction, data_reg, accumulator, alu_out, alu_to_reg    : std_logic_vector(7 downto 0);
  signal sp_h, sp_l, address_h, address_l, b_out                                  : std_logic_vector(7 downto 0);
  signal mux_acc_out                                                              : std_logic_vector(7 downto 0);
  signal pc_en                                                                    : std_logic_vector(1 downto 0);
  signal c, v, z, s                                                               : std_logic;
  signal int_bus_array                                                            : busIn(0 to 6);
  signal pc, sp, index, count, address_out, resized_b, index_post_inc             : std_logic_vector(15 downto 0);
  signal bufferStatus                                                             : std_logic_vector(3 downto 0);
  signal index_en, index_sel                                                      : std_logic_vector(1 downto 0);
  signal address_bus                                                              : bigBus(0 to 3);
  signal sp_pre_inc, sp_post_inc, mult_out                                        : std_logic_vector(15 downto 0);
  signal sp_l_mux_out, sp_h_mux_out, data_mux_out                                 : std_logic_vector(7 downto 0);
  begin
    mult_out      <= std_logic_vector(unsigned(accumulator) * unsigned(data_reg));
    resized_b     <= x"00" & b_out;
    index_en      <= x_h_en & x_l_en;
    status        <= bufferStatus;
    count         <= internal_bus & internal_bus;
    sp            <= sp_h & sp_l;
    index_sel     <= x_h_sel & x_l_sel;
    pc_en         <= pc_h_en & pc_l_en;
    address_out   <= address_h & address_l;
    address_bus   <= (index_post_inc, address_out, pc, sp_post_inc);
    int_bus_array <= (data_reg, accumulator, RAM, alu_out, b_out, pc(7 downto 0), pc(15 downto 8));
    control       <= instruction;
    U_INDEX_INC : entity work.adder
    port map (
        in1    => index,
        in2    => resized_b,
        output => index_post_inc
    );
    U_INT_BUS : entity work.bus_8bit
    generic map (width => 7)
    port map(
    inputs    => int_bus_array,
    sel       => int_bus_sel,
    output    => internal_bus
    );
    U_B_REG : entity work.reg
    port map (
    input     => internal_bus,
    en        => b_en,
    clk       => clk,
    rst       => rst,
    output    => b_out
    );
    U_ACC : entity work.reg
    port map (
    input     => mux_acc_out,
    en        => acc_en,
    clk       => clk,
    rst       => rst,
    output    => accumulator
    );
    U_MUX_ACC : entity work.mux3x1
	 generic map (width => 8)
    port map (
    in1 => internal_bus,
    in2 => alu_out,
    in3 => mult_out(15 downto 8),
    sel => mux_acc_sel,
    output => mux_acc_out
    );
    U_DATA : entity work.reg
    port map (
    input     => data_mux_out,
    en        => data_en,
    clk       => clk,
    rst       => rst,
    output    => data_reg
    );
    U_DATA_MUX : entity work.mux2x1
    port map (
      in1 => internal_bus,
      in2 => mult_out(7 downto 0),
      sel => data_sel,
      output => data_mux_out
    );
    U_IR : entity work.reg
    port map (
    input     => internal_bus,
    en        => ir_en,
    clk       => clk,
    rst       => rst,
    output    => instruction
    );
    U_ADDR_H : entity work.reg
    port map (
    input     => internal_bus,
    en        => addr_h_en,
    clk       => clk,
    rst       => rst,
    output    => address_h
    );
    U_ADDR_L : entity work.reg
    port map (
    input     => internal_bus,
    en        => addr_l_en,
    clk       => clk,
    rst       => rst,
    output    => address_l
    );
    U_SP_H_MUX : entity work.mux2x1
    port map (
    in1 => internal_bus,
    in2 => sp_post_inc(15 downto 8),
    sel => sp_h_sel,
    output => sp_h_mux_out
    );
    U_SP_L_MUX : entity work.mux2x1
    port map (
    in1 => internal_bus,
    in2 => sp_post_inc(7 downto 0),
    sel => sp_l_sel,
    output => sp_l_mux_out
    );
    U_SP_INC_MUX : entity work.mux3x1
    generic map (width => 16)
    port map (
    in1 => x"0000",
    in2 => X"0001",
    in3 => x"FFFF",
    sel => sp_inc_sel,
    output => sp_pre_inc
    );
    U_SP_INC : entity work.adder
    port map (
        in1    => sp,
        in2    => sp_pre_inc,
        output => sp_post_inc
    );
    U_SP_H : entity work.reg
    port map (
    input     => sp_h_mux_out,
    en        => sp_h_en,
    clk       => clk,
    rst       => rst,
    output    => sp_h
    );
    U_SP_L : entity work.reg
    port map (
    input     => sp_l_mux_out,
    en        => sp_l_en,
    clk       => clk,
    rst       => rst,
    output    => sp_l
    );
    U_ALU : entity work.ALU
    port map (
    a        => accumulator,
    d        => data_reg,
    cin      => bufferStatus(3),
    sel      => alu_sel,
    output   => alu_to_reg,
    c        => c,
    z        => z,
    v        => v,
    s        => s
    );
    U_ALU_OUT : entity work.reg
    port map (
    input     => alu_to_reg,
    en        => alu_en,
    clk       => clk,
    rst       => rst,
    output    => alu_out
    );
    U_STATUS : entity work.status_reg
    port map (
    clk       => clk,
    rst       => rst,
    c_en      => c_en,
    v_en      => v_en,
    z_en      => z_en,
    s_en      => s_en,
    c         => c,
    v         => v,
    z         => z,
    s         => s,
    output    => bufferStatus
    );
    U_PC : entity work.program_counter
    port map (
    clk       => clk,
    rst       => rst,
    count     => count,
    address   => address_out,
    pc_l_sel  => pc_l_sel,
    pc_h_sel  => pc_h_sel,
    pc_en     => pc_en,
    inc_sel   => inc_sel,
    output    => pc
    );
    U_X : entity work.index_struct
    port map (
    clk        => clk,
    rst        => rst,
    count      => count,
    index_sel  => index_sel,
    index_en   => index_en,
    inc_sel    => index_inc_sel,
    output     => index
    );
    U_ADDRESS_BUS : entity work.bus_16bit
    port map (
      inputs => address_bus,
      sel => addr_sel,
      output => address
    );
    U_INT_TO_EXT : entity work.reg
    port map (
      input     => internal_bus,
      en        => '1',
      clk       => clk,
      rst       => rst,
      output    => data
    );
  end architecture;
