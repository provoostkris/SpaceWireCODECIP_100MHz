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

constant c_clk_per     : time      := 10 ns ;
constant c_clk_tx_per  : time      := 10 ns ;
constant c_clk_rx_per  : time      := 10 ns ;

signal clk          : std_ulogic :='0';
signal clk_tx       : std_ulogic :='0';
signal clk_rx       : std_ulogic :='0';
signal rst          : std_ulogic :='0';

--! DUT ports
signal clock                       : std_logic;
signal transmitClock               : std_logic;
signal receiveClock                : std_logic;
signal reset                       : std_logic;
signal transmitFIFOWriteEnable     : std_logic;
signal transmitFIFODataIn          : std_logic_vector(8 downto 0);
signal transmitFIFOFull            : std_logic;
signal transmitFIFODataCount       : std_logic_vector(5 downto 0);
signal receiveFIFOReadEnable       : std_logic;
signal receiveFIFODataOut          : std_logic_vector(8 downto 0);
signal receiveFIFOFull             : std_logic;
signal receiveFIFOEmpty            : std_logic;
signal receiveFIFODataCount        : std_logic_vector(5 downto 0);
signal tickIn                      : std_logic;
signal timeIn                      : std_logic_vector(5 downto 0);
signal controlFlagsIn              : std_logic_vector(1 downto 0);
signal tickOut                     : std_logic;
signal timeOut                     : std_logic_vector(5 downto 0);
signal controlFlagsOut             : std_logic_vector(1 downto 0);
signal linkStart                   : std_logic;
signal linkDisable                 : std_logic;
signal autoStart                   : std_logic;
signal linkStatus                  : std_logic_vector(15 downto 0);
signal errorStatus                 : std_logic_vector(7 downto 0);
signal transmitClockDivideValue    : std_logic_vector(5 downto 0);
signal creditCount                 : std_logic_vector(5 downto 0);
signal outstandingCount            : std_logic_vector(5 downto 0);
signal transmitActivity            : std_logic;
signal receiveActivity             : std_logic;
signal spaceWireDataOut            : std_logic;
signal spaceWireStrobeOut          : std_logic;
signal spaceWireDataIn             : std_logic;
signal spaceWireStrobeIn           : std_logic;
signal statisticalInformationClear : std_logic;
signal statisticalInformation      : bit32X8Array;


begin

	clk            <= not clk     after c_clk_per/2;
	clk_rx         <= not clk_rx  after c_clk_tx_per/2;
	clk_tx         <= not clk_tx  after c_clk_rx_per/2;
	rst            <= '1', '0'    after c_clk_per *  3 ;

-- some initial wiring
clock           <= clk;
transmitClock   <= clk_tx;
receiveClock    <= clk_rx;
reset           <= rst;

--! provide dummy data
  process(transmitClock, reset)
    variable v_cnt  : unsigned(7 downto 0);
  begin
    if(reset = '1') then
      v_cnt                     := ( others => '0');
      transmitFIFOWriteEnable   <= '0';
      transmitFIFODataIn        <= ( others => '0');
    elsif(transmitClock'event and transmitClock = '1') then
      v_cnt                   := v_cnt + 1;
      if and_reduce(std_logic_vector(v_cnt)) = '1' then
        transmitFIFOWriteEnable <= '1';
        transmitFIFODataIn      <= std_logic_vector( unsigned(transmitFIFODataIn) + x"07");
        assert false report " <TB> TX data" severity note;
      else 
        transmitFIFOWriteEnable <= '0';
      end if;
    end if;
  end process;

-- consume rx 
receiveFIFOReadEnable     <= '1';

--no time code
tickIn          <= '0';
timeIn          <= ( others => '0');
controlFlagsIn  <= ( others => '0');

-- start enabled
linkStart   <= '1';
linkDisable <= '0';
autoStart   <= '1';

-- configuration
statisticalInformationClear <= '0';
transmitClockDivideValue    <= std_logic_vector(to_unsigned(1,transmitClockDivideValue'length));


--loop
spaceWireDataIn     <= spaceWireDataOut;
spaceWireStrobeIn   <= spaceWireStrobeOut;


--! dut
dut: entity work.SpaceWireCODECIP(Behavioral)
  port map (
        clock                               =>  clock                         ,
        transmitClock                       =>  transmitClock                 ,
        receiveClock                        =>  receiveClock                  ,
        reset                               =>  reset                         ,
        transmitFIFOWriteEnable             =>  transmitFIFOWriteEnable       ,
        transmitFIFODataIn                  =>  transmitFIFODataIn            ,
        transmitFIFOFull                    =>  transmitFIFOFull              ,
        transmitFIFODataCount               =>  transmitFIFODataCount         ,
        receiveFIFOReadEnable               =>  receiveFIFOReadEnable         ,
        receiveFIFODataOut                  =>  receiveFIFODataOut            ,
        receiveFIFOFull                     =>  receiveFIFOFull               ,
        receiveFIFOEmpty                    =>  receiveFIFOEmpty              ,
        receiveFIFODataCount                =>  receiveFIFODataCount          ,
        tickIn                              =>  tickIn                        ,
        timeIn                              =>  timeIn                        ,
        controlFlagsIn                      =>  controlFlagsIn                ,
        tickOut                             =>  tickOut                       ,
        timeOut                             =>  timeOut                       ,
        controlFlagsOut                     =>  controlFlagsOut               ,
        linkStart                           =>  linkStart                     ,
        linkDisable                         =>  linkDisable                   ,
        autoStart                           =>  autoStart                     ,
        linkStatus                          =>  linkStatus                    ,
        errorStatus                         =>  errorStatus                   ,
        transmitClockDivideValue            =>  transmitClockDivideValue      ,
        creditCount                         =>  creditCount                   ,
        outstandingCount                    =>  outstandingCount              ,
        transmitActivity                    =>  transmitActivity              ,
        receiveActivity                     =>  receiveActivity               ,
        spaceWireDataOut                    =>  spaceWireDataOut              ,
        spaceWireStrobeOut                  =>  spaceWireStrobeOut            ,
        spaceWireDataIn                     =>  spaceWireDataIn               ,
        spaceWireStrobeIn                   =>  spaceWireStrobeIn             ,
        statisticalInformationClear         =>  statisticalInformationClear   ,
        statisticalInformation              =>  statisticalInformation
  );

end architecture rtl;