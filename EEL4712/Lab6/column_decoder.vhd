library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity column_decoder is
  generic (
    WIDTH : positive := 10 );
  port (
      hcount  : in std_logic_vector(WIDTH-1 downto 0);
      buttons : in std_logic_vector(2 downto 0);
      address : out std_logic_vector(5 downto 0);
      enable  : out std_logic
  );
end entity;

architecture arch of column_decoder is
  constant CENTER       : std_logic_vector(2 downto 0) := "000";
  constant TOP_LEFT     : std_logic_vector(2 downto 0) := "001";
  constant TOP_RIGHT    : std_logic_vector(2 downto 0) := "010";
  constant BOTTOM_LEFT  : std_logic_vector(2 downto 0) := "011";
  constant BOTTOM_RIGHT : std_logic_vector(2 downto 0) := "100";

begin

combinational : process(buttons, hcount)

begin
    address <= (others => '0');
    enable <= '0';
    case buttons is
        when CENTER =>
          if ((unsigned(hcount) >= to_unsigned(CENTERED_X_START, hcount'length)) and (unsigned(hcount) <= to_unsigned(CENTERED_X_END, hcount'length))) then
            enable <= '1';
            address <= std_logic_vector(resize((unsigned(hcount) - to_unsigned(CENTERED_X_START, hcount'length)) / 2, 6));
          end if;
        when TOP_LEFT =>
          if ((unsigned(hcount) >= to_unsigned(TOP_LEFT_X_START, hcount'length)) and (unsigned(hcount) <= to_unsigned(TOP_LEFT_X_END, hcount'length))) then
            enable <= '1';
            address <= std_logic_vector(resize((unsigned(hcount) - to_unsigned(TOP_LEFT_X_START, hcount'length)) / 2, 6));
            end if;
        when TOP_RIGHT =>
          if ((unsigned(hcount) >= to_unsigned(TOP_RIGHT_X_START, hcount'length)) and (unsigned(hcount) <= to_unsigned(TOP_RIGHT_X_END, hcount'length))) then
            enable <= '1';
            address <= std_logic_vector(resize((unsigned(hcount) - to_unsigned(TOP_RIGHT_X_START, hcount'length)) / 2, 6));
            end if;
        when BOTTOM_LEFT =>
          if ((unsigned(hcount) >= to_unsigned(BOTTOM_LEFT_X_START, hcount'length)) and (unsigned(hcount) <= to_unsigned(BOTTOM_LEFT_X_END, hcount'length))) then
            enable <= '1';
            address <= std_logic_vector(resize((unsigned(hcount) - to_unsigned(BOTTOM_LEFT_X_START, hcount'length)) / 2, 6));
            end if;
        when BOTTOM_RIGHT =>
          if ((unsigned(hcount) >= to_unsigned(BOTTOM_RIGHT_X_START, hcount'length)) and (unsigned(hcount) <= to_unsigned(BOTTOM_RIGHT_X_END, hcount'length))) then
            enable <= '1';
            address <= std_logic_vector(resize((unsigned(hcount) - to_unsigned(BOTTOM_RIGHT_X_START, hcount'length)) / 2, 6));
            end if;
        when others => null;
      end case;

end process;

end architecture;
