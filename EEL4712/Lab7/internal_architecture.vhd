--- --- --- --- --- --- --- --- --- ---
--- --- --- --- ALU --- --- --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.internal_lib.all;

entity ALU is
  generic ( width : positive := 8);
  port (
    a, d        : in std_logic_vector(width-1 downto 0);
    cin         : in std_logic;
    sel         : in std_logic_vector(3 downto 0);
    output      : out std_logic_vector(width-1 downto 0);
    c, z, v, s  : out std_logic
  );
end entity;

architecture arch of ALU is
  constant zeroes  : unsigned(width-1 downto 0) := (others => '0');
begin
  COMBINATIONAL : process(a, d, cin, sel)
    variable temp    : unsigned(width downto 0);
    variable carry   : unsigned(width-1 downto 0);
  begin
    carry := to_unsigned(0, width-1) & cin;
	 temp := (others => '0');
    output <= (others => '0');
    c <= '0';
    z <= '0';
    v <= '0';
    s <= '0';
    case sel is
        when ALU_ADCR =>
          temp := resize(unsigned(a), width+1) + resize(unsigned(d), width+1) + resize(unsigned(carry), width+1);
          c <= temp(width);
          if (a(width-1) = d(width-1)) and temp(width-1) = not(a(width-1)) then
            v <= '1' ;
          end if;
        when ALU_SBCR =>
          temp := resize(unsigned(a), width+1) + resize(unsigned(not d), width+1) + resize(unsigned(carry), width+1);
          c <= temp(width);
          if (a(width-1) = d(width-1)) and (temp(width-1) = not(a(width-1))) then
            v <= '1' ;
          end if;
        when ALU_CMPR =>
          temp := resize(unsigned(a), width+1) + resize(unsigned(not d), width+1) + resize(unsigned(carry), width+1);
          c <= temp(width);
          if (a(width-1) = d(width-1)) and (temp(width-1) = not(a(width-1))) then
            v <= '1' ;
          end if;
        when ALU_ANDR =>
          temp := unsigned('0' & (a and d));
        when ALU_ORR =>
          temp := unsigned('0' & (a or d));
        when ALU_XORR =>
          temp := unsigned('0' & (a xor d));
        when ALU_SLRL =>
          temp := unsigned('0' & (SHIFT_LEFT(unsigned(a), 1)));
          c <= a(width-1);
        when ALU_SRRL =>
          temp := unsigned('0' & (SHIFT_RIGHT(unsigned(a), 1)));
          c <= a(0);
        when ALU_ROLC =>
          temp := unsigned('0' & unsigned(a(width-2 downto 0)) & cin);
          c <= a(width-1);
        when ALU_RORC =>
          temp := unsigned('0' & cin & unsigned(a(width-1 downto 1)));
          c <= a(0);
        when ALU_DECA =>
          temp := unsigned('0' & a) - to_unsigned(1, temp'length);
        when ALU_INCA =>
          temp := unsigned('0' & a) + to_unsigned(1, temp'length);
        when ALU_ZS =>
          temp := '0' & unsigned(a);
        when ALU_SETC =>
          c <= '1';
        when ALU_CLRC =>
          c <= '0';
        when others => null;
    end case;
    if temp(width-1 downto 0) = to_unsigned(0, output'length) then
      z <= '1';
    end if;
    s <= temp(width-1);
    output <= std_logic_vector(resize(temp, width));
  end process;
end architecture;



--- --- --- --- --- --- --- --- --- ---
--- --- ---  Register   --- --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity reg is
  generic ( width : positive := 8);
  port (
    input           : in std_logic_vector(width-1 downto 0);
    clk, rst, en    : in std_logic;
    output          : out std_logic_vector(width-1 downto 0)
  );
end entity;

architecture arch of reg is
begin
  sequential : process(clk, rst)
  begin
    if rst = '1' then
        output <= (others => '0');
    elsif rising_edge(clk) then
        if en = '1' then
          output <= input;
        end if;
    end if;
  end process;
end architecture;
--- --- --- --- --- --- --- --- --- ---
--- --- --- --- FF  --- --- --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ff is
  generic ( width : positive := 8);
  port (
    input           : in std_logic;
    clk, rst, en    : in std_logic;
    output          : out std_logic
  );
end entity;

architecture arch of ff is
begin
  sequential : process(clk, rst)
  begin
    if rst = '1' then
        output <= '0';
    elsif rising_edge(clk) then
        if en = '1' then
          output <= input;
        end if;
    end if;
  end process;
end architecture;


--- --- --- --- --- --- --- --- --- ---
--- --- --- --- Bus --- --- --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.internal_lib.all;

entity bus_8bit is
  generic (
    width  :     positive := 8);
  port (
    inputs : in  busIn(0 to width-1);
    sel    : in  std_logic_vector((integer(ceil(log2(real(width))))-1) downto 0);
    output : out std_logic_vector(7 downto 0));
end bus_8bit;

architecture STR of bus_8bit is
begin
  output <= inputs(to_integer(unsigned(sel)));
end STR;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.internal_lib.all;

entity bus_16bit is
  generic (
    width  :     positive := 4);
  port (
    inputs : in  bigBus(0 to width-1);
    sel    : in  std_logic_vector((integer(ceil(log2(real(width))))-1) downto 0);
    output : out std_logic_vector(15 downto 0));
end bus_16bit;

architecture STR of bus_16bit is
begin
  output <= inputs(to_integer(unsigned(sel)));
end STR;


--- --- --- --- --- --- --- --- --- ---
--- --- --- --- MUX --- --- --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
entity mux2x1 is
  generic (
    width  :     positive := 8);
  port (
    in1    : in  std_logic_vector(width-1 downto 0);
    in2    : in  std_logic_vector(width-1 downto 0);
    sel    : in  std_logic;
    output : out std_logic_vector(width-1 downto 0));
end mux2x1;

architecture BHV of mux2x1 is
begin
  with sel select
    output <=
    in2 when '1',
    in1 when others;
end BHV;
--3 x 1
library ieee;
use ieee.std_logic_1164.all;
entity mux3x1 is
  generic (
    width  :     positive := 16);
  port (
    in1    : in  std_logic_vector(width-1 downto 0);
    in2    : in  std_logic_vector(width-1 downto 0);
    in3    : in std_logic_vector(width-1 downto 0);
    sel    : in  std_logic_vector(1 downto 0);
    output : out std_logic_vector(width-1 downto 0));
end mux3x1;

architecture BHV of mux3x1 is
  signal temp : std_logic_vector(width-1 downto 0);
begin
  temp <= (others => '0');
  with sel select
    output <=
    in1 when "00",
    in2 when "01",
    in3 when "10",
    temp when others;
end BHV;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity incrementer is
  generic (
    width  :     positive := 16);
  port (
    in1    : in  std_logic_vector(width-1 downto 0);
    sel    : in  std_logic_vector(1 downto 0);
    output : out std_logic_vector(width-1 downto 0));
end incrementer;

architecture BHV of incrementer is
begin
  output <= std_logic_vector(resize(resize(unsigned(in1), width+1) + resize(unsigned(sel), width+1), width));
end BHV;

--- --- --- --- --- --- --- --- --- ---
--- --- --- ---  PC --- --- --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.internal_lib.all;

entity program_counter is
  port (
    clk, rst 		                : in std_logic;
    count, address              : in std_logic_vector(15 downto 0);
    pc_l_sel, pc_h_sel, pc_en   : in std_logic_vector(1 downto 0);
    inc_sel                     : in std_logic_vector(1 downto 0);
    output                      : out std_logic_vector(15 downto 0)
  );
end entity;

architecture arch of program_counter is
  signal pc_h, pc_l  : std_logic_vector(7 downto 0);
  signal pc_pre_inc  : std_logic_vector(15 downto 0);
  signal pc_post_inc : std_logic_vector(15 downto 0);
begin
  output <= pc_h & pc_l;
  U_MUX_H : entity work.mux3x1
    generic map( width => 8)
    port map (
        in1     => count(15 downto 8),
        in2     => pc_post_inc(15 downto 8),
        in3     => address(15 downto 8),
        sel     => pc_h_sel,
        output  => pc_h
    );

  U_MUX_L : entity work.mux3x1
  generic map( width => 8)
  port map (
      in1     => count(7 downto 0),
      in2     => pc_post_inc(7 downto 0),
      in3     => address(7 downto 0),
      sel     => pc_l_sel,
      output  => pc_l
  );
  U_PC_H : entity work.reg
  port map (
    input     => pc_h,
    en        => pc_en(1),
    clk       => clk,
    rst       => rst,
    output    => pc_pre_inc(15 downto 8)
  );
  U_PC_L : entity work.reg
  port map (
    input     => pc_l,
    en        => pc_en(0),
    clk       => clk,
    rst       => rst,
    output    => pc_pre_inc(7 downto 0)
  );
  U_INC_MUX : entity work.incrementer
  port map (
      in1     => pc_pre_inc,
      sel     => inc_sel,
      output  => pc_post_inc
  );
end architecture;
--- --- --- --- --- --- --- --- --- ---
--- --- --- Adder  --- --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.internal_lib.all;
entity adder is
  generic (width : positive := 16);
  port (
      in1, in2 : in std_logic_vector(width-1 downto 0);
      output   : out std_logic_vector(width-1 downto 0)
  );
end entity;

architecture arch of adder is
begin
output <= std_logic_vector(resize(resize(unsigned(in1), width+1) + resize(unsigned(in2), width+1), width));
end architecture;
--- --- --- --- --- --- --- --- --- ---
--- --- --- Index Mess  --- --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.internal_lib.all;

entity index_struct is
  port (
    clk, rst 		          : in std_logic;
    count                 : in std_logic_vector(15 downto 0);
    index_sel, index_en   : in std_logic_vector(1 downto 0);
    inc_sel               : in std_logic_vector(1 downto 0);
    output                : out std_logic_vector(15 downto 0)
  );
end entity;

architecture arch of index_struct is
  signal index_h, index_l               : std_logic_vector(7 downto 0);
  signal index_pre_inc                  : std_logic_vector(15 downto 0);
  signal index_post_inc                 : std_logic_vector(15 downto 0);
  signal negOne, posOne, zeroes, num    : std_logic_vector(15 downto 0);

begin
  output <= index_h & index_l;
  zeroes <= x"0000";
  negOne <= x"FFFF";
  posOne <= x"0001";
  U_INDEX_MUX_H : entity work.mux2x1
    port map (
        in1     => count(15 downto 8),
        in2     => index_post_inc(15 downto 8),
        sel     => index_sel(1),
        output  => index_h
    );

  U_INDEX_MUX_L : entity work.mux2x1
  port map (
      in1     => count(7 downto 0),
      in2     => index_post_inc(7 downto 0),
      sel     => index_sel(0),
      output  => index_l
  );
  U_INDEX_H : entity work.reg
  port map (
    input     => index_h,
    en        => index_en(1),
    clk       => clk,
    rst       => rst,
    output    => index_pre_inc(15 downto 8)
  );
  U_INDEX_L : entity work.reg
  port map (
    input     => index_l,
    en        => index_en(0),
    clk       => clk,
    rst       => rst,
    output    => index_pre_inc(7 downto 0)
  );
  U_INDEX_INC_MUX : entity work.mux3x1
  generic map (width => 16)
  port map (
      in1     => zeroes,
      in2     => negOne,
      in3     => posOne,
      sel     => inc_sel,
      output  => num
  );
  U_INDEX_INC : entity work.adder
  port map (
    in1 => num,
    in2 => index_pre_inc,
    output => index_post_inc
  );
end architecture;
--- --- --- --- --- --- --- --- --- ---
--- --- ---  Status Reg --- --- --- ---
--- --- --- --- --- --- --- --- --- ---
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity status_reg is
  port (
    clk, rst               : in std_logic;
    c_en, v_en, z_en, s_en : in std_logic;
    c, v, z, s             : in std_logic;
    output                 : out std_logic_vector(3 downto 0)
  );
end entity;

architecture arch of status_reg is
  signal c_out, z_out, v_out, s_out : std_logic;
begin
  output <= c_out & v_out & z_out & s_out;
  U_C_FLAG : entity work.ff
  generic map (width => 1)
  port map (
    input     => c,
    en        => c_en,
    clk       => clk,
    rst       => rst,
    output    => c_out
  );
  U_Z_FLAG : entity work.ff
  generic map (width => 1)
  port map (
    input     => z,
    en        => z_en,
    clk       => clk,
    rst       => rst,
    output    => z_out
  );
  U_V_FLAG : entity work.ff
  generic map (width => 1)
  port map (
    input     => v,
    en        => v_en,
    clk       => clk,
    rst       => rst,
    output    => v_out
  );
  U_S_FLAG : entity work.ff
  generic map (width => 1)
  port map (
    input     => s,
    en        => s_en,
    clk       => clk,
    rst       => rst,
    output    => s_out
  );

end architecture;
