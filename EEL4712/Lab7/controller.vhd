library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.internal_lib.all;
entity controller is
  port (
      instruction                                                : in std_logic_vector(7 downto 0);
      status                                                     : in std_logic_vector(3 downto 0);
      address : in std_logic_vector(15 downto 0);
      clk, rst, go                                               : in std_logic;
      c_en, v_en, z_en, s_en, b_en, alu_en, memory_en            : out std_logic;
      acc_en, data_en, ir_en, pc_h_en, pc_l_en, x_h_en, x_l_en   : out std_logic;
      addr_h_en, addr_l_en, sp_l_en, sp_h_en                     : out std_logic;
      x_l_sel, x_h_sel, sp_h_sel, sp_l_sel                       : out std_logic;
      data_sel                                                   : out std_logic;
      led_l_en, led_h_en                                         : out std_logic;
      int_bus_sel					                                       : out std_logic_vector(3 downto 0);
      pc_h_sel, pc_l_sel, mux_acc_sel                            : out std_logic_vector(1 downto 0);
      addr_sel, inc_sel, index_inc_sel, sp_inc_sel               : out std_logic_vector(1 downto 0);
      ext_bus_sel 																               : out std_logic_vector(1 downto 0);
      alu_sel                                                    : out std_logic_vector(3 downto 0)

  );
end entity;

architecture arch of controller is

  signal state, next_state : STATE_TYPE;

