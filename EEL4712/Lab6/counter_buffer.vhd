library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_buffer is
  generic(
    WIDTH : positive := 16);
	port (
		clk : in std_logic;
		rst : in std_logic;
		output : buffer unsigned(width-1 downto 0));
end entity;

architecture BHV of counter_buffer is
  begin
  process(clk, rst)
  begin
  	if rst = '1' then
  		output <= (others => '0');
  	elsif rising_edge(clk) then
  		output <= output + 1;
  	end if;
  end process;
end architecture;
