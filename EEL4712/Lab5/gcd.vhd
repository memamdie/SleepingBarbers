library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd is
    generic (
        WIDTH : positive := 16);
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        go     : in  std_logic;
        done   : out std_logic;
        x      : in  std_logic_vector(WIDTH-1 downto 0);
        y      : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0));
end gcd;

architecture FSMD of gcd is
  type STATE_TYPE is (STATE_START, STATE_INIT, STATE_DONE, STATE_LOOP);
  -- type STATE_TYPE_ARRAY is array (0 to 4) of STATE_TYPE;

  signal state : STATE_TYPE;

  -- constant state_array : STATE_ARRAY_TYPE := (STATE_0, STATE_INIT, STATE_DONE, STATE_LOOP);
begin  -- FSMD
  process(clk, rst)
    variable tmpX, tmpY : std_logic_vector(width-1 downto 0);
    variable temp    : unsigned(width downto 0);
  begin
    if rst = '1' then
      output <= (others => '0');
      done <= '0';
      state <= STATE_START;

    elsif rising_edge(clk) then

      case state is
          when STATE_START =>
            if go = '1' then
              state <= STATE_INIT;
            end if;

          when STATE_INIT =>
            done <= '0';
            output <= (others => '0');
            tmpX := x;
            tmpY := y;
            if tmpX /= tmpY then
              state <= STATE_LOOP;
            else
              state <= STATE_DONE;
            end if;

          when STATE_DONE =>
            output <= tmpX;
            done <= '1';
            if go = '0' then
              state <= STATE_START;
            end if;

          when STATE_LOOP =>
            done <= '0';
            output <= (others => '0');
            if tmpX < tmpY then
              temp := resize(unsigned(tmpY), WIDTH+1) - resize(unsigned(tmpX), WIDTH+1);
              tmpY := std_logic_vector(resize(temp, width));
              -- tmpY <= tmpY - tmpX;
            else
              temp := resize(unsigned(tmpX), WIDTH+1) - resize(unsigned(tmpY), WIDTH+1);
              tmpX := std_logic_vector(resize(temp, width));
              -- tmpX <= tmpX - tmpY;
            end if;
            if tmpX = tmpY then
                state <= STATE_DONE;
            end if;
          when others => null;
        end case;
    end if;
  end process;
end FSMD;

architecture FSM_D1 of gcd is
  component ctrl1
    port (
      x_en, y_en, x_sel, y_sel, output_en, done : out std_logic;
      x_lt_y, x_ne_y, go, clk, rst              : in std_logic
    );
  end component;
  component datapath1
    generic (
      WIDTH : positive);
    port (
  x, y                                              : in std_logic_vector(width-1 downto 0);
      x_en, y_en, x_sel, y_sel, output_en, clk, rst : in std_logic;
      x_lt_y, x_ne_y                                 : out std_logic;
      output                                        : out std_logic_vector(width-1 downto 0));
  end component;

  signal x_enable, y_enable, x_select, y_select, output_enable, x_less_than, x_not_equal : std_logic;


begin  -- FSM_D1


  U_DATAPATH : datapath1
      generic map (
        WIDTH => WIDTH
      )
      port map (
        clk => clk,
        rst => rst,
        x => x,
        y => y,
        x_en => x_enable,
        y_en => y_enable,
        x_sel => x_select,
        y_sel => y_select,
        output_en => output_enable,
        x_lt_y => x_less_than,
        x_ne_y => x_not_equal,
        output => output
      );
  U_CTRL1 : ctrl1
    port map (
      x_en => x_enable,
      y_en => y_enable,
      x_sel => x_select,
      y_sel => y_select,
      output_en => output_enable,
      x_lt_y => x_less_than,
      x_ne_y => x_not_equal,
      go => go,
      done => done,
      clk => clk,
      rst => rst
    );
end FSM_D1;

architecture FSM_D2 of gcd is
  component ctrl2
    port (
      x_en, y_en, x_sel, y_sel, output_en, done : out std_logic;
      x_lt_y, x_ne_y, go, clk, rst              : in std_logic
    );
  end component;
  component datapath2
    generic (
      WIDTH : positive);
    port (
  x, y                                              : in std_logic_vector(width-1 downto 0);
      x_en, y_en, x_sel, y_sel, output_en, clk, rst : in std_logic;
      x_lt_y, x_ne_y                                : out std_logic;
      output                                        : out std_logic_vector(width-1 downto 0));
  end component;

  signal x_enable, y_enable, x_select, y_select, output_enable, x_less_than, x_not_equal : std_logic;


begin  -- FSM_D2


  U_DATAPATH2 : datapath2
      generic map (
        WIDTH => WIDTH
      )
      port map (
        clk => clk,
        rst => rst,
        x => x,
        y => y,
        x_en => x_enable,
        y_en => y_enable,
        x_sel => x_select,
        y_sel => y_select,
        output_en => output_enable,
        x_lt_y => x_less_than,
        x_ne_y => x_not_equal,
        output => output
      );
  U_CTRL2 : ctrl2
    port map (
      x_en => x_enable,
      y_en => y_enable,
      x_sel => x_select,
      y_sel => y_select,
      output_en => output_enable,
      x_lt_y => x_less_than,
      x_ne_y => x_not_equal,
      go => go,
      done => done,
      clk => clk,
      rst => rst
    );
end FSM_D2;


-- EXTRA CREDIT
architecture FSMD2 of gcd is

begin  -- FSMD2
-- Not sure if the code is supposed to be different here or in the controller. But in my FSM_D2 I used 2 processes for the states
-- But the code for this section would be the same so thats where I am confused

end FSMD2;
