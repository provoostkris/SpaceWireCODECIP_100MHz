------------------------------------------------------------------------------
--  Test Bench for the space wire codec
--  rev. 1.0 : 2021 Provoost Kris
------------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     ieee.std_logic_misc.all;

library work;
use     work.SpaceWireCODECIPPackage.all;

entity tb_space_wire_codec is
	port(
		y        :  out std_logic
	);
end entity tb_space_wire_codec;

architecture rtl of tb_space_wire_codec is

constant c_clk_per     : time      := 40 ns ;
constant c_clk_tx_per  : time      := 20 ns ;
constant c_clk_rx_per  : time      := 20 ns ;

signal clk          : std_ulogic :='0';
signal clk_tx       : std_ulogic :='0';
signal clk_rx       : std_ulogic :='0';
signal rst          : std_ulogic :='0';

--! DUT ports
signal dut_0_clock                       : std_logic;
signal dut_0_transmitClock               : std_logic;
signal dut_0_receiveClock                : std_logic;
signal dut_0_reset                       : std_logic;
signal dut_0_transmitFIFOWriteEnable     : std_logic;
signal dut_0_transmitFIFODataIn          : std_logic_vector(8 downto 0);
signal dut_0_transmitFIFOFull            : std_logic;
signal dut_0_transmitFIFODataCount       : std_logic_vector(5 downto 0);
signal dut_0_receiveFIFOReadEnable       : std_logic;
signal dut_0_receiveFIFODataOut          : std_logic_vector(8 downto 0);
signal dut_0_receiveFIFOFull             : std_logic;
signal dut_0_receiveFIFOEmpty            : std_logic;
signal dut_0_receiveFIFODataCount        : std_logic_vector(5 downto 0);
signal dut_0_tickIn                      : std_logic;
signal dut_0_timeIn                      : std_logic_vector(5 downto 0);
signal dut_0_controlFlagsIn              : std_logic_vector(1 downto 0);
signal dut_0_tickOut                     : std_logic;
signal dut_0_timeOut                     : std_logic_vector(5 downto 0);
signal dut_0_controlFlagsOut             : std_logic_vector(1 downto 0);
signal dut_0_linkStart                   : std_logic;
signal dut_0_linkDisable                 : std_logic;
signal dut_0_autoStart                   : std_logic;
signal dut_0_linkStatus                  : std_logic_vector(15 downto 0);
signal dut_0_errorStatus                 : std_logic_vector(7 downto 0);
signal dut_0_transmitClockDivideValue    : std_logic_vector(5 downto 0);
signal dut_0_creditCount                 : std_logic_vector(5 downto 0);
signal dut_0_outstandingCount            : std_logic_vector(5 downto 0);
signal dut_0_transmitActivity            : std_logic;
signal dut_0_receiveActivity             : std_logic;
signal dut_0_spaceWireDataOut            : std_logic;
signal dut_0_spaceWireStrobeOut          : std_logic;
signal dut_0_spaceWireDataIn             : std_logic;
signal dut_0_spaceWireStrobeIn           : std_logic;
signal dut_0_statisticalInformationClear : std_logic;
signal dut_0_statisticalInformation      : bit32X8Array;
--! DUT ports
signal dut_1_clock                       : std_logic;
signal dut_1_transmitClock               : std_logic;
signal dut_1_receiveClock                : std_logic;
signal dut_1_reset                       : std_logic;
signal dut_1_transmitFIFOWriteEnable     : std_logic;
signal dut_1_transmitFIFODataIn          : std_logic_vector(8 downto 0);
signal dut_1_transmitFIFOFull            : std_logic;
signal dut_1_transmitFIFODataCount       : std_logic_vector(5 downto 0);
signal dut_1_receiveFIFOReadEnable       : std_logic;
signal dut_1_receiveFIFODataOut          : std_logic_vector(8 downto 0);
signal dut_1_receiveFIFOFull             : std_logic;
signal dut_1_receiveFIFOEmpty            : std_logic;
signal dut_1_receiveFIFODataCount        : std_logic_vector(5 downto 0);
signal dut_1_tickIn                      : std_logic;
signal dut_1_timeIn                      : std_logic_vector(5 downto 0);
signal dut_1_controlFlagsIn              : std_logic_vector(1 downto 0);
signal dut_1_tickOut                     : std_logic;
signal dut_1_timeOut                     : std_logic_vector(5 downto 0);
signal dut_1_controlFlagsOut             : std_logic_vector(1 downto 0);
signal dut_1_linkStart                   : std_logic;
signal dut_1_linkDisable                 : std_logic;
signal dut_1_autoStart                   : std_logic;
signal dut_1_linkStatus                  : std_logic_vector(15 downto 0);
signal dut_1_errorStatus                 : std_logic_vector(7 downto 0);
signal dut_1_transmitClockDivideValue    : std_logic_vector(5 downto 0);
signal dut_1_creditCount                 : std_logic_vector(5 downto 0);
signal dut_1_outstandingCount            : std_logic_vector(5 downto 0);
signal dut_1_transmitActivity            : std_logic;
signal dut_1_receiveActivity             : std_logic;
signal dut_1_spaceWireDataOut            : std_logic;
signal dut_1_spaceWireStrobeOut          : std_logic;
signal dut_1_spaceWireDataIn             : std_logic;
signal dut_1_spaceWireStrobeIn           : std_logic;
signal dut_1_statisticalInformationClear : std_logic;
signal dut_1_statisticalInformation      : bit32X8Array;


