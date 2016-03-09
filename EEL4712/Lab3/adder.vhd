library ieee;
use ieee.std_logic_1164.all;

entity adder is
	generic(
		WIDTH : positive := 8);
	port(
		x, y : in  std_logic_vector(WIDTH - 1 downto 0);
		cin  : in  std_logic;
		s    : out std_logic_vector(WIDTH - 1 downto 0);
		cout : out std_logic);
end adder;

architecture RIPPLE_CARRY of adder is
	signal carry : std_logic_vector(width downto 0);

begin                                   -- RIPPLE_CARRY
	U_ADD : for i in 0 to width - 1 generate
		U_FA : entity work.fa port map(
				input1    => x(i),
				input2    => y(i),
				carry_in  => carry(i),
				sum       => s(i),
				carry_out => carry(i + 1));
	end generate U_ADD;
	carry(0) <= cin;
	cout     <= carry(width);

end RIPPLE_CARRY;

architecture CARRY_LOOKAHEAD of adder is
begin                                   -- CARRY_LOOKAHEAD

	process(x, y, cin)

		-- generate and propagate bits
		variable g, p : std_logic_vector(WIDTH - 1 downto 0);

		-- internal carry bits
		variable carry : std_logic_vector(WIDTH downto 0);

		-- and'd p sequences
		variable p_ands : std_logic_vector(WIDTH - 1 downto 0);

	begin

		-- calculate generate (g) and propogate (p) values

		for i in 0 to WIDTH - 1 loop
			-- fill in code that defines each g and p bit
			g(i) := x(i) and y(i);
			p(i) := x(i) xor y(i);
		end loop;                       -- i

		carry(0) := cin;

		-- calculate each carry bit

		for i in 1 to WIDTH loop

			-- calculate and'd p terms for ith carry logic
			-- the index j corresponds to the lowest Pj value in the sequence
			-- e.g., PiPi-1...Pj

			for j in 0 to i - 1 loop
				p_ands(j) := '1';
				-- and everything from Pj to Pi-1
				for k in j to i - 1 loop
					-- fill code
					p_ands(j) := p_ands(j) and p(k);
				end loop;
			end loop;

			carry(i) := g(i - 1);

			-- handle all of the pg minterms
			for j in 1 to i - 1 loop
				-- fill in code
				carry(j) := g(j - 1) or (p(j - 1) and carry(j - 1));
			end loop;

			-- handle the final propagate of the carry in
			carry(i) := carry(i) or (p_ands(0) and cin);
		end loop;                       -- i

		-- set the outputs
		for i in 0 to WIDTH - 1 loop
			-- fill in code
			s(i) <= p(i) xor carry(i);
		end loop;                       -- i

		cout <= carry(WIDTH);

	end process;

end CARRY_LOOKAHEAD;

architecture HIERARCHICAL of adder is
	signal BP    : std_logic_vector(width downto 0);
	signal BG    : std_logic_vector(width downto 0);
	signal carry : std_logic;
begin                                   -- HIERARCHICAL

	U_CLA4_LSB : entity work.cla4 port map(
			x    => x(3 downto 0),
			y    => y(3 downto 0),
			cin  => cin,
			sum  => s(3 downto 0),
			pr   => BP(0),
			gen  => BG(0),
			cout => open);

	U_CLA4_MSB : entity work.cla4 port map(
			x    => x(7 downto 4),
			y    => y(7 downto 4),
			cin  => carry,
			sum  => s(7 downto 4),
			pr   => BP(1),
			gen  => BG(1),
			cout => open);
	U_CGEN : entity work.cgen2 port map(
			c_i   => cin,
			p_i   => BP(0),
			g_i   => BG(0),
			p_ii  => BP(1),
			g_ii  => BG(1),
			c_ii  => carry,
			c_iii => cout,
			bp    => BP(2),
			bg    => BG(2));

end HIERARCHICAL;
