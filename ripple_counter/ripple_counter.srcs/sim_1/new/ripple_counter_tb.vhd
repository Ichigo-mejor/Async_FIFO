----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2026 02:01:55
-- Design Name: 
-- Module Name: ripple_counter_tb - simu
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

entity ripple_counter_tb is
end ripple_counter_tb;

architecture sim of ripple_counter_tb is

    component ripple_counter is
        port (
            clk   : in  STD_LOGIC;
            rst   : in  STD_LOGIC;
            count : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal clk   : STD_LOGIC := '0';
    signal rst   : STD_LOGIC := '0';
    signal count : STD_LOGIC_VECTOR(3 downto 0);

begin

    uut: ripple_counter
        port map (
            clk   => clk,
            rst   => rst,
            count => count
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
        rst <= '1';
        wait for 12 ns;
        rst <= '0';

        -- Let it free-run and count, no enable needed (always toggling)
        wait for 300 ns;

        -- Mid-run reset
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        wait for 100 ns;

        std.env.stop;
    end process;

end sim;
