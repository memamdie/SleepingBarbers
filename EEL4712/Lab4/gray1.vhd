library ieee;
use ieee.std_logic_1164.all;

entity gray1 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        output : out std_logic_vector(3 downto 0));
end gray1;


architecture behavior of gray1 is

  type STATE_TYPE is (STATE_0, STATE_1, STATE_2, STATE_3, STATE_4, STATE_5, STATE_6, STATE_7, STATE_8, STATE_9, STATE_10, STATE_11, STATE_12, STATE_13, STATE_14, STATE_15);
  type STATE_ARRAY_TYPE is array (0 to 15) of STATE_TYPE;

  signal state : STATE_TYPE;

  constant state_array : STATE_ARRAY_TYPE := (STATE_0, STATE_1, STATE_2, STATE_3, STATE_4, STATE_5, STATE_6, STATE_7, STATE_8, STATE_9, STATE_10, STATE_11, STATE_12, STATE_13, STATE_14, STATE_15);
  constant next_state : STATE_ARRAY_TYPE := (STATE_1, STATE_2, STATE_3, STATE_4, STATE_5, STATE_6, STATE_7, STATE_8, STATE_9, STATE_10, STATE_11, STATE_12, STATE_13, STATE_14, STATE_15, STATE_0);

  begin

    process(clk, rst)

    begin
      if rst = '1' then
        output <= "0000";
        state <= STATE_0;
      elsif rising_edge(clk) then
          for i in 0 to 15 loop
              if state = state_array(i) then
                  state <= next_state(i);
                end if;
          end loop;
          case state is
              when STATE_0 =>
                output <= "0000";

              when STATE_1 =>
                output <= "0001";

              when STATE_2 =>
              output <= "0011";

              when STATE_3 =>
              output <= "0010";

              when STATE_4 =>
              output <= "0110";

              when STATE_5 =>
              output <= "0111";

              when STATE_6 =>
              output <= "0101";

              when STATE_7 =>
              output <= "0100";

              when STATE_8 =>
              output <= "1100";

              when STATE_9 =>
              output <= "1101";

              when STATE_10 =>
              output <= "1111";

              when STATE_11 =>
              output <= "1110";

              when STATE_12 =>
              output <= "1010";

              when STATE_13 =>
              output <= "1011";

              when STATE_14 =>
              output <= "1001";

              when STATE_15 =>
              output <= "1000";

              when others => null;

          end case;
      end if;

    end process;

end architecture;