begin
  sequential : process(clk, rst)
  begin
    if rst = '1' then
      state <= INIT;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  define_states : process(instruction, state, status, go, address)
  begin
    c_en          <= '0';
    v_en          <= '0';
    z_en          <= '0';
    s_en          <= '0';
    b_en          <= '0';
    alu_en        <= '0';
    acc_en        <= '0';
    data_en       <= '0';
    pc_h_en       <= '0';
    ir_en         <= '0';
    pc_l_en       <= '0';
    x_h_en        <= '0';
    x_l_en        <= '0';
    addr_h_en     <= '0';
    addr_l_en     <= '0';
    sp_h_en       <= '0';
    sp_l_en       <= '0';
    memory_en     <= '0';
    sp_l_sel      <= '0';
    sp_h_sel      <= '0';
    data_sel      <= '0';
    sp_inc_sel    <= "00";
    x_l_sel       <= '1';
    x_h_sel       <= '1';
    led_l_en      <= '0';
    led_h_en      <= '0';
    index_inc_sel <= "00";
    mux_acc_sel   <= "00";
    pc_h_sel      <= "01";
    pc_l_sel      <= "01";
    addr_sel      <= ADDR_ADDR;
    alu_sel       <= "0000";
    int_bus_sel   <= "0000";
    ext_bus_sel   <= "00";
    inc_sel       <= "00";

    next_state <= state;

    case state is


        when INIT =>
          pc_h_sel    <= "00";
          pc_l_sel    <= "00";
          next_state <= FETCH;
        when FETCH =>
          pc_h_en <= '1';
          pc_l_en <= '1';
          addr_sel <= ADDR_PC;
          next_state <= READ_FROM_MEMORY;
        when READ_FROM_MEMORY =>
          --Enable is set to read by default
          -- since the output is not registered send it to the data bus
          ext_bus_sel <= RAM_L;
          next_state <= TRANSFER_EXT_TO_INT;
        when TRANSFER_EXT_TO_INT =>
          int_bus_sel <= RAM_REG;
          ir_en <= '1';
          next_state <= DECODE;
        when DECODE =>
            if instruction = LDAI or instruction = LDAA or instruction = STAA or instruction = LDXI or instruction = LDAX or instruction = LDSI then
                next_state <= PC_INC;
            elsif instruction = STAR then
                next_state <= STAR_0;
            elsif instruction = LDAD then
                next_state <= LDAD_0;
            elsif instruction = ADCR or instruction = SBCR or instruction = CMPR then
                next_state <= ALU_ALL_0;
            elsif instruction = ANDR or instruction = ORR or instruction = XORR or instruction =  DECA or instruction = INCA then
                next_state <= ALU_ZS_0;
            elsif instruction = SLRL or instruction = SRRL or instruction = ROLC or instruction = RORC then
                next_state <= ALU_CZS_0;
                -- cases when the branch is not taken
            elsif (instruction = BCCA and status(3) = '1') or (instruction = BCSA and status(3) = '0') or (instruction = BEQA and status(1) = '0') or (instruction = BMIA and status(0) = '0') or (instruction = BNEA and status(1) = '1') or (instruction = BPLA and status(0) = '1') or (instruction = BVCA and status(2) = '1') or (instruction = BVSA and status(2) = '0') then
                next_state <= BRANCH_NOT_TAKEN;
                -- cases when the branch is taken
            elsif instruction = BCCA or instruction = BCSA or instruction = BEQA or instruction = BMIA or instruction = BNEA or instruction = BPLA or instruction = BVCA or instruction = BVSA then
                next_state <= PC_INC;
            elsif instruction = SETC or instruction = CLRC then
                next_state <= SETC_0;
            elsif instruction = CALL then
                next_state <= PC_INC;
            elsif instruction = RET  then
                next_state <= RET_0;
              end if;

        when RET_0 =>
          sp_inc_sel <= "01";
          sp_h_sel <= '1';
          sp_l_sel <= '1';
          sp_l_en <= '1';
          sp_h_en <= '1';
          next_state <= RET_1;
        when RET_1 =>
          addr_sel <= ADDR_STACK;
          next_state <= RET_2;
        when RET_2 =>
          ext_bus_sel <= RAM_L;
          next_state <= RET_3;
        when RET_3 =>
          int_bus_sel <= RAM_REG;
          pc_h_sel <= "00";
          pc_h_en <= '1';
          sp_inc_sel <= "01";
          sp_h_sel <= '1';
          sp_l_sel <= '1';
          sp_l_en <= '1';
          sp_h_en <= '1';
          next_state <= RET_4;
        when RET_4 =>
          addr_sel <= ADDR_STACK;
          next_state <= RET_5;
        when RET_5 =>
          ext_bus_sel <= RAM_L;
          next_state <= RET_6;
        when RET_6 =>
          int_bus_sel <= RAM_REG;
          pc_l_sel <= "00";
          pc_l_en <= '1';
          next_state <= INC_FETCH;
        when CALL_0 =>
          -- Put the pc on the internal bus
          int_bus_sel <= PCL;
          next_state <= CALL_1;
        when CALL_1 =>
          -- transfer pc to external bus
          ext_bus_sel <= INTERN_BUS;
          addr_sel <= ADDR_STACK;
          -- store the pc at the value where the stack pointer is pointing
          memory_en <= '1';
          next_state <= CALL_2;
        when CALL_2 =>
            sp_inc_sel <= "10";
            sp_h_sel <= '1';
            sp_l_sel <= '1';
            sp_l_en <= '1';
            sp_h_en <= '1';
            next_state <= CALL_3;
        when CALL_3 =>
            int_bus_sel <= PCH;
            next_state <= CALL_4;
        when CALL_4 =>
            -- transfer pc to external bus
            ext_bus_sel <= INTERN_BUS;
            addr_sel <= ADDR_STACK;
            -- store the pc at the value where the stack pointer is pointing
            memory_en <= '1';
            next_state <= CALL_5;
        when CALL_5 =>
            sp_inc_sel <= "10";
            sp_h_sel <= '1';
            sp_l_sel <= '1';
            sp_l_en <= '1';
            sp_h_en <= '1';
            next_state <= CALL_6;
        when CALL_6 =>
            pc_h_sel <= "10";
            pc_l_sel <= "10";
            pc_l_en <= '1';
            pc_h_en <= '1';
            next_state <= FETCH;


        when SETC_0 =>
          if instruction = SETC then
            alu_sel <= ALU_SETC;
          else
            alu_sel <= ALU_CLRC;
          end if;
            c_en <= '1';
            next_state <= INC_FETCH;

        when BRANCH_TAKEN_0 =>
            int_bus_sel <= RAM_REG;
            b_en <= '1';
            next_state <= BRANCH_TAKEN_1;
        when BRANCH_TAKEN_1 =>
            -- INCREMENT PC
            inc_sel <= "01";
            pc_h_en <= '1';
            pc_l_en <= '1';
            -- put PC on the address bus
            addr_sel <= ADDR_PC;
            next_state <= BRANCH_TAKEN_2;
        when BRANCH_TAKEN_2 =>
            ext_bus_sel <= RAM_L;
            next_state <= BRANCH_TAKEN_3;
        when BRANCH_TAKEN_3 =>
            int_bus_sel <= RAM_REG;
            pc_h_sel <= "00";
            pc_h_en <= '1';
            next_state <= BRANCH_TAKEN_4;

        when BRANCH_TAKEN_4 =>
            int_bus_sel <= B_REG;
            pc_l_sel <= "00";
            pc_l_en <= '1';
            addr_sel <= ADDR_PC;
            next_state <= FETCH;

        when BRANCH_NOT_TAKEN =>
            inc_sel <= "11";
            pc_h_en <= '1';
            pc_l_en <= '1';
            addr_sel <= ADDR_PC;
            next_state <= FETCH;

        when PC_INC =>
            -- INCREMENT PC
            inc_sel <= "01";
            pc_h_en <= '1';
            pc_l_en <= '1';
            -- put PC on the address bus
            addr_sel <= ADDR_PC;
            next_state <= GET_RAM;
        when GET_RAM =>
            -- AR_L = RAM[PC]
            -- read from RAM
            -- put RAM on the ext bus
            addr_sel <= ADDR_PC;
            ext_bus_sel <= RAM_L;
            if instruction = LDAI then
              next_state <= LDAI_0;
            elsif instruction = LDAX then
              next_state <= LDAX_0;
            elsif instruction = BCCA or instruction = BCSA or instruction = BEQA or instruction = BMIA or instruction = BNEA or instruction = BPLA or instruction = BVCA or instruction = BVSA then
              next_state <= BRANCH_TAKEN_0;
            else
              next_state <= LOAD_ADDR_0;
            end if;


        when LDAX_0 =>
            int_bus_sel <= RAM_REG;
            b_en <= '1';
            next_state <= LDAX_1;
        when LDAX_1 =>
            addr_sel <= ADDR_INDEX;
            next_state <= LDAX_2;
        when LDAX_2 =>
            ext_bus_sel <= RAM_L;
            next_state <= LDAX_3;
        when LDAX_3 =>
            int_bus_sel <= RAM_REG;
            acc_en <= '1';
            next_state <= INC_FETCH;
        when LOAD_ADDR_0 =>
            -- transfer ext to int
            int_bus_sel <= RAM_REG;
            -- store bus into address reg low byte
            if instruction = LDXI then
              x_l_sel <= '0';
              x_l_en <= '1';
            elsif instruction = LDSI then
              sp_l_en <= '1';
            else
              addr_l_en <= '1';
            end if;
            next_state <= LOAD_ADDR_1;
        when LOAD_ADDR_1 =>
            -- INCREMENT PC
            inc_sel <= "01";
            pc_h_en <= '1';
            pc_l_en <= '1';
            -- put PC on the address bus
            addr_sel <= ADDR_PC;
            next_state <= LOAD_ADDR_2;
        when LOAD_ADDR_2 =>
            -- AR_H = RAM[PC]
            -- read from RAM
            -- put RAM on the ext bus
            ext_bus_sel <= RAM_L;
            next_state <= LOAD_ADDR_3;
        when LOAD_ADDR_3 =>
            int_bus_sel <= RAM_REG;
            if instruction = LDXI then
              x_h_sel <= '0';
              x_h_en <= '1';
              next_state <= INC_FETCH;
            elsif instruction = LDSI then
              sp_h_en <= '1';
              next_state <= INC_FETCH;
            else
              addr_h_en <= '1';
              if instruction = LDAA then
                if go = '1' then
                next_state <= LDAA_0;
                end if;
              elsif instruction = CALL then
                next_state <= CALL_0;
              else
                next_state <= STAA_0;
              end if;
            end if;


        when STAA_0 =>
            int_bus_sel <= ACC;
            next_state <= STAA_1;
        when STAA_1 =>
            ext_bus_sel <= INTERN_BUS;
            if address = x"FFFE" then
              led_l_en <= '1';
            elsif address = x"FFFF" then
              led_h_en <= '1';
            else
              memory_en <= '1';
            end if;
            next_state <= INC_FETCH;

        when LDAA_0 =>
            if address = x"FFFE" then
              ext_bus_sel <= SW0;
            elsif address = x"FFFF" then
              ext_bus_sel <= SW1;
            else
              ext_bus_sel <= RAM_L;
            end if;
            next_state <= LDAA_1;


        when LDAA_1 =>
            int_bus_sel <= RAM_REG;
            acc_en <= '1';
            next_state <= ALU_ZS_0;


        when LDAI_0 =>
            int_bus_sel <= RAM_REG;
            acc_en <= '1';
            next_state <= ALU_ZS_0;


        when STAR_0 =>
            int_bus_sel <= ACC;
            data_en <= '1';
            next_state <= INC_FETCH;

        when LDAD_0 =>
            int_bus_sel <= D;
            acc_en <= '1';
            next_state <= INC_FETCH;

        when ALU_ALL_0 =>
            if instruction = ADCR then
              alu_sel <= ALU_ADCR;
            elsif instruction = SBCR then
              alu_sel <= ALU_SBCR;
            elsif instruction = CMPR then
              alu_sel <= ALU_CMPR;
            end if;
             alu_en <= '1';
             c_en <= '1';
             v_en <= '1';
             z_en <= '1';
             s_en <= '1';
             next_state <= ALU_EN_0;
        when ALU_EN_0 =>
             mux_acc_sel <= "01";
             acc_en <= '1';
             next_state <= INC_FETCH;


        when ALU_CZS_0 =>
            if instruction = SLRL then
              alu_sel <= ALU_SLRL;
            elsif instruction = SRRL then
              alu_sel <= ALU_SRRL;
            elsif instruction = ROLC then
              alu_sel <= ALU_ROLC;
            elsif instruction = RORC then
              alu_sel <= ALU_RORC;
            end if;
             alu_en <= '1';
             c_en <= '1';
             z_en <= '1';
             s_en <= '1';
             next_state <= ALU_EN_0;



        when ALU_ZS_0 =>
            if instruction = ANDR then
              alu_sel <= ALU_ANDR;
            elsif instruction = ORR then
              alu_sel <= ALU_ORR;
            elsif instruction = XORR then
              alu_sel <= ALU_XORR;
            elsif instruction = INCA then
              alu_sel <= ALU_INCA;
            elsif instruction = DECA then
              alu_sel <= ALU_DECA;
            else
              alu_sel <= ALU_ZS;
            end if;
             alu_en <= '1';
             z_en <= '1';
             s_en <= '1';
             next_state <= ALU_EN_0;

        when INC_FETCH =>
            -- INCREMENT PC
            inc_sel <= "01";
            pc_h_en <= '1';
            pc_l_en <= '1';
            -- put PC on the address bus
            addr_sel <= ADDR_PC;
            next_state <= FETCH;

        when others => null;

    end case;


  end process;


end architecture;
