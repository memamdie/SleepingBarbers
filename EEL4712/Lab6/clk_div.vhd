library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_div is
    port (
        clk_in  : in  std_logic;
        clk_out : out std_logic;
        rst     : in  std_logic);
end clk_div;

architecture behavior of clk_div is

begin
  process(clk_in, rst)
    variable clk_sig : std_logic;
  begin
    if (rst = '1') then
        clk_out <= '0';
        clk_sig := '0';
    elsif rising_edge(clk_in) then
        clk_sig := not clk_sig;
        clk_out <= clk_sig;
    end if;
  end process;
end behavior;
