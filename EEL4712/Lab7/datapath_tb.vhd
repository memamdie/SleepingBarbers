library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.internal_lib.all;

entity datapath_tb is
end entity;

architecture arch of datapath_tb is
  signal clk                                                                                   : std_logic := '0';
  signal rst, c_en, v_en, z_en, s_en, acc_en, data_en, ir_en, pc_h_en, pc_l_en, x_h_en, x_l_en : std_logic;
  signal addr_h_en, addr_l_en, sp_l_en, sp_h_en, alu_en, b_en, pc_h_sel, pc_l_sel, addr_sel    : std_logic;
  signal int_bus_sel                                                                           : std_logic_vector(3 downto 0);
  signal inc_sel                                                                               : std_logic_vector(1 downto 0);
  signal switch0, switch1, RAM                                                                 : std_logic_vector(7 downto 0);
  signal control, data                                                                         : std_logic_vector(7 downto 0);
  signal address                                                                               : std_logic_vector(15 downto 0);
  signal status                                                                                : std_logic_vector(3 downto 0);
  signal alu_sel                                                                               : std_logic_vector(3 downto 0);

begin

 UUT : entity work.datapath
 port map (
    clk         => clk,
    rst         => rst,
    c_en        => c_en,
    v_en        => v_en,
    z_en        => z_en,
    s_en        => s_en,
    acc_en      => acc_en,
    data_en     => data_en,
    ir_en       => ir_en,
    pc_h_en     => pc_h_en,
    pc_l_en     => pc_l_en,
    x_h_en      => x_h_en,
    x_l_en      => x_l_en,
    addr_h_en   => addr_h_en,
    addr_l_en   => addr_l_en,
    sp_l_en     => sp_l_en,
    sp_h_en     => sp_h_en,
    alu_en      => alu_en,
    b_en        => b_en,
    pc_h_sel    => pc_h_sel,
    pc_l_sel    => pc_l_sel,
    addr_sel    => addr_sel,
    int_bus_sel => int_bus_sel,
    alu_sel     => alu_sel,
    inc_sel     => inc_sel,
    switch0     => switch0,
    switch1     => switch1,
    RAM         => RAM,
    control     => control,
    data        => data,
    address     => address,
    status      => status
 );
 clk <= not clk after 20 ns;
process
begin
  rst         <= '1';
  c_en        <= '0';
  v_en        <= '0';
  z_en        <= '0';
  s_en        <= '0';
  acc_en      <= '0';
  data_en     <= '0';
  ir_en       <= '0';
  pc_h_en     <= '0';
  pc_l_en     <= '0';
  x_h_en      <= '0';
  x_l_en      <= '0';
  addr_h_en   <= '0';
  addr_l_en   <= '0';
  sp_l_en     <= '0';
  sp_h_en     <= '0';
  alu_en      <= '0';
  b_en        <= '0';
  pc_h_sel    <= '0';
  pc_l_sel    <= '0';
  addr_sel    <= '0';
  alu_sel     <= "0000";
  int_bus_sel <= "0000";
  inc_sel     <= "00";
  switch0     <= (others => '0');
  switch1     <= (others => '0');
  RAM         <= (others => '0');

  wait for 100 ns;
  rst <= '0';
  RAM <= x"01";
  int_bus_sel <= RAM_REG;
  wait for 100 ns;

  addr_h_en <= '1';
  wait for 50 ns;
  addr_h_en <= '0';
  wait for 50 ns;

  RAM <= x"02";
  addr_l_en <= '1';
  wait for 50 ns;
  addr_l_en <= '0';
  wait for 50 ns;

  RAM <= x"03";
  acc_en <= '1';
  wait for 50 ns;
  acc_en <= '0';
  wait for 50 ns;

  RAM <= x"04";
  data_en <= '1';
  wait for 50 ns;
  data_en <= '0';
  wait for 50 ns;

  RAM <= x"05";
  ir_en <= '1';
  wait for 50 ns;
  ir_en <= '0';
  wait for 50 ns;

  RAM <= x"06";
  pc_h_en <= '1';
  -- pc_h_sel <= '1';
  wait for 50 ns;
  pc_h_en <= '0';
  -- pc_h_sel <= '0';
  wait for 50 ns;

  RAM <= x"07";
  pc_l_en <= '1';
  -- pc_l_sel <= '1';
  wait for 50 ns;
  pc_l_en <= '0';
  -- pc_l_sel <= '0';
  wait for 50 ns;

  RAM <= x"08";
  sp_l_en <= '1';
  wait for 50 ns;
  sp_l_en <= '0';
  wait for 50 ns;

  RAM <= x"09";
  sp_h_en <= '1';
  wait for 50 ns;
  sp_h_en <= '0';
  wait for 50 ns;

  RAM <= x"0A";
  alu_en <= '1';
  wait for 50 ns;
  alu_en <= '0';
  wait for 50 ns;

  RAM <= x"0B";
  b_en <= '1';
  wait for 50 ns;
  b_en <= '0';
  wait for 50 ns;

  RAM <= x"0C";
  x_l_en <= '1';
  wait for 50 ns;
  x_l_en <= '0';
  wait for 50 ns;

  RAM <= x"0D";
  x_h_en <= '1';
  wait for 50 ns;
  x_h_en <= '0';
  wait for 50 ns;
  wait for 100 ns;
  RAM <= x"FF";
  wait for 100 ns;
  for i in 0 to 10 loop
      int_bus_sel <= conv_std_logic_vector(i, int_bus_sel'length);
      wait for 20 ns;
  end loop;
wait;



end process;
end architecture;
