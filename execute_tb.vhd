LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity execute_tb is
end execute_tb;

architecture behaviour of execute_tb is

    component execute is
        port(
            clk          : in  STD_LOGIC;
            reset        : in  STD_LOGIC;
            A            : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            B            : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            Imm          : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            IR           : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            NPC          : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALUSrc       : in  STD_LOGIC;
            ALUFunc      : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
            Branch       : in  STD_LOGIC;
            BranchType   : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
            Jump         : in  STD_LOGIC;
            JumpReg      : in  STD_LOGIC;
            MemRead      : in  STD_LOGIC;
            MemWrite     : in  STD_LOGIC;
            RegWrite     : in  STD_LOGIC;
            MemToReg     : in  STD_LOGIC;
            ALUResult    : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            B_out        : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            IR_out       : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            NPC_out      : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            BranchTaken  : out STD_LOGIC;
            BranchTarget : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            MemRead_out  : out STD_LOGIC;
            MemWrite_out : out STD_LOGIC;
            RegWrite_out : out STD_LOGIC;
            MemToReg_out : out STD_LOGIC;
            Jump_out     : out STD_LOGIC;
            JumpReg_out  : out STD_LOGIC
        );
    end component;

    constant CLK_PERIOD : time := 1 ns;

    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';

    signal A          : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal B          : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal Imm        : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal IR         : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal NPC        : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal ALUSrc     : STD_LOGIC := '0';
    signal ALUFunc    : STD_LOGIC_VECTOR(3 DOWNTO 0)  := (others => '0');
    signal Branch     : STD_LOGIC := '0';
    signal BranchType : STD_LOGIC_VECTOR(2 DOWNTO 0)  := (others => '0');
    signal Jump       : STD_LOGIC := '0';
    signal JumpReg    : STD_LOGIC := '0';
    signal MemRead    : STD_LOGIC := '0';
    signal MemWrite   : STD_LOGIC := '0';
    signal RegWrite   : STD_LOGIC := '0';
    signal MemToReg   : STD_LOGIC := '0';

    signal ALUResult    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal B_out        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal IR_out       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal NPC_out      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal BranchTaken  : STD_LOGIC;
    signal BranchTarget : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal MemRead_out  : STD_LOGIC;
    signal MemWrite_out : STD_LOGIC;
    signal RegWrite_out : STD_LOGIC;
    signal MemToReg_out : STD_LOGIC;
    signal Jump_out     : STD_LOGIC;
    signal JumpReg_out  : STD_LOGIC;

    shared variable test_num    : INTEGER := 0;
    shared variable pass_count  : INTEGER := 0;
    shared variable fail_count  : INTEGER := 0;

    procedure tick(signal clk : inout STD_LOGIC) is
    begin
        clk <= '1';
        wait for CLK_PERIOD / 2;
        clk <= '0';
        wait for CLK_PERIOD / 2;
    end procedure;

    procedure check_slv(
        test_label    : in STRING;
        got      : in STD_LOGIC_VECTOR;
        expected : in STD_LOGIC_VECTOR
    ) is
    begin
        test_num := test_num + 1;
        if got = expected then
            pass_count := pass_count + 1;
            report "PASS [" & test_label & "]" severity note;
        else
            fail_count := fail_count + 1;
            report "FAIL [" & test_label & "] got="
                   & integer'image(to_integer(unsigned(got)))
                   & " expected="
                   & integer'image(to_integer(unsigned(expected)))
                   severity error;
        end if;
    end procedure;

    procedure check_sl(
        test_label    : in STRING;
        got      : in STD_LOGIC;
        expected : in STD_LOGIC
    ) is
    begin
        test_num := test_num + 1;
        if got = expected then
            pass_count := pass_count + 1;
            report "PASS [" & test_label & "]" severity note;
        else
            fail_count := fail_count + 1;
            report "FAIL [" & test_label & "] got="
                   & STD_LOGIC'image(got)
                   & " expected="
                   & STD_LOGIC'image(expected)
                   severity error;
        end if;
    end procedure;

    procedure set_defaults is
    begin
        A          <= (others => '0');
        B          <= (others => '0');
        Imm        <= (others => '0');
        IR         <= (others => '0');
        NPC        <= (others => '0');
        ALUSrc     <= '0';
        ALUFunc    <= "0000";
        Branch     <= '0';
        BranchType <= "000";
        Jump       <= '0';
        JumpReg    <= '0';
        MemRead    <= '0';
        MemWrite   <= '0';
        RegWrite   <= '0';
        MemToReg   <= '0';
    end procedure;

