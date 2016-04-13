library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder7seg is
  port (
    input : in std_logic_vector(3 downto 0);
    output : out std_logic_vector(6 downto 0)
  );
end decoder7seg;

architecture BHV of decoder7seg is
  begin
      process(input)
      begin
          case input is
            --Display 0
            when "0000" =>
              output <= "1000000";

              --Display 1
            when "0001" =>
              output <= "1111001";

              --Display 2
            when "0010" =>
              output <= "0100100";

              --Display 3
            when "0011" =>
              output <= "0110000";

              --Display 4
            when "0100" =>
              output <= "0011001";

              --Display 5
            when "0101" =>
              output <= "0010010";

              --Display 6
            when "0110" =>
              output <= "0000010";

              --Display 7
            when "0111" =>
              output <= "1111000";

              --Display 8
            when "1000" =>
              output <= "0000000";

              --Display 9
            when "1001" =>
              output <= "0011000";

              --Display a
            when "1010" =>
              output <= "0001000";

              --Display b
            when "1011" =>
              output <= "0000011";

              --Display c
            when "1100" =>
              output <= "1000110";

              --Display d
            when "1101" =>
              output <= "0100001";

              --Display e
            when "1110" =>
              output <= "0000110";

              --Display f
            when "1111" =>
              output <= "0001110";

            when others => null;

			end case;
		end process;
end BHV;
