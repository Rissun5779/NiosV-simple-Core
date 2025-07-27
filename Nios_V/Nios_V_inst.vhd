	component Nios_V is
		port (
			clk_clk : in std_logic := 'X'  -- clk
		);
	end component Nios_V;

	u0 : component Nios_V
		port map (
			clk_clk => CONNECTED_TO_clk_clk  -- clk.clk
		);

