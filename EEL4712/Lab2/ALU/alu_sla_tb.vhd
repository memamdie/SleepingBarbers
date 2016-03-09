library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu_sla_tb is
end alu_sla_tb;

architecture TB of alu_sla_tb is

    component alu_sla

        generic (
            WIDTH : positive := 16
            );
        port (
            input1   : in  std_logic_vector(WIDTH-1 downto 0);
            input2   : in  std_logic_vector(WIDTH-1 downto 0);
            sel      : in  std_logic_vector(3 downto 0);
            output   : out std_logic_vector(WIDTH-1 downto 0);
            overflow : out std_logic
            );

    end component;

    constant WIDTH  : positive                           := 8;
    signal input1   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal input2   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal sel      : std_logic_vector(3 downto 0)       := (others => '0');
    signal output   : std_logic_vector(WIDTH-1 downto 0);
    signal overflow : std_logic;

    signal input1_7   : std_logic_vector(6 downto 0) := (others => '0');
    signal input2_7   : std_logic_vector(6 downto 0) := (others => '0');
    signal output_7   : std_logic_vector(6 downto 0);
    signal overflow_7 : std_logic;

begin  -- TB

    UUT : alu_sla
        generic map (WIDTH => WIDTH)
        port map (
            input1   => input1,
            input2   => input2,
            sel      => sel,
            output   => output,
            overflow => overflow);
    UUT7 : alu_sla
        generic map (WIDTH => 7)
        port map (
            input1   => input1_7,
            input2   => input2_7,
            sel      => sel,
            output   => output_7,
            overflow => overflow_7);

    process
    begin

        -- test 2+6 (no overflow) = 8
        sel    <= "0000";
        input1 <= conv_std_logic_vector(2, input1'length);
        input2 <= conv_std_logic_vector(6, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(8, output'length)) report "Error : 2+6 = " & integer'image(conv_integer(output)) & " instead of 8" severity warning;
        assert(overflow = '0') report "Error                                   : overflow incorrect for 2+8" severity warning;

        -- test 250+50 (with overflow) = 300
        sel    <= "0000";
        input1 <= conv_std_logic_vector(250, input1'length);
        input2 <= conv_std_logic_vector(50, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(300, output'length)) report "Error : 250+50 = " & integer'image(conv_integer(output)) & " instead of 44" severity warning;
        assert(overflow = '1') report "Error                                     : overflow incorrect for 250+50" severity warning;

        -- test 2-6 = -4
        sel    <= "0001";
        input1 <= conv_std_logic_vector(2, input1'length);
        input2 <= conv_std_logic_vector(6, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(-4, output'length)) report "Error : 2-6 = " & integer'image(conv_integer(output)) & " instead of -4" severity warning;

        -- test 250-50 = 200
        sel    <= "0001";
        input1 <= conv_std_logic_vector(250, input1'length);
        input2 <= conv_std_logic_vector(50, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(200, output'length)) report "Error : 250-50 = " & integer'image(conv_integer(output)) & " instead of 200" severity warning;

        -- test 5*6 = 30
        sel    <= "0010";
        input1 <= conv_std_logic_vector(5, input1'length);
        input2 <= conv_std_logic_vector(6, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(30, output'length)) report "Error : 5*6 = " & integer'image(conv_integer(output)) & " instead of 30" severity warning;
        assert(overflow = '0') report "Error                                    : overflow incorrect for 5*6" severity warning;

        -- test 16*16 = 256
        sel    <= "0010";
        input1 <= conv_std_logic_vector(16, input1'length);
        input2 <= conv_std_logic_vector(16, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(256, output'length)) report "Error : 16*16 = " & integer'image(conv_integer(output)) & " instead of 0" severity warning;
        assert(overflow = '1') report "Error                                      : overflow incorrect for 16*16" severity warning;

        -- add many more tests

        --test 0 and 54 = 0
        sel <= "0011";
        input1 <= conv_std_logic_vector(0, input1'length);
        input2 <= conv_std_logic_vector(63, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(0, output'length)) report "Error 0 and 63 = " & integer'image(conv_integer(output)) & " instead of 0" severity warning;


        --test 86 and 15 = 6
        sel <= "0011";
        input1 <= conv_std_logic_vector(86, input1'length);
        input2 <= conv_std_logic_vector(15, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(6, output'length)) report "Error 86 and 15 = " & integer'image(conv_integer(output)) & " instead of 6" severity warning;

        --test 0 or 63 = 63
        sel <= "0100";
        input1 <= conv_std_logic_vector(0, input1'length);
        input2 <= conv_std_logic_vector(63, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(63, output'length)) report "Error 0 or 63 = " & integer'image(conv_integer(output)) & " instead of 63" severity warning;


        --test 86 or 15 = 95
        sel <= "0100";
        input1 <= conv_std_logic_vector(86, input1'length);
        input2 <= conv_std_logic_vector(15, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(95, output'length)) report "Error 86 or 15 = " & integer'image(conv_integer(output)) & " instead of 95" severity warning;

        --test 0 xor 63 = 63
        sel <= "0101";
        input1 <= conv_std_logic_vector(0, input1'length);
        input2 <= conv_std_logic_vector(63, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(63, output'length)) report "Error 0 xor 63 = " & integer'image(conv_integer(output)) & " instead of 63" severity warning;


        --test 86 xor 15 = 89
        sel <= "0101";
        input1 <= conv_std_logic_vector(86, input1'length);
        input2 <= conv_std_logic_vector(15, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(89, output'length)) report "Error 86 xor 15 = " & integer'image(conv_integer(output)) & " instead of 89" severity warning;

        --test 0 nor 54 = 192
        sel <= "0110";
        input1 <= conv_std_logic_vector(0, input1'length);
        input2 <= conv_std_logic_vector(63, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(192, output'length)) report "Error 0 nor 63 = " & integer'image(conv_integer(output)) & " instead of 192" severity warning;


        --test 86 nor 15 = 160
        sel <= "0110";
        input1 <= conv_std_logic_vector(86, input1'length);
        input2 <= conv_std_logic_vector(15, input2'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(160, output'length)) report "Error 86 nor 15 = " & integer'image(conv_integer(output)) & " instead of 160" severity warning;

        --test not 63 = 192
        sel <= "0111";
        input1 <= conv_std_logic_vector(63, input1'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(192, output'length)) report "Error not 63 = " & integer'image(conv_integer(output)) & " instead of 192" severity warning;


        --test not 86
        sel <= "0111";
        input1 <= conv_std_logic_vector(86, input1'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(169, output'length)) report "Error not 86 = " & integer'image(conv_integer(output)) & " instead of 169" severity warning;


        --shift left (multiply by 2) 15
        sel <= "1000";
        input1 <= conv_std_logic_vector(15, input1'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(30, output'length)) report "Error shifting 15 left = " & integer'image(conv_integer(output)) & " instead of 30" severity warning;

        --shift right (divide by 2) 88
        sel <= "1001";
        input1 <= conv_std_logic_vector(88, input1'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(44, output'length)) report "Error shift 88 right = " & integer'image(conv_integer(output)) & " instead of 44" severity warning;

        --swap the first half bits with the second half bits
        sel <= "1010";
        input1 <= conv_std_logic_vector(88, input1'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(133, output'length)) report "Error swapping the first half the binary string 0101 1000 = " & integer'image(conv_integer(output)) & " instead of 133" severity warning;


        --reverse the bits in the string
        sel <= "1011";
        input1 <= conv_std_logic_vector(88, input1'length);
        wait for 40 ns;
        assert(output = conv_std_logic_vector(26, output'length)) report "Error reversing the binary string 0101 1000 = " & integer'image(conv_integer(output)) & " instead of 26" severity warning;

        --swap the first half bits with the second half bits for a 7 bit input
        sel <= "1010";
        input1_7 <= conv_std_logic_vector(40, input1_7'length);
        wait for 40 ns;
        assert(output_7 = conv_std_logic_vector(5, output_7'length)) report "Error swapping the first half the binary string 0101000 = " & integer'image(conv_integer(output_7)) & " instead of 5" severity warning;

        report "SIMULATION FINISHED";
        wait;
    end process;
end TB;
