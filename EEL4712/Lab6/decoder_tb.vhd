library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity decoder_tb is
end entity;

architecture arch of decoder_tb is
  signal vcount, hcount     : std_logic_vector(9 downto 0) := (others => '0');
  signal buttons            : std_logic_vector(2 downto 0);
  signal row_address, col_address : std_logic_vector(5 downto 0);
  signal row_enable, col_enable : std_logic;
  signal counter : unsigned(9 downto 0) := (others => '0');
begin
    U_ROW : entity work.row_decoder
        port map (
            vcount  => vcount,
            buttons => buttons,
            address => row_address,
            enable  => row_enable
        );

    U_COL : entity work.column_decoder
        port map (
            hcount  => hcount,
            buttons => buttons,
            address => col_address,
            enable  => col_enable
        );
  process
  begin
    report "Testing center";
    buttons <= "000";
      for i in 0 to 640 loop
        vcount <= std_logic_vector(counter);
          for i in 0 to 480 loop
            hcount <= std_logic_vector(counter);
            wait for 30 ns;
            counter <= counter + 1;
        end loop;
      end loop;
    report "Testing top left";
    buttons <= "001";
      for i in 0 to 640 loop
        vcount <= std_logic_vector(counter);
          for i in 0 to 480 loop
            hcount <= std_logic_vector(counter);
            wait for 30 ns;
            counter <= counter + 1;
        end loop;
      end loop;
    report "Testing top right";
    buttons <= "010";
      for i in 0 to 640 loop
        vcount <= std_logic_vector(counter);
          for i in 0 to 480 loop
            hcount <= std_logic_vector(counter);
            wait for 30 ns;
            counter <= counter + 1;
        end loop;
      end loop;
    report "Testing bottom left";
    buttons <= "011";
      for i in 0 to 640 loop
        vcount <= std_logic_vector(counter);
          for i in 0 to 480 loop
            hcount <= std_logic_vector(counter);
            wait for 30 ns;
            counter <= counter + 1;
        end loop;
      end loop;
    report "Testing bottom right";
    buttons <= "100";
      for i in 0 to 640 loop
        vcount <= std_logic_vector(counter);
          for i in 0 to 480 loop
            hcount <= std_logic_vector(counter);
            wait for 30 ns;
            counter <= counter + 1;
        end loop;
      end loop;
    report "Testing some other button";
    buttons <= "111";
      for i in 0 to 640 loop
        vcount <= std_logic_vector(counter);
          for i in 0 to 480 loop
            hcount <= std_logic_vector(counter);
            wait for 30 ns;
            counter <= counter + 1;
        end loop;
      end loop;
      report "Done!";
      wait;
  end process;
end architecture;
