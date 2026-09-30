----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.09.2026 22:37:1
-- Design Name: 
-- Module Name: synchronous_fifo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all
entity sync_fifo is
    generic (
        DEPTH : integer := 8;
        WIDTH : integer := 8
    );
    port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        wr_en    : in  STD_LOGIC;
        rd_en    : in  STD_LOGIC;
        wr_data  : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        rd_data  : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        full     : out STD_LOGIC;
        empty    : out STD_LOGIC
    );
end sync_fifo;


architecture Behavioral of sync_fifo is

    type mem_type is array (0 to DEPTH-1) of STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    signal mem : mem_type;

    -- Pointers: 1 extra bit for wrap detection (log2(DEPTH)+1 bits)
    signal wr_ptr : unsigned(3 downto 0) := (others => '0');
    signal rd_ptr : unsigned(3 downto 0) := (others => '0');

    signal full_flag  : STD_LOGIC;
    signal empty_flag : STD_LOGIC;

begin

    -- Write logic
    process(clk, rst)
    begin
        if rst = '1' then
            wr_ptr <= (others => '0');
        elsif rising_edge(clk) then
            if wr_en = '1' and full_flag = '0' then
                mem(to_integer(wr_ptr(2 downto 0))) <= wr_data;
                wr_ptr <= wr_ptr + 1;
            end if;
        end if;
    end process;

    -- Read logic
    process(clk, rst)
    begin
        if rst = '1' then
            rd_ptr <= (others => '0');
        elsif rising_edge(clk) then
            if rd_en = '1' and empty_flag = '0' then
                rd_ptr <= rd_ptr + 1;
            end if;
        end if;
    end process;

    rd_data <= mem(to_integer(rd_ptr(2 downto 0)));

    -- Flag logic
    full_flag  <= '1' when (wr_ptr(2 downto 0) = rd_ptr(2 downto 0)) and (wr_ptr(3) /= rd_ptr(3)) else '0';
    empty_flag <= '1' when (wr_ptr = rd_ptr) else '0';

    full  <= full_flag;
    empty <= empty_flag;


end Behavioral;
