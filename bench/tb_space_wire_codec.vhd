------------------------------------------------------------------------------
--  Test Bench for the space wire codec
--  rev. 1.0 : 2021 Provoost Kris
------------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

library work;
use     work.SpaceWireCODECIPPackage.all;

entity tb_space_wire_codec is
	port(
		y        :  out std_logic
	);
end entity tb_space_wire_codec;

architecture rtl of tb_space_wire_codec is

constant c_clk_per  : time      := 20 ns ;

signal clk          : std_ulogic :='0';
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

	clk            <= not clk  after c_clk_per/2;
	rst            <= '1', '0' after c_clk_per *  3 ;

-- some initial wiring
clock           <= clk;
transmitClock   <= clk;
receiveClock    <= clk;
reset           <= rst;

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