--Sequential Logic
library ieee;

entity reg
  generic map (
    constant WIDTH := 8;
  )
port (
  clk   : in std_logic;
  rst   : in std_logic;
  input : in std_logic_vector(width-1 downto 0);
  output :  out std_logic_vector(width-1 downto 0));
end reg;

architecture asynch_rst of reg is
begin

  -- GUIDELINE 1: ONLY CLK AND RST IN THE SENSITIVITY LIST

  process(clk, rst)
  begin
      if (rst = '1') then
          output <= (others => '0');
      elsif (rising_edge(clk)) then
          output <= input;
      end if;
  end process;
end asynch_rst;
