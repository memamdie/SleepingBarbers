library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
  port (
  clk    : in  std_logic;
  rst    : in  std_logic;
  up_n   : in  std_logic;         -- active low
  load_n : in  std_logic;         -- active low
  input  : in  std_logic_vector(3 downto 0);
  output : out std_logic_vector(3 downto 0));
end counter;


architecture behavior of counter is
    -- use a 4 bit unsigned instead of an integer.

begin
    process(clk, rst)
      variable count : unsigned(3 downto 0);
    begin
        --Reset
        if (rst = '1') then
            count := (others => '0');
        elsif (rising_edge(clk)) then
            --Load from input
            if load_n = '0' then
                count := unsigned(input);
            -- add or subtract 1
          elsif (up_n = '0') then
                --Count up
                count := count + 1;
            else
                --Count down
                count := count - 1;
            end if;
        end if;
        output <= std_logic_vector(count);
    end process;


end behavior;
