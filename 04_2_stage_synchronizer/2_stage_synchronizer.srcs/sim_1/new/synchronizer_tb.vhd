----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.09.2026 18:00:03
-- Design Name: 
-- Module Name: synchronizer_tb - Behavioral
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
use IEEE.numeric_std.all;

entity synchronizer_tb is
end synchronizer_tb;

architecture sim of synchronizer_tb is

    component synchronizer is
        port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            async_in : in  STD_LOGIC_VECTOR(3 downto 0);
            sync_out : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal clk_src : STD_LOGIC := '0';  -- source domain clock (fast)
    signal clk_dst : STD_LOGIC := '0';  -- destination domain clock (slow)
    signal rst     : STD_LOGIC := '0';

    signal async_in : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal sync_out : STD_LOGIC_VECTOR(3 downto 0);

begin

    uut: synchronizer
        port map (
            clk      => clk_dst,
            rst      => rst,
            async_in => async_in,
            sync_out => sync_out
        );

    -- Source clock: 6ns period (fast)
    clk_src_process: process
    begin
        clk_src <= '0';
        wait for 3 ns;
        clk_src <= '1';
        wait for 3 ns;
    end process;

    -- Destination clock: 10ns period (slower, independent)
    clk_dst_process: process
    begin
        clk_dst <= '0';
        wait for 5 ns;
        clk_dst <= '1';
        wait for 5 ns;
    end process;

    -- Source-side signal: increments on the fast clock
    src_process: process(clk_src, rst)
    begin
        if rst = '1' then
            async_in <= "0000";
        elsif rising_edge(clk_src) then
        
            async_in <= std_logic_vector(unsigned(async_in) + 1);
            
        end if;
    end process;

    stim_process: process
    begin
        rst <= '1';
        wait for 12 ns;
        rst <= '0';
        wait for 300 ns;
        std.env.stop;
    end process;

end sim;
