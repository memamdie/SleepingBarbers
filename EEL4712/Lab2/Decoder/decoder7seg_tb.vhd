
library ieee;
use ieee.std_logic_1164.all;


entity decoder7seg_tb is
end decoder7seg_tb;


architecture TB of decoder7seg_tb is
-- constants
-- signals
signal input : std_logic_vector(3 downto 0);
signal output : std_logic_vector(6 downto 0);

begin

		UUT	:		entity work.decoder7seg
			port map (
					input => input,
					output => output
			);

		process
			begin
					--Display 0
					input <= "0000";
					wait for 30 ns;
					assert(output = "1000000")  report "Zero is not being displayed properly";

					--Display 1
					input <= "0001";
					wait for 30 ns;
					assert(output = "1111001")  report "One is not being displayed properly";

					--Display 2
					input <= "0010";
					wait for 30 ns;
					assert(output = "0100100")  report "Two is not being displayed properly";

					--Display 3
					input <= "0011";
					wait for 30 ns;
					assert(output = "0110000")  report "Three is not being displayed properly";

					--Display 4
					input <= "0100";
					wait for 30 ns;
					assert(output = "0011001")  report "Four is not being displayed properly";

					--Display 5
					input <= "0101";
					wait for 30 ns;
					assert(output = "0010010")  report "Five is not being displayed properly";

					--Display 6
					input <= "0110";
					wait for 30 ns;
					assert(output = "0000010")  report "Six is not being displayed properly";

					--Display 7
					input <= "0111";
					wait for 30 ns;
					assert(output = "1111000")  report "Seven is not being displayed properly";

					--Display 8
					input <= "1000";
					wait for 30 ns;
					assert(output = "0000000")  report "Eight is not being displayed properly";

					--Display 9
					input <= "1001";
					wait for 30 ns;
					assert(output = "0011000")  report "Nine is not being displayed properly";

					--Display a
					input <= "1010";
					wait for 30 ns;
					assert(output = "0001000")  report "a is not being displayed properly";

					--Display b
					input <= "1011";
					wait for 30 ns;
					assert(output = "0000011")  report "b is not being displayed properly";

					--Display c
					input <= "1100";
					wait for 30 ns;
					assert(output = "1000110")  report "c is not being displayed properly";

					--Display d
					input <= "1101";
					wait for 30 ns;
					assert(output = "0100001")  report "d is not being displayed properly";

					--Display e
					input <= "1110";
					wait for 30 ns;
					assert(output = "0000110")  report "e is not being displayed properly";

					--Display f
					input <= "1111";
					wait for 30 ns;
					assert(output = "0001110")  report "f is not being displayed properly";

					report "SIMULATION FINISHED";

					wait;

		end process;
end TB;
