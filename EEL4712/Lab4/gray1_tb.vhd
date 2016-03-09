library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity gray1_tb is
end gray1_tb;

architecture TB of gray1_tb is
    component gray1
      port (
          clk    : in  std_logic;
          rst    : in  std_logic;
          output : out std_logic_vector(3 downto 0));
    end component;

    type VECTOR_ARRAY_TYPE is array (0 to 15) of std_logic_vector(3 downto 0);

    -- signal state : STATE_TYPE;
    signal clk_in : std_logic := '0';
    signal rst : std_logic;
    signal out_sig : std_logic_vector(3 downto 0);

    constant output_values : VECTOR_ARRAY_TYPE   := ("0000", "0001", "0011", "0010", "0110", "0111", "0101", "0100", "1100", "1101", "1111", "1110", "1010", "1011", "1001", "1000");

    begin

      UUT : gray1

        port map (
          clk => clk_in,
          rst => rst,
          output => out_sig
        );

        clk_in <= not clk_in after 30 ns;

        process
        begin
          rst <= '1';
          for i in 0 to 5 loop
              wait until rising_edge(clk_in);
            end loop;
            rst <= '0';
            wait for 60 ns;
            for i in 0 to 15 loop
                wait for 60 ns;
                assert(out_sig = output_values(i)) report "Error the output is " &  integer'image(conv_integer(out_sig)) & " but i is " & integer'image(conv_integer(i)) & " which means output should be " & integer'image(conv_integer(output_values(i)));
            end loop;
            report "SIMULATION FINISHED";

            wait;
        end process;
end TB;