begin

	clk            <= not clk     after c_clk_per/2;
	clk_rx         <= not clk_rx  after c_clk_tx_per/2;
	clk_tx         <= not clk_tx  after c_clk_rx_per/2;
	rst            <= '1', '0'    after c_clk_per *  3 ;

-- some initial wiring
dut_0_clock           <= clk;
dut_0_transmitClock   <= clk_tx;
dut_0_receiveClock    <= clk_rx;
dut_0_reset           <= rst;

dut_1_clock           <= clk;
dut_1_transmitClock   <= clk_tx;
dut_1_receiveClock    <= clk_rx;
dut_1_reset           <= rst;

--! provide dummy data
  process(dut_0_transmitClock, dut_0_reset)
    variable v_cnt  : unsigned(7 downto 0);
  begin
    if(dut_0_reset = '1') then
      v_cnt                     := ( others => '0');
      dut_0_transmitFIFOWriteEnable   <= '0';
      dut_0_transmitFIFODataIn        <= ( others => '0');
    elsif(dut_0_transmitClock'event and dut_0_transmitClock = '1') then
      v_cnt                   := v_cnt + 1;
      if and_reduce(std_logic_vector(v_cnt)) = '1' then
        dut_0_transmitFIFOWriteEnable <= '1';
        dut_0_transmitFIFODataIn      <= std_logic_vector( unsigned(dut_0_transmitFIFODataIn) + x"07");
        assert false report " <TB> TX data" severity note;
      else 
        dut_0_transmitFIFOWriteEnable <= '0';
      end if;
    end if;
  end process;

-- consume rx 
dut_0_receiveFIFOReadEnable     <= '1';

dut_1_receiveFIFOReadEnable     <= '1';

--no time code
dut_0_tickIn          <= '0';
dut_0_timeIn          <= ( others => '0');
dut_0_controlFlagsIn  <= ( others => '0');

dut_1_tickIn          <= '0';
dut_1_timeIn          <= ( others => '0');
dut_1_controlFlagsIn  <= ( others => '0');

-- start enabled
dut_0_linkStart   <= '1';
dut_0_linkDisable <= '0';
dut_0_autoStart   <= '1';

dut_1_linkStart   <= '1';
dut_1_linkDisable <= '0';
dut_1_autoStart   <= '1';

-- configuration
dut_0_statisticalInformationClear <= '0';
dut_0_transmitClockDivideValue    <= std_logic_vector(to_unsigned(1,dut_0_transmitClockDivideValue'length));

dut_1_statisticalInformationClear <= '0';
dut_1_transmitClockDivideValue    <= std_logic_vector(to_unsigned(1,dut_0_transmitClockDivideValue'length));


--loop
dut_1_spaceWireDataIn     <= dut_0_spaceWireDataOut;
dut_1_spaceWireStrobeIn   <= dut_0_spaceWireStrobeOut;

dut_0_spaceWireDataIn     <= dut_1_spaceWireDataOut;
dut_0_spaceWireStrobeIn   <= dut_1_spaceWireStrobeOut;


--! dut
dut_0: entity work.SpaceWireCODECIP(Behavioral)
  port map (
        clock                               =>  dut_0_clock                         ,
        transmitClock                       =>  dut_0_transmitClock                 ,
        receiveClock                        =>  dut_0_receiveClock                  ,
        reset                               =>  dut_0_reset                         ,
        transmitFIFOWriteEnable             =>  dut_0_transmitFIFOWriteEnable       ,
        transmitFIFODataIn                  =>  dut_0_transmitFIFODataIn            ,
        transmitFIFOFull                    =>  dut_0_transmitFIFOFull              ,
        transmitFIFODataCount               =>  dut_0_transmitFIFODataCount         ,
        receiveFIFOReadEnable               =>  dut_0_receiveFIFOReadEnable         ,
        receiveFIFODataOut                  =>  dut_0_receiveFIFODataOut            ,
        receiveFIFOFull                     =>  dut_0_receiveFIFOFull               ,
        receiveFIFOEmpty                    =>  dut_0_receiveFIFOEmpty              ,
        receiveFIFODataCount                =>  dut_0_receiveFIFODataCount          ,
        tickIn                              =>  dut_0_tickIn                        ,
        timeIn                              =>  dut_0_timeIn                        ,
        controlFlagsIn                      =>  dut_0_controlFlagsIn                ,
        tickOut                             =>  dut_0_tickOut                       ,
        timeOut                             =>  dut_0_timeOut                       ,
        controlFlagsOut                     =>  dut_0_controlFlagsOut               ,
        linkStart                           =>  dut_0_linkStart                     ,
        linkDisable                         =>  dut_0_linkDisable                   ,
        autoStart                           =>  dut_0_autoStart                     ,
        linkStatus                          =>  dut_0_linkStatus                    ,
        errorStatus                         =>  dut_0_errorStatus                   ,
        transmitClockDivideValue            =>  dut_0_transmitClockDivideValue      ,
        creditCount                         =>  dut_0_creditCount                   ,
        outstandingCount                    =>  dut_0_outstandingCount              ,
        transmitActivity                    =>  dut_0_transmitActivity              ,
        receiveActivity                     =>  dut_0_receiveActivity               ,
        spaceWireDataOut                    =>  dut_0_spaceWireDataOut              ,
        spaceWireStrobeOut                  =>  dut_0_spaceWireStrobeOut            ,
        spaceWireDataIn                     =>  dut_0_spaceWireDataIn               ,
        spaceWireStrobeIn                   =>  dut_0_spaceWireStrobeIn             ,
        statisticalInformationClear         =>  dut_0_statisticalInformationClear   ,
        statisticalInformation              =>  dut_0_statisticalInformation
  );


dut_1: entity work.SpaceWireCODECIP(Behavioral)
  port map (
        clock                               =>  dut_1_clock                         ,
        transmitClock                       =>  dut_1_transmitClock                 ,
        receiveClock                        =>  dut_1_receiveClock                  ,
        reset                               =>  dut_1_reset                         ,
        transmitFIFOWriteEnable             =>  dut_1_transmitFIFOWriteEnable       ,
        transmitFIFODataIn                  =>  dut_1_transmitFIFODataIn            ,
        transmitFIFOFull                    =>  dut_1_transmitFIFOFull              ,
        transmitFIFODataCount               =>  dut_1_transmitFIFODataCount         ,
        receiveFIFOReadEnable               =>  dut_1_receiveFIFOReadEnable         ,
        receiveFIFODataOut                  =>  dut_1_receiveFIFODataOut            ,
        receiveFIFOFull                     =>  dut_1_receiveFIFOFull               ,
        receiveFIFOEmpty                    =>  dut_1_receiveFIFOEmpty              ,
        receiveFIFODataCount                =>  dut_1_receiveFIFODataCount          ,
        tickIn                              =>  dut_1_tickIn                        ,
        timeIn                              =>  dut_1_timeIn                        ,
        controlFlagsIn                      =>  dut_1_controlFlagsIn                ,
        tickOut                             =>  dut_1_tickOut                       ,
        timeOut                             =>  dut_1_timeOut                       ,
        controlFlagsOut                     =>  dut_1_controlFlagsOut               ,
        linkStart                           =>  dut_1_linkStart                     ,
        linkDisable                         =>  dut_1_linkDisable                   ,
        autoStart                           =>  dut_1_autoStart                     ,
        linkStatus                          =>  dut_1_linkStatus                    ,
        errorStatus                         =>  dut_1_errorStatus                   ,
        transmitClockDivideValue            =>  dut_1_transmitClockDivideValue      ,
        creditCount                         =>  dut_1_creditCount                   ,
        outstandingCount                    =>  dut_1_outstandingCount              ,
        transmitActivity                    =>  dut_1_transmitActivity              ,
        receiveActivity                     =>  dut_1_receiveActivity               ,
        spaceWireDataOut                    =>  dut_1_spaceWireDataOut              ,
        spaceWireStrobeOut                  =>  dut_1_spaceWireStrobeOut            ,
        spaceWireDataIn                     =>  dut_1_spaceWireDataIn               ,
        spaceWireStrobeIn                   =>  dut_1_spaceWireStrobeIn             ,
        statisticalInformationClear         =>  dut_1_statisticalInformationClear   ,
        statisticalInformation              =>  dut_1_statisticalInformation
  );

end architecture rtl;