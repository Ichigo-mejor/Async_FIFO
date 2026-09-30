----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.09.2026 21:32:28
-- Design Name: 
-- Module Name: gray_sync_top_tb - Behavioral
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



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gray_sync_top_tb is
end gray_sync_top_tb;

architecture sim of gray_sync_top_tb is

    component gray_sync_top is
        port (
            wr_clk        : in  STD_LOGIC;
            rd_clk        : in  STD_LOGIC;
            rst           : in  STD_LOGIC;
            en            : in  STD_LOGIC;
            gray_out_sync : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal wr_clk : STD_LOGIC := '0';
    signal rd_clk : STD_LOGIC := '0';
    signal rst    : STD_LOGIC := '0';
    signal en     : STD_LOGIC := '0';
    signal gray_out_sync : STD_LOGIC_VECTOR(3 downto 0);

begin

    uut: gray_sync_top
        port map (
            wr_clk        => wr_clk,
            rd_clk        => rd_clk,
            rst           => rst,
            en            => en,
            gray_out_sync => gray_out_sync
        );

    -- Write clock: 6ns period (fast)
    wr_clk_process: process
    begin
        wr_clk <= '0';
        wait for 3 ns;
        wr_clk <= '1';
        wait for 3 ns;
    end process;

    -- Read clock: 10ns period (slower, independent)
    rd_clk_process: process
    begin
        rd_clk <= '0';
        wait for 5 ns;
        rd_clk <= '1';
        wait for 5 ns;
    end process;

    stim_process: process
    begin
        rst <= '1';
        en  <= '0';
        wait for 12 ns;

        rst <= '0';
        wait for 10 ns;

        en <= '1';
        wait for 300 ns;

        std.env.stop;
    end process;

end sim;
