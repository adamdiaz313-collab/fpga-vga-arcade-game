pong_top_st_Diaz.vhd

library ieee;
use ieee.std_logic_1164.all;

entity pong_top_st is
    port(
        clk, reset   : in  std_logic;
        btn          : in  std_logic_vector(4 downto 0);
        hsync, vsync : out std_logic;
        rgb_top      : out std_logic_vector(2 downto 0)
    );
end pong_top_st;

architecture arch of pong_top_st is

    --------------------------------------------------------------------
    -- TOP LEVEL SIGNALS
    -- Search phrase: TOP LEVEL SIGNALS
    -- These signals connect:
    --   - VGA sync module
    --   - game graphics module
    --   - lives display module
    --------------------------------------------------------------------
    signal pixel_x, pixel_y : std_logic_vector(9 downto 0);
    signal video_on         : std_logic;
    signal rgb_reg, rgb_next: std_logic_vector(2 downto 0);
    signal rgb              : std_logic_vector(2 downto 0);
    signal p_tick           : std_logic;
    signal comp_sync        : std_logic;

    --------------------------------------------------------------------
    -- GAME / LIVES DISPLAY RGB SIGNALS
    -- Search phrase: RGB MUX SIGNALS
    --------------------------------------------------------------------
    signal pong_graph_rgb : std_logic_vector(2 downto 0);
    signal lives_rgb      : std_logic_vector(2 downto 0);
    signal sq_lives_on    : std_logic;
    signal lives_cnt_sig  : std_logic_vector(2 downto 0);

begin

    --------------------------------------------------------------------
    -- VGA SYNC MODULE
    -- Search phrase: VGA SYNC MODULE
    --------------------------------------------------------------------
    vga_sync_unit : entity work.vga_sync
        port map(
            clk       => clk,
            reset     => reset,
            hsync     => hsync,
            vsync     => vsync,
            comp_sync => comp_sync,
            video_on  => video_on,
            p_tick    => p_tick,
            pixel_x   => pixel_x,
            pixel_y   => pixel_y
        );

    --------------------------------------------------------------------
    -- GAME GRAPHICS MODULE
    -- Search phrase: GAME GRAPHICS MODULE
    -- This module contains:
    --   - ship
    --   - missile
    --   - asteroids
    --   - explosions
    --   - life count output
    --------------------------------------------------------------------
    pong_grf_st_unit : entity work.pong_graph_st(sq_ball_arch)
        port map(
            clk       => clk,
            reset     => reset,
            btn       => btn,
            video_on  => video_on,
            pixel_x   => pixel_x,
            pixel_y   => pixel_y,
            lives_cnt => lives_cnt_sig,
            graph_rgb => pong_graph_rgb
        );

    --------------------------------------------------------------------
    -- LIVES DISPLAY MODULE
    -- Search phrase: LIVES DISPLAY MODULE
    -- Draws the current life count in the top-left corner.
    --------------------------------------------------------------------
    lives_disp_unit : entity work.lives_disp
        port map(
            pixel_x            => pixel_x,
            pixel_y            => pixel_y,
            lives_cnt          => lives_cnt_sig,
            sq_lives_on_output => sq_lives_on,
            graph_rgb          => lives_rgb
        );

    --------------------------------------------------------------------
    -- RGB MUX
    -- Search phrase: TOP RGB MUX
    -- If the current pixel is inside the lives counter area, show the
    -- lives RGB. Otherwise show the game RGB.
    --------------------------------------------------------------------
    rgb_next <= lives_rgb when sq_lives_on = '1' else pong_graph_rgb;

    --------------------------------------------------------------------
    -- RGB REGISTER
    -- Search phrase: RGB REGISTER
    --------------------------------------------------------------------
    rgb_top <= rgb;

    process(clk)
    begin
        if rising_edge(clk) then
            if p_tick = '1' then
                rgb_reg <= rgb_next;
            end if;
        end if;
    end process;

    rgb <= rgb_reg;

end arch;

