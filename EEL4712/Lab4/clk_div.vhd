library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_div is
    generic(clk_in_freq  : natural;
            clk_out_freq : natural);
    port (
        clk_in  : in  std_logic;
        clk_out : out std_logic;
        rst     : in  std_logic);
end clk_div;

architecture behavior of clk_div is
  function calculate_bits(num : natural) return natural is
      begin
        if num > 0 then
          return 1 + calculate_bits(num/2);
        else
          return 1;
        end if;
  end calculate_bits;

  --Figure out how many bits you will need to represent the ratio in binary
  constant freq  : natural := clk_in_freq/2;
  constant ratio : natural := calculate_bits(freq-1);
  --Incremented to keep track of how many clock signals have passed before outputting a clock signal
  signal counter: unsigned(ratio-1 downto 0) := (others => '0');

begin
  process(clk_in, rst)
    variable clk_sig : std_logic;

  begin
    if (rst = '1') then
        clk_out <= '0';
        clk_sig := '0';
    elsif rising_edge(clk_in) then
        if counter = freq-1 then
          counter <= (others => '0');
          clk_sig := not clk_sig;
        else
          counter <= counter + 1;
        end if;
        clk_out <= clk_sig;

    end if;
  end process;
end behavior;
