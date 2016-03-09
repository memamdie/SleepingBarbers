library ieee;
use ieee.std_logic_1164.all;

entity cgen2 is
	port(
		c_i, p_i, g_i, p_ii, g_ii : in  std_logic;
		c_ii, c_iii, bp, bg       : out std_logic);
end cgen2;

architecture behavior of cgen2 is

begin
	c_ii  <= (c_i and p_i) or g_i;
	c_iii <= g_ii or (((c_i and p_i) or g_i) and p_ii);
	bp    <= p_i and p_ii;
	bg    <= g_ii or (g_i and p_ii);

end behavior;
