library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cla2 is
	generic(
		WIDTH : positive := 2);
	port(
		x    : in  std_logic_vector(WIDTH - 1 downto 0);
		y    : in  std_logic_vector(WIDTH - 1 downto 0);
		cin  : in  std_logic;
		s    : out std_logic_vector(WIDTH - 1 downto 0);
		bp   : out std_logic;
		bg   : out std_logic;
		cout : out std_logic);
end cla2;

architecture behavior of cla2 is
	signal p, g  : std_logic_vector(width - 1 downto 0);
	signal carry : std_logic;
begin
	--Internal Propogate
	p(0)  <= x(0) xor y(0);
	p(1)  <= x(1) xor y(1);
	--Internal Generate
	g(0)  <= x(0) and y(0);
	g(1)  <= x(1) and y(1);
	--Internal Carry
	carry <= g(0) or (p(0) and cin);
	--Sum
	s(0)  <= p(0) xor cin;
	s(1)  <= p(1) xor carry;
	--Block Generate
	bg    <= g(1) or (p(1) and g(0));
	--Block Propogate
	bp    <= p(0) and p(1);
	--Sum and carry
	cout  <= (carry and p(1)) or g(1);

end behavior;
