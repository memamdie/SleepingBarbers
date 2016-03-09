library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity cla4 is
	generic(
		WIDTH : positive := 4);
	port(
		x, y  				: in  std_logic_vector(WIDTH - 1 downto 0);
		cin  					: in  std_logic;
		sum 					: out std_logic_vector(WIDTH - 1 downto 0);
		cout, pr, gen	: out std_logic);
end cla4;

architecture behavior of cla4 is

	signal BP   : std_logic_vector(width downto 0);
	signal BG   : std_logic_vector(width downto 0);
	signal carry : std_logic;
begin  -- Carry Lookahead 4 bits

		U_CLA2_LSB : entity work.cla2 port map (
				x(1 downto 0) => x(1 downto 0),
				y(1 downto 0) => y(1 downto 0),
				cin 					=> cin,
				s(1 downto 0) => sum(1 downto 0),
				bp 						=> BP(0),
				bg 						=> BG(0),
				cout 					=> open);

		U_CLA2_MSB : entity work.cla2 port map (
				x(1 downto 0) => x(3 downto 2),
				y(1 downto 0) => y(3 downto 2),
				cin 					=> carry,
				s(1 downto 0) => sum(3 downto 2),
				bp 						=> BP(1),
				bg 						=> BG(1),
				cout 					=> open);

    U_CGEN :entity work.cgen2 port map (
				c_i => cin,
				p_i => BP(0),
				g_i => BG(0),
				p_ii => BP(1),
				g_ii => BG(1),
				c_ii => carry,
				c_iii => cout,
				bp => BP(2),
	      bg => BG(2));

				pr <= BP(2);
				gen <= BG(2);
end behavior;
