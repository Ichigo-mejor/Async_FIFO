library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity async_fifo is
    generic (
        DEPTH : integer := 8;
        WIDTH : integer := 8
    );
    port (
        wr_clk   : in  STD_LOGIC;
        wr_rst   : in  STD_LOGIC;
        wr_en    : in  STD_LOGIC;
        wr_data  : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        full     : out STD_LOGIC;

        rd_clk   : in  STD_LOGIC;
        rd_rst   : in  STD_LOGIC;
        rd_en    : in  STD_LOGIC;
        rd_data  : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        empty    : out STD_LOGIC
    );
end async_fifo;

architecture Structural of async_fifo is

    -- Memory
    type mem_type is array (0 to DEPTH-1) of STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    signal mem : mem_type;

    -- Write-side signals
    signal wr_bin       : STD_LOGIC_VECTOR(3 downto 0);
    signal wr_gray      : STD_LOGIC_VECTOR(3 downto 0);
    signal rd_gray_sync : STD_LOGIC_VECTOR(3 downto 0);

    -- Read-side signals
    signal rd_bin       : STD_LOGIC_VECTOR(3 downto 0);
    signal rd_gray      : STD_LOGIC_VECTOR(3 downto 0);
    signal wr_gray_sync : STD_LOGIC_VECTOR(3 downto 0);

    signal full_flag  : STD_LOGIC;
    signal empty_flag : STD_LOGIC;

    -- Gated enable signals (needed because port maps can't take inline expressions)
    signal wr_en_gated : STD_LOGIC;
    signal rd_en_gated : STD_LOGIC;

    component gray_counter is
        port (
            clk        : in  STD_LOGIC;
            rst        : in  STD_LOGIC;
            en         : in  STD_LOGIC;
            Y_count    : out STD_LOGIC_VECTOR(3 downto 0);
            gray_count : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component synchronizer is
        port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            async_in : in  STD_LOGIC_VECTOR(3 downto 0);
            sync_out : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

begin

    -- Gated enables
    wr_en_gated <= wr_en and not full_flag;
    rd_en_gated <= rd_en and not empty_flag;

    -- Write-side Gray counter
    WR_GC: gray_counter
        port map (
            clk        => wr_clk,
            rst        => wr_rst,
            en         => wr_en_gated,
            Y_count    => wr_bin,
            gray_count => wr_gray
        );

    -- Read-side Gray counter
    RD_GC: gray_counter
        port map (
            clk        => rd_clk,
            rst        => rd_rst,
            en         => rd_en_gated,
            Y_count    => rd_bin,
            gray_count => rd_gray
        );

    -- Synchronize write pointer into read clock domain
    SYNC_W2R: synchronizer
        port map (
            clk      => rd_clk,
            rst      => rd_rst,
            async_in => wr_gray,
            sync_out => wr_gray_sync
        );

    -- Synchronize read pointer into write clock domain
    SYNC_R2W: synchronizer
        port map (
            clk      => wr_clk,
            rst      => wr_rst,
            async_in => rd_gray,
            sync_out => rd_gray_sync
        );

    -- Memory write process
    process(wr_clk)
    begin
        if rising_edge(wr_clk) then
            if wr_en = '1' and full_flag = '0' then
                mem(to_integer(unsigned(wr_bin(2 downto 0)))) <= wr_data;
            end if;
        end if;
    end process;

    -- Memory read (combinational)
    rd_data <= mem(to_integer(unsigned(rd_bin(2 downto 0))));

    -- Full flag (write domain): compare write pointer to synchronized read pointer, top 2 bits inverted
    full_flag <= '1' when wr_gray = (not rd_gray_sync(3) & not rd_gray_sync(2) & rd_gray_sync(1 downto 0)) else '0';

    -- Empty flag (read domain): compare read pointer to synchronized write pointer
    empty_flag <= '1' when (rd_gray = wr_gray_sync) else '0';

    full  <= full_flag;
    empty <= empty_flag;

end Structural;