library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath2 is
  generic (
    WIDTH : positive := 16);
  port (
    x, y                                          : in std_logic_vector(width-1 downto 0);
    x_en, y_en, x_sel, y_sel, output_en, clk, rst : in std_logic;
    x_lt_y, x_ne_y                                : out std_logic;
    output                                        : out std_logic_vector(width-1 downto 0));
end datapath2;

architecture STR of datapath2 is
  -- Declare all the entities that will be used to create a datapath
  component mux_2x1_2
    generic (
      WIDTH : positive );
    port (
      a, b    : in std_logic_vector(width-1 downto 0);
      sel     : in std_logic;
      output  : out std_logic_vector(width-1 downto 0));
  end component;

  component reg_2
    generic (
      WIDTH : positive );
    port (
      enable, clk, rst  : in std_logic;
      input             : in std_logic_vector(width-1 downto 0);
      output            : out std_logic_vector(width-1 downto 0));
  end component;

  component comparator_2
    generic (
      WIDTH : positive );
    port (
      x, y    : in std_logic_vector(width-1 downto 0);
      x_lt, x_ne  : out std_logic);
  end component;

  component subtractor_2
    generic (
      WIDTH : positive );
    port (
      in1, in2   : in std_logic_vector(width-1 downto 0);
      output     : out std_logic_vector(width-1 downto 0));
  end component;

  signal sub_out_x, mux_out_x, mux_out_y, reg_out_x, reg_out_y : std_logic_vector(width - 1 downto 0);
begin
  -- Wire everything up right
  U_MUX_X : mux_2x1_2
    generic map (
      width => width)
    port map (
      a => x,
      b => sub_out_x,
      sel => x_sel,
      output => mux_out_x
    );
  U_MUX_Y : mux_2x1_2
    generic map (
      width => width)
    port map (
      a => y,
      b => sub_out_x,
      sel => y_sel,
      output => mux_out_y
    );
  U_REG_TMPX : reg_2
    generic map (
      width => width)
    port map (
      clk => clk,
      rst => rst,
      enable => x_en,
      input => mux_out_x,
      output => reg_out_x
    );
  U_REG_TMPY : reg_2
    generic map (
      width => width)
    port map (
      clk => clk,
      rst => rst,
      enable => y_en,
      input => mux_out_y,
      output => reg_out_y
    );
  U_REG_OUTPUT : reg_2
    generic map (
      width => width)
    port map (
      clk => clk,
      rst => rst,
      enable => output_en,
      input => reg_out_x,
      output => output
    );
  U_COMP : comparator_2
    generic map (
      width => width)
    port map (
      x => reg_out_x,
      y => reg_out_y,
      x_lt => x_lt_y,
      x_ne => x_ne_y
    );
  U_SUB_X : subtractor_2
    generic map (
      width => width)
    port map (
      in1 => reg_out_x,
      in2 => reg_out_y,
      output => sub_out_x
    );
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- It's a mux
entity mux_2x1_2 is
  generic (
    WIDTH : positive := 16);
  port (
    a, b    : in std_logic_vector(width-1 downto 0);
    sel     : in std_logic;
    output  : out std_logic_vector(width-1 downto 0));
end mux_2x1_2;

architecture mux_2x1 of mux_2x1_2 is
begin
  process(a, b, sel)
  begin
    if sel = '0' then
      output <= a;
    else
      output <= b;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Regular register with enable, clock, and reset
entity reg_2 is
  generic (
    WIDTH : positive := 16);
  port (
    enable, clk, rst  : in std_logic;
    input             : in std_logic_vector(width-1 downto 0);
    output            : out std_logic_vector(width-1 downto 0));
end reg_2;

architecture reg of reg_2 is
begin
  process(clk, rst)
  begin
    if rst = '1' then
      output <= (others => '0');
    elsif rising_edge(clk) then
      if enable = '1' then
        output <= input;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Find if x is less than y and if x is not equal to y
entity comparator_2 is
  generic (
    WIDTH : positive := 16);
  port (
    x, y        : in std_logic_vector(width-1 downto 0);
    x_lt, x_ne  : out std_logic);
end comparator_2;

architecture comparator of comparator_2 is
begin
  process(x, y)
  begin
    -- Assign default output values
    -- Only assign them to true if it is true
    x_lt <= '0';
    x_ne <= '0';
    if x < y then
      x_lt <= '1';
    end if;
    if x /= y then
      x_ne <= '1';
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtractor_2 is
  generic (
    WIDTH : positive := 16);
  port (
    in1, in2   : in std_logic_vector(width-1 downto 0);
    output     : out std_logic_vector(width-1 downto 0));
end entity;

architecture subtractor of subtractor_2 is
begin
process(in1, in2)
  variable temp : unsigned(width downto 0);
begin
  -- Check to see in what order you should be subtracting
  -- Where the output goes will be determined by the controller
  if in1 > in2 then
    temp := resize(unsigned(in1), WIDTH+1) - resize(unsigned(in2), WIDTH+1);
  else
    temp := resize(unsigned(in2), WIDTH+1) - resize(unsigned(in1), WIDTH+1);
  end if;
  output <= std_logic_vector(resize(temp, width));
end process;

end architecture;
