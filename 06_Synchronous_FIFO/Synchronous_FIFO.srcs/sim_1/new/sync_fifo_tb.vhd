----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.09.2026 02:16:05
-- Design Name: 
-- Module Name: sync_fifo_tb - Behavioral
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

entity sync_fifo_tb is
end sync_fifo_tb;

architecture sim of sync_fifo_tb is

    component sync_fifo is
        generic (
            DEPTH : integer := 8;
            WIDTH : integer := 8
        );
        port (
            clk     : in  STD_LOGIC;
            rst     : in  STD_LOGIC;
            wr_en   : in  STD_LOGIC;
            rd_en   : in  STD_LOGIC;
            wr_data : in  STD_LOGIC_VECTOR(7 downto 0);
            rd_data : out STD_LOGIC_VECTOR(7 downto 0);
            full    : out STD_LOGIC;
            empty   : out STD_LOGIC
        );
    end component;

    signal clk     : STD_LOGIC := '0';
    signal rst     : STD_LOGIC := '0';
    signal wr_en   : STD_LOGIC := '0';
    signal rd_en   : STD_LOGIC := '0';
    signal wr_data : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal rd_data : STD_LOGIC_VECTOR(7 downto 0);
    signal full    : STD_LOGIC;
    signal empty   : STD_LOGIC;

begin

    uut: sync_fifo
        generic map (DEPTH => 8, WIDTH => 8)
        port map (
            clk     => clk,
            rst     => rst,
            wr_en   => wr_en,
            rd_en   => rd_en,
            wr_data => wr_data,
            rd_data => rd_data,
            full    => full,
            empty   => empty
        );

    -- Clock: 10ns period
    clk_process: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    stim_process: process
    begin
        -- Reset
        rst <= '1';
        wait for 12 ns;
        rst <= '0';
        wait for 10 ns;

        -- Fill the FIFO completely (8 writes, depth=8) -> should assert full
        for i in 0 to 8 loop
            wr_data <= std_logic_vector(to_unsigned(i+1, 8));
            wr_en   <= '1';
            wait for 10 ns;
        end loop;
        wr_en <= '0';
        wait for 10 ns;

        -- Try one more write while full (should be ignored -- overflow protection)
        wr_data <= x"FF";
        wr_en   <= '1';
        wait for 10 ns;
        wr_en   <= '0';
        wait for 10 ns;

        -- Now read everything out (8 reads) -> should assert empty at the end
        for i in 0 to 8 loop
            rd_en <= '1';
            wait for 10 ns;
        end loop;
        rd_en <= '0';
        wait for 10 ns;

        -- Try one more read while empty (should be ignored -- underflow protection)
        rd_en <= '1';
        wait for 10 ns;
        rd_en <= '0';
        wait for 10 ns;

        std.env.stop;
    end process;

end sim;