begin

    dut : execute
        port map(
            clk          => clk,
            reset        => reset,
            A            => A,
            B            => B,
            Imm          => Imm,
            IR           => IR,
            NPC          => NPC,
            ALUSrc       => ALUSrc,
            ALUFunc      => ALUFunc,
            Branch       => Branch,
            BranchType   => BranchType,
            Jump         => Jump,
            JumpReg      => JumpReg,
            MemRead      => MemRead,
            MemWrite     => MemWrite,
            RegWrite     => RegWrite,
            MemToReg     => MemToReg,
            ALUResult    => ALUResult,
            B_out        => B_out,
            IR_out       => IR_out,
            NPC_out      => NPC_out,
            BranchTaken  => BranchTaken,
            BranchTarget => BranchTarget,
            MemRead_out  => MemRead_out,
            MemWrite_out => MemWrite_out,
            RegWrite_out => RegWrite_out,
            MemToReg_out => MemToReg_out,
            Jump_out     => Jump_out,
            JumpReg_out  => JumpReg_out
        );

    stim : process
    begin
        report "--- 1. Reset ---" severity note;
        set_defaults;
        reset <= '1';
        tick(clk);
        check_slv("reset ALUResult",    ALUResult,    x"00000000");
        check_slv("reset B_out",        B_out,        x"00000000");
        check_sl ("reset BranchTaken",  BranchTaken,  '0');
        check_sl ("reset RegWrite_out", RegWrite_out, '0');
        check_sl ("reset MemRead_out",  MemRead_out,  '0');
        check_sl ("reset MemWrite_out", MemWrite_out, '0');
        check_sl ("reset Jump_out",     Jump_out,     '0');
        check_sl ("reset JumpReg_out",  JumpReg_out,  '0');

        reset <= '0';

        report "--- 2. R-type ALU ops ---" severity note;

        set_defaults;
        A       <= std_logic_vector(to_signed(10, 32));
        B       <= std_logic_vector(to_signed(20, 32));
        ALUSrc  <= '0';
        ALUFunc <= "0000";
        RegWrite <= '1';
        tick(clk);
        check_slv("add 10+20", ALUResult, std_logic_vector(to_signed(30, 32)));
        check_sl ("add RegWrite_out", RegWrite_out, '1');

        set_defaults;
        A       <= std_logic_vector(to_signed(50, 32));
        B       <= std_logic_vector(to_signed(17, 32));
        ALUSrc  <= '0';
        ALUFunc <= "0001";
        tick(clk);
        check_slv("sub 50-17", ALUResult, std_logic_vector(to_signed(33, 32)));

        set_defaults;
        A       <= x"00000000";
        B       <= x"00000001";
        ALUSrc  <= '0';
        ALUFunc <= "0001";
        tick(clk);
        check_slv("sub underflow 0-1", ALUResult, x"FFFFFFFF");

        set_defaults;
        A       <= std_logic_vector(to_signed(6, 32));
        B       <= std_logic_vector(to_signed(7, 32));
        ALUSrc  <= '0';
        ALUFunc <= "0010";
        tick(clk);
        check_slv("mul 6*7", ALUResult, std_logic_vector(to_signed(42, 32)));

        set_defaults;
        A       <= std_logic_vector(to_signed(-3, 32));
        B       <= std_logic_vector(to_signed(4, 32));
        ALUSrc  <= '0';
        ALUFunc <= "0010";
        tick(clk);
        check_slv("mul -3*4", ALUResult, std_logic_vector(to_signed(-12, 32)));

        set_defaults;
        A       <= x"0000FF00";
        B       <= x"00000F0F";
        ALUSrc  <= '0';
        ALUFunc <= "0011";
        tick(clk);
        check_slv("and", ALUResult, x"00000F00");

        set_defaults;
        A       <= x"0000F0F0";
        B       <= x"00000F0F";
        ALUSrc  <= '0';
        ALUFunc <= "0100";
        tick(clk);
        check_slv("or", ALUResult, x"0000FFFF");

        set_defaults;
        A       <= x"0000AAAA";
        B       <= x"00005555";
        ALUSrc  <= '0';
        ALUFunc <= "1000";
        tick(clk);
        check_slv("xor", ALUResult, x"0000FFFF");

        set_defaults;
        A       <= x"00000001";
        B       <= x"00000004";
        ALUSrc  <= '0';
        ALUFunc <= "0101";
        tick(clk);
        check_slv("sll 1<<4", ALUResult, x"00000010");

        set_defaults;
        A       <= x"80000000";
        B       <= x"00000001";
        ALUSrc  <= '0';
        ALUFunc <= "0110";
        tick(clk);
        check_slv("srl 0x80000000>>1", ALUResult, x"40000000");

        set_defaults;
        A       <= x"80000000";
        B       <= x"00000001";
        ALUSrc  <= '0';
        ALUFunc <= "0111";
        tick(clk);
        check_slv("sra 0x80000000>>1", ALUResult, x"C0000000");

        set_defaults;
        A       <= std_logic_vector(to_signed(-1, 32));
        B       <= std_logic_vector(to_signed(1, 32));
        ALUSrc  <= '0';
        ALUFunc <= "1001";
        tick(clk);
        check_slv("slt -1<1 → 1", ALUResult, x"00000001");

        set_defaults;
        A       <= std_logic_vector(to_signed(5, 32));
        B       <= std_logic_vector(to_signed(3, 32));
        ALUSrc  <= '0';
        ALUFunc <= "1001";
        tick(clk);
        check_slv("slt 5<3 → 0", ALUResult, x"00000000");

        report "--- 3. I-type ALU ops ---" severity note;

        set_defaults;
        A       <= std_logic_vector(to_signed(100, 32));
        Imm     <= std_logic_vector(to_signed(-4, 32));
        ALUSrc  <= '1';
        ALUFunc <= "0000";
        tick(clk);
        check_slv("addi 100+(-4)", ALUResult, std_logic_vector(to_signed(96, 32)));

        set_defaults;
        A       <= x"000000FF";
        Imm     <= x"0000000F";
        ALUSrc  <= '1';
        ALUFunc <= "1000";
        tick(clk);
        check_slv("xori", ALUResult, x"000000F0");

        set_defaults;
        A       <= x"000000F0";
        Imm     <= x"0000000F";
        ALUSrc  <= '1';
        ALUFunc <= "0100";
        tick(clk);
        check_slv("ori", ALUResult, x"000000FF");

        set_defaults;
        A       <= x"000000FF";
        Imm     <= x"00000055";
        ALUSrc  <= '1';
        ALUFunc <= "0011";
        tick(clk);
        check_slv("andi", ALUResult, x"00000055");

        set_defaults;
        A       <= std_logic_vector(to_signed(-5, 32));
        Imm     <= std_logic_vector(to_signed(10, 32));
        ALUSrc  <= '1';
        ALUFunc <= "1001";
        tick(clk);
        check_slv("slti -5<10 → 1", ALUResult, x"00000001");

        report "--- 4. auipc ---" severity note;

        set_defaults;
        A       <= x"DEADBEEF";
        Imm     <= x"00005000";
        NPC     <= x"00000100";
        IR      <= "00000000000000000000000000010111";
        ALUSrc  <= '1';
        ALUFunc <= "0000";
        tick(clk);
        check_slv("auipc NPC+Imm",
                  ALUResult,
                  std_logic_vector(unsigned(x"00000100") + unsigned(x"00005000")));

        report "--- 5. Load address (lw) ---" severity note;

        set_defaults;
        A       <= std_logic_vector(to_signed(100, 32));
        Imm     <= std_logic_vector(to_signed(8, 32));
        ALUSrc  <= '1';
        ALUFunc <= "0000";
        MemRead <= '1';
        MemToReg<= '1';
        RegWrite<= '1';
        tick(clk);
        check_slv("lw addr 100+8", ALUResult, std_logic_vector(to_signed(108, 32)));
        check_sl ("lw MemRead_out",  MemRead_out,  '1');
        check_sl ("lw MemToReg_out", MemToReg_out, '1');
        check_sl ("lw RegWrite_out", RegWrite_out, '1');

        report "--- 6. Store B pass-through (sw) ---" severity note;

        set_defaults;
        A        <= std_logic_vector(to_signed(200, 32));
        B        <= x"CAFEBABE";
        Imm      <= std_logic_vector(to_signed(4, 32));
        ALUSrc   <= '1';
        ALUFunc  <= "0000";
        MemWrite <= '1';
        tick(clk);
        check_slv("sw addr 200+4", ALUResult, std_logic_vector(to_signed(204, 32)));
        check_slv("sw B_out",      B_out,     x"CAFEBABE");
        check_sl ("sw MemWrite_out", MemWrite_out, '1');

        report "--- 7. Branch instructions ---" severity note;

        set_defaults;
        A          <= x"00000005";
        B          <= x"00000005";
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "000";
        tick(clk);
        check_sl ("beq taken BranchTaken", BranchTaken, '1');
        check_slv("beq taken BranchTarget", BranchTarget, x"00000030");

        set_defaults;
        A          <= x"00000005";
        B          <= x"00000006";
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "000";
        tick(clk);
        check_sl("beq not taken", BranchTaken, '0');

        set_defaults;
        A          <= x"00000001";
        B          <= x"00000002";
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "001";
        tick(clk);
        check_sl("bne taken", BranchTaken, '1');

        set_defaults;
        A          <= x"00000007";
        B          <= x"00000007";
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "001";
        tick(clk);
        check_sl("bne not taken", BranchTaken, '0');

        set_defaults;
        A          <= std_logic_vector(to_signed(-1, 32));
        B          <= std_logic_vector(to_signed(1, 32));
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "100";
        tick(clk);
        check_sl("blt taken (-1<1)", BranchTaken, '1');

        set_defaults;
        A          <= std_logic_vector(to_signed(5, 32));
        B          <= std_logic_vector(to_signed(3, 32));
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "100";
        tick(clk);
        check_sl("blt not taken (5<3 false)", BranchTaken, '0');

        set_defaults;
        A          <= std_logic_vector(to_signed(3, 32));
        B          <= std_logic_vector(to_signed(3, 32));
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "101";
        tick(clk);
        check_sl("bge taken (3>=3)", BranchTaken, '1');

        set_defaults;
        A          <= std_logic_vector(to_signed(5, 32));
        B          <= std_logic_vector(to_signed(3, 32));
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "101";
        tick(clk);
        check_sl("bge taken (5>=3)", BranchTaken, '1');

        set_defaults;
        A          <= std_logic_vector(to_signed(-1, 32));
        B          <= std_logic_vector(to_signed(1, 32));
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "101";
        tick(clk);
        check_sl("bge not taken (-1>=1 false)", BranchTaken, '0');

        set_defaults;
        A          <= x"00000001";
        B          <= x"FFFFFFFF";
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "110";
        tick(clk);
        check_sl("bltu taken (1 <u 0xFFFFFFFF)", BranchTaken, '1');

        set_defaults;
        A          <= x"FFFFFFFF";
        B          <= x"00000001";
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "110";
        tick(clk);
        check_sl("bltu not taken (0xFFFFFFFF<u 1 false)", BranchTaken, '0');

        set_defaults;
        A          <= x"FFFFFFFF";
        B          <= x"00000001";
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "111";
        tick(clk);
        check_sl("bgeu taken (0xFFFF>=u 1)", BranchTaken, '1');

        set_defaults;
        A          <= x"00000001";
        B          <= x"FFFFFFFF";
        NPC        <= x"00000010";
        Imm        <= x"00000020";
        Branch     <= '1';
        BranchType <= "111";
        tick(clk);
        check_sl("bgeu not taken (1>=u 0xFFFF false)", BranchTaken, '0');

        set_defaults;
        A          <= x"00000005";
        B          <= x"00000005";
        Branch     <= '0';
        BranchType <= "000";
        tick(clk);
        check_sl("no-branch signal: BranchTaken=0", BranchTaken, '0');

        report "--- 8. JAL ---" severity note;

        set_defaults;
        NPC     <= x"00000100";
        Imm     <= x"00000040";
        Jump    <= '1';
        ALUSrc  <= '1';
        ALUFunc <= "0000";
        RegWrite<= '1';
        tick(clk);
        check_sl ("jal BranchTaken",   BranchTaken,  '1');
        check_slv("jal BranchTarget",  BranchTarget, x"00000140");
        check_sl ("jal Jump_out",      Jump_out,     '1');
        check_sl ("jal RegWrite_out",  RegWrite_out, '1');

        report "--- 9. JALR ---" severity note;

        set_defaults;
        A       <= x"00000100";
        Imm     <= x"00000004";
        JumpReg <= '1';
        ALUSrc  <= '1';
        ALUFunc <= "0000";
        RegWrite<= '1';
        tick(clk);
        check_sl ("jalr BranchTaken",   BranchTaken,  '1');
        check_slv("jalr BranchTarget",  BranchTarget, x"00000104");
        check_sl ("jalr JumpReg_out",   JumpReg_out,  '1');

        set_defaults;
        A       <= x"00000101";
        Imm     <= x"00000004";
        JumpReg <= '1';
        ALUSrc  <= '1';
        ALUFunc <= "0000";
        tick(clk);
        check_slv("jalr bit0 clear", BranchTarget, x"00000104");

        report "--- 10. Control signal pass-through ---" severity note;

        set_defaults;
        MemRead  <= '1';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '1';
        Jump     <= '0';
        JumpReg  <= '0';
        tick(clk);
        check_sl("ctrl MemRead_out",  MemRead_out,  '1');
        check_sl("ctrl MemWrite_out", MemWrite_out, '0');
        check_sl("ctrl RegWrite_out", RegWrite_out, '1');
        check_sl("ctrl MemToReg_out", MemToReg_out, '1');
        check_sl("ctrl Jump_out",     Jump_out,     '0');
        check_sl("ctrl JumpReg_out",  JumpReg_out,  '0');

        set_defaults;
        MemRead  <= '0';
        MemWrite <= '1';
        RegWrite <= '0';
        MemToReg <= '0';
        Jump     <= '1';
        JumpReg  <= '0';
        tick(clk);
        check_sl("ctrl2 MemRead_out",  MemRead_out,  '0');
        check_sl("ctrl2 MemWrite_out", MemWrite_out, '1');
        check_sl("ctrl2 RegWrite_out", RegWrite_out, '0');
        check_sl("ctrl2 MemToReg_out", MemToReg_out, '0');
        check_sl("ctrl2 Jump_out",     Jump_out,     '1');

        report "--- 11. IR and NPC pass-through ---" severity note;

        set_defaults;
        IR  <= x"DEADC0DE";
        NPC <= x"BABE0004";
        tick(clk);
        check_slv("IR_out",  IR_out,  x"DEADC0DE");
        check_slv("NPC_out", NPC_out, x"BABE0004");

        report "--- 12. Pipeline register hold ---" severity note;

        set_defaults;
        A       <= x"00000003";
        B       <= x"00000004";
        ALUSrc  <= '0';
        ALUFunc <= "0000";
        tick(clk);
        check_slv("hold: first cycle result", ALUResult, x"00000007");

        A <= x"FFFFFFFF";
        B <= x"FFFFFFFF";
        wait for CLK_PERIOD / 4;
        check_slv("hold: output unchanged mid-cycle", ALUResult, x"00000007");

        tick(clk);
        check_slv("hold: updated after next clock", ALUResult, x"FFFFFFFE");

        report "======================================" severity note;
        report "Tests run  : " & integer'image(test_num)   severity note;
        report "Passed     : " & integer'image(pass_count) severity note;
        report "Failed     : " & integer'image(fail_count) severity note;
        report "======================================" severity note;

        if fail_count = 0 then
            report "ALL TESTS PASSED" severity note;
        else
            report "SOME TESTS FAILED" severity failure;
        end if;

        wait;
    end process;

end behaviour;