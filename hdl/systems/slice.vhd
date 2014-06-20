library work;
library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
library unimacro;
library unisim;
use unimacro.vcomponents.all;
use unisim.vcomponents.all;

entity slice is
  generic (
    NLAYER : integer range 1 to 8 := 6  -- Number of layers
    );  
  port (

    clk40MHz : in std_logic;
    clk100MHz : in std_logic;
    clk160MHz : in std_logic;
    reset : in std_logic;
    enable : in std_logic;

    phi_id : in integer;
    z_id : in integer;

    l0_n_stub_in_dv : in std_logic;
    l0_n_stub_in_data : in std_logic_vector(15 downto 0);
    l0_p_stub_in_dv : in std_logic;
    l0_p_stub_in_data : in std_logic_vector(15 downto 0);
    l0_n_stub_out_dv : out std_logic;
    l0_n_stub_out_data : out std_logic_vector(15 downto 0);
    l0_p_stub_out_dv : out std_logic;
    l0_p_stub_out_data : out std_logic_vector(15 downto 0);

    l1_n_stub_in_dv : in std_logic;
    l1_n_stub_in_data : in std_logic_vector(15 downto 0);
    l1_p_stub_in_dv : in std_logic;
    l1_p_stub_in_data : in std_logic_vector(15 downto 0);
    l1_n_stub_out_dv : out std_logic;
    l1_n_stub_out_data : out std_logic_vector(15 downto 0);
    l1_p_stub_out_dv : out std_logic;
    l1_p_stub_out_data : out std_logic_vector(15 downto 0);

    l2_n_stub_in_dv : in std_logic;
    l2_n_stub_in_data : in std_logic_vector(15 downto 0);
    l2_p_stub_in_dv : in std_logic;
    l2_p_stub_in_data : in std_logic_vector(15 downto 0);
    l2_n_stub_out_dv : out std_logic;
    l2_n_stub_out_data : out std_logic_vector(15 downto 0);
    l2_p_stub_out_dv : out std_logic;
    l2_p_stub_out_data : out std_logic_vector(15 downto 0);

    l3_n_stub_in_dv : in std_logic;
    l3_n_stub_in_data : in std_logic_vector(15 downto 0);
    l3_p_stub_in_dv : in std_logic;
    l3_p_stub_in_data : in std_logic_vector(15 downto 0);
    l3_n_stub_out_dv : out std_logic;
    l3_n_stub_out_data : out std_logic_vector(15 downto 0);
    l3_p_stub_out_dv : out std_logic;
    l3_p_stub_out_data : out std_logic_vector(15 downto 0);

    l4_n_stub_in_dv : in std_logic;
    l4_n_stub_in_data : in std_logic_vector(15 downto 0);
    l4_p_stub_in_dv : in std_logic;
    l4_p_stub_in_data : in std_logic_vector(15 downto 0);
    l4_n_stub_out_dv : out std_logic;
    l4_n_stub_out_data : out std_logic_vector(15 downto 0);
    l4_p_stub_out_dv : out std_logic;
    l4_p_stub_out_data : out std_logic_vector(15 downto 0);

    l5_n_stub_in_dv : in std_logic;
    l5_n_stub_in_data : in std_logic_vector(15 downto 0);
    l5_p_stub_in_dv : in std_logic;
    l5_p_stub_in_data : in std_logic_vector(15 downto 0);
    l5_n_stub_out_dv : out std_logic;
    l5_n_stub_out_data : out std_logic_vector(15 downto 0);
    l5_p_stub_out_dv : out std_logic;
    l5_p_stub_out_data : out std_logic_vector(15 downto 0));

end slice;


architecture slice_arch of slice is

-- Beginning of the Test Bench Section

  component file_handler is
    port (
      clk             : in  std_logic;
      start           : out std_logic;
      vme_cmd_reg     : out std_logic_vector(31 downto 0);
      vme_dat_reg_in  : out std_logic_vector(31 downto 0);
      vme_dat_reg_out : in  std_logic_vector(31 downto 0);
      vme_cmd_rd      : in  std_logic;
      vme_dat_wr      : in  std_logic
      );

  end component;

  component test_controller is

    port(

      clk       : in std_logic;
      rstn      : in std_logic;
      sw_reset  : in std_logic;
      tc_enable : in std_logic;

-- From/To SLV_MGT Module

      start     : in  std_logic;
      start_res : out std_logic;
      stop      : in  std_logic;
      stop_res  : out std_logic;
      mode      : in  std_logic;
      cmd_n     : in  std_logic_vector(9 downto 0);
      busy      : out std_logic;

      vme_cmd_reg     : in  std_logic_vector(31 downto 0);
      vme_dat_reg_in  : in  std_logic_vector(31 downto 0);
      vme_dat_reg_out : out std_logic_vector(31 downto 0);

-- To/From VME Master FSM

      vme_cmd    : out std_logic;
      vme_cmd_rd : in  std_logic;

      vme_addr    : out std_logic_vector(23 downto 1);
      vme_wr      : out std_logic;
      vme_wr_data : out std_logic_vector(15 downto 0);
      vme_rd      : out std_logic;
      vme_rd_data : in  std_logic_vector(15 downto 0);

-- From/To VME_CMD Memory and VME_DAT Memory

      vme_mem_addr     : out std_logic_vector(9 downto 0);
      vme_mem_rden     : out std_logic;
      vme_cmd_mem_out  : in  std_logic_vector(31 downto 0);
      vme_dat_mem_out  : in  std_logic_vector(31 downto 0);
      vme_dat_mem_wren : out std_logic;
      vme_dat_mem_in   : out std_logic_vector(31 downto 0)

      );

  end component;

  component vme_master is
    
    port (
      clk      : in std_logic;
      rstn     : in std_logic;
      sw_reset : in std_logic;

      vme_cmd    : in  std_logic;
      vme_cmd_rd : out std_logic;

      vme_addr    : in  std_logic_vector(23 downto 1);
      vme_wr      : in  std_logic;
      vme_wr_data : in  std_logic_vector(15 downto 0);
      vme_rd      : in  std_logic;
      vme_rd_data : out std_logic_vector(15 downto 0);

      ga   : out std_logic_vector(5 downto 0);
      addr : out std_logic_vector(23 downto 1);
      am   : out std_logic_vector(5 downto 0);

      as      : out std_logic;
      ds0     : out std_logic;
      ds1     : out std_logic;
      lword   : out std_logic;
      write_b : out std_logic;
      iack    : out std_logic;
      berr    : out std_logic;
      sysfail : out std_logic;
      dtack   : in  std_logic;

      data_in  : in  std_logic_vector(15 downto 0);
      data_out : out std_logic_vector(15 downto 0);
      oe_b     : out std_logic

      );

  end component;


  component file_handler_road_gen is
    port (
      clk       : in  std_logic;
      phi    : in std_logic_vector(3 downto 0);
      z    : in  std_logic_vector(3 downto 0);
      eor    : in  std_logic;
      p0_road_data : in  std_logic_vector(29 downto 0);
      p0_road_dv 		: in std_logic;
      p1_road_data : in  std_logic_vector(29 downto 0);
      p1_road_dv 		: in std_logic;
      p2_road_data : in  std_logic_vector(29 downto 0);
      p2_road_dv 		: in std_logic;
      p3_road_data : in  std_logic_vector(29 downto 0);
      p3_road_dv 		: in std_logic
      );

  end component;
    

  component am_controller is
    port
      (

        phi    : in std_logic_vector(3 downto 0);
        z    : in  std_logic_vector(3 downto 0);

        clk         : in    std_logic;

        init         : out    std_logic;

-- From/To VME connector To/From MBV

--      vme_data        : inout std_logic_vector(15 downto 0);
        vme_data        : inout std_logic_vector(31 downto 0);

--      vme_addr        : in    std_logic_vector(23 downto 1);
        vadd        		: in 	  std_logic_vector(31 downto 1);

--      vme_am          : in    std_logic_vector(5 downto 0);
		    am          		: in    std_logic_vector(5 downto 0);

--      vme_gap         : in    std_logic;
--		  ?

--      vme_ga          : in    std_logic_vector(4 downto 0);
        geadd           : in    std_logic_vector(4 downto 0);

--      vme_bg0         : in    std_logic;
--		  ?

--      vme_bg1         : in    std_logic;
--		  ?

--      vme_bg2         : in    std_logic;
--		  ?

--      vme_bg3         : in    std_logic;
--		  ?

--      vme_as_b        : in    std_logic;
        as_b  				: in    std_logic;
 
--      vme_ds_b        : in    std_logic_vector(1 downto 0);
        ds0_b  				: in    std_logic;
        ds1_b  				: in    std_logic;

--      vme_sysreset_b  : in    std_logic;
--		  ?

--      vme_sysfail_b   : in    std_logic;
--		  ?

--      vme_sysfail_out : out   std_logic;
--		  ?

--      vme_berr_b      : in    std_logic;
--		  ?

--      vme_berr_out    : out   std_logic;
        berr_b     		: out    std_logic;

--      vme_iack_b      : in    std_logic;
        iack_b     		: in    std_logic;

--      vme_lword_b     : in    std_logic;
        lword_b     		: in    std_logic;

--      vme_write_b     : in    std_logic;
        write_b     		: in    std_logic;

--      vme_clk         : in    std_logic;
--		  ?

--      vme_dtack_v6_b  : inout std_logic;
        dtack_b  			: out std_logic;

--      vme_tovme       : out   std_logic;  -- not (tovme)
--		  ?

--      vme_doe_b       : out   std_logic;
--		  ?


-- From/To Stub FIFOs

        lay0_p0_in     : in std_logic_vector(20 downto 0); --  Layer_0 - Port_0
        lay1_p0_in     : in std_logic_vector(20 downto 0); --  Layer_1 - Port_0
        lay2_p0_in     : in std_logic_vector(20 downto 0); --  Layer_2 - Port_0
        lay3_p0_in     : in std_logic_vector(20 downto 0); --  Layer_3 - Port_0
        lay4_p0_in     : in std_logic_vector(20 downto 0); --  Layer_4 - Port_0
        lay5_p0_in     : in std_logic_vector(20 downto 0); --  Layer_5 - Port_0
 
        p0_ef_b       	: in std_logic_vector(5 downto 0);
        p0_rden_b      : out std_logic_vector(5 downto 0);

        lay0_p1_in     : in std_logic_vector(20 downto 0); --  Layer_0 - Port_1
        lay1_p1_in     : in std_logic_vector(20 downto 0); --  Layer_1 - Port_1
        lay2_p1_in     : in std_logic_vector(20 downto 0); --  Layer_2 - Port_1
        lay3_p1_in     : in std_logic_vector(20 downto 0); --  Layer_3 - Port_1
        lay4_p1_in     : in std_logic_vector(20 downto 0); --  Layer_4 - Port_1
        lay5_p1_in     : in std_logic_vector(20 downto 0); --  Layer_5 - Port_1
 
        p1_ef_b       	: in std_logic_vector(5 downto 0);
        p1_rden_b      : out std_logic_vector(5 downto 0);

        lay0_p2_in     : in std_logic_vector(20 downto 0); --  Layer_0 - Port_2
        lay1_p2_in     : in std_logic_vector(20 downto 0); --  Layer_1 - Port_2
        lay2_p2_in     : in std_logic_vector(20 downto 0); --  Layer_2 - Port_2
        lay3_p2_in     : in std_logic_vector(20 downto 0); --  Layer_3 - Port_2
        lay4_p2_in     : in std_logic_vector(20 downto 0); --  Layer_4 - Port_2
        lay5_p2_in     : in std_logic_vector(20 downto 0); --  Layer_5 - Port_2
 
        p2_ef_b       	: in std_logic_vector(5 downto 0);
        p2_rden_b      : out std_logic_vector(5 downto 0);

        lay0_p3_in     : in std_logic_vector(20 downto 0); --  Layer_0 - Port_3
        lay1_p3_in     : in std_logic_vector(20 downto 0); --  Layer_1 - Port_3
        lay2_p3_in     : in std_logic_vector(20 downto 0); --  Layer_2 - Port_3
        lay3_p3_in     : in std_logic_vector(20 downto 0); --  Layer_3 - Port_3
        lay4_p3_in     : in std_logic_vector(20 downto 0); --  Layer_4 - Port_3
        lay5_p3_in     : in std_logic_vector(20 downto 0); --  Layer_5 - Port_3
 
        p3_ef_b       	: in std_logic_vector(5 downto 0);
        p3_rden_b      : out std_logic_vector(5 downto 0);

        resfifo0_b      	: out std_logic;
        resfifo1_b      	: out std_logic;

-- From/To LAMB_A

        A0_HIT      		: out std_logic_vector(17 downto 0);
        A1_HIT      		: out std_logic_vector(17 downto 0);
        A2_HIT      		: out std_logic_vector(17 downto 0);
        A3_HIT      		: out std_logic_vector(17 downto 0);
        A4_HIT      		: out std_logic_vector(17 downto 0);
        A5_HIT      		: out std_logic_vector(17 downto 0);
        enA_wr      		: out std_logic_vector(5 downto 0);
        init_ev0_lamb0  : out std_logic;
        init_ev1_lamb0  : out std_logic;
        init_ev2_lamb0  : out std_logic;
        sel0_b      		: out std_logic;
        opcode0_out     : out std_logic_vector(3 downto 0);
 		    dr0_b      		: in std_logic;
        ladd0     		: in std_logic_vector(20 downto 0);
				tck_am_lamb0      		: out std_logic;
 
-- From/To LAMB_B

        B0_HIT      		: out std_logic_vector(17 downto 0);
        B1_HIT      		: out std_logic_vector(17 downto 0);
        B2_HIT      		: out std_logic_vector(17 downto 0);
        B3_HIT      		: out std_logic_vector(17 downto 0);
        B4_HIT      		: out std_logic_vector(17 downto 0);
        B5_HIT      		: out std_logic_vector(17 downto 0);
        enB_wr      		: out std_logic_vector(5 downto 0);
        init_ev0_lamb1  : out std_logic;
        init_ev1_lamb1  : out std_logic;
        init_ev2_lamb1  : out std_logic;
        sel1_b      		: out std_logic;
        opcode1_out     : out std_logic_vector(3 downto 0);
		    dr1_b      		: in std_logic;
        ladd1     		: in std_logic_vector(20 downto 0);
				tck_am_lamb1      		: out std_logic;
  
-- From/To LAMB_C

        C0_HIT      		: out std_logic_vector(17 downto 0);
        C1_HIT      		: out std_logic_vector(17 downto 0);
        C2_HIT      		: out std_logic_vector(17 downto 0);
        C3_HIT      		: out std_logic_vector(17 downto 0);
        C4_HIT      		: out std_logic_vector(17 downto 0);
        C5_HIT      		: out std_logic_vector(17 downto 0);
        enC_wr      		: out std_logic_vector(5 downto 0);
        init_ev0_lamb2  : out std_logic;
        init_ev1_lamb2  : out std_logic;
        init_ev2_lamb2  : out std_logic;
        sel2_b      		: out std_logic;
        opcode2_out     : out std_logic_vector(3 downto 0);
		    dr2_b      		: in std_logic;
        ladd2     		: in std_logic_vector(20 downto 0);
				tck_am_lamb2      		: out std_logic;
 
-- From/To LAMB_D

        D0_HIT      		: out std_logic_vector(17 downto 0);
        D1_HIT      		: out std_logic_vector(17 downto 0);
        D2_HIT      		: out std_logic_vector(17 downto 0);
        D3_HIT      		: out std_logic_vector(17 downto 0);
        D4_HIT      		: out std_logic_vector(17 downto 0);
        D5_HIT      		: out std_logic_vector(17 downto 0);
        enD_wr      		: out std_logic_vector(5 downto 0);
        init_ev0_lamb3  : out std_logic;
        init_ev1_lamb3  : out std_logic;
        init_ev2_lamb3  : out std_logic;
        sel3_b      		: out std_logic;
        opcode3_out     : out std_logic_vector(3 downto 0);
 		    dr3_b      		: in std_logic;
        ladd3     		: in std_logic_vector(20 downto 0);
				tck_am_lamb3      		: out std_logic;
 
-- Other signals

        p0_odata      		: out std_logic_vector(29 downto 0);
        p1_odata      		: out std_logic_vector(29 downto 0);
        p2_odata      		: out std_logic_vector(29 downto 0);
        p3_odata      		: out std_logic_vector(29 downto 0);
        wr_road      		: out std_logic_vector(3 downto 0);
        push      		: out std_logic_vector(5 downto 0);
        bitmap_status   : out std_logic_vector(3 downto 0);
        wrpam      		: out std_logic;
        rdbscan      	: out std_logic;
        enb_b      		: out std_logic;
        dirw_b      		: out std_logic;
        add  				: out std_logic_vector(2 downto 0);
        lamb_spare  		: in std_logic_vector(3 downto 0);
        road_end  		: in std_logic_vector(3 downto 0);
        rhold_b   			: in  std_logic;     
        backhold_b   		: in  std_logic;     
        en_back   		: in  std_logic;
       	back_init   		: in  std_logic

        );
  end component;

component fe_cbc_module is
  generic (
    NLAYER : integer range 1 to 8 := 6;  -- Number of layers
    NFE : integer range 1 to 16 := 8  -- Number of fe_cbc_chip in fe_module
  );  
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    en       : in  std_logic;
    layer    : in  std_logic_vector(3 downto 0);
    phi      : in  std_logic_vector(3 downto 0);
    z        : in  std_logic_vector(3 downto 0);
    fe_data  : out std_logic_vector(31 downto 0));

end component;

component x6_data_organizer is
  generic (
    NL : integer range 1 to 8 := 6
  );  
  port(

    clk   : in std_logic;
    rst   : in std_logic;

	  phi : in std_logic_vector(3 downto 0);
	  z : in std_logic_vector(3 downto 0);
	  
	  l0_fe_data : in std_logic_vector(31 downto 0);
	  l0_stub_dv  : out std_logic_vector(11 downto 0);
    l0_stub_d00 : out std_logic_vector(15 downto 0);
    l0_stub_d01 : out std_logic_vector(15 downto 0);
    l0_stub_d02 : out std_logic_vector(15 downto 0);
    l0_stub_d03 : out std_logic_vector(15 downto 0);
    l0_stub_d04 : out std_logic_vector(15 downto 0);
    l0_stub_d05 : out std_logic_vector(15 downto 0);
    l0_stub_d06 : out std_logic_vector(15 downto 0);
    l0_stub_d07 : out std_logic_vector(15 downto 0);
    l0_stub_d08 : out std_logic_vector(15 downto 0);
    l0_stub_d09 : out std_logic_vector(15 downto 0);
    l0_stub_d10 : out std_logic_vector(15 downto 0);
    l0_stub_d11 : out std_logic_vector(15 downto 0);
    
    l1_fe_data : in std_logic_vector(31 downto 0);
    l1_stub_dv  : out std_logic_vector(11 downto 0);
    l1_stub_d00 : out std_logic_vector(15 downto 0);
    l1_stub_d01 : out std_logic_vector(15 downto 0);
    l1_stub_d02 : out std_logic_vector(15 downto 0);
    l1_stub_d03 : out std_logic_vector(15 downto 0);
    l1_stub_d04 : out std_logic_vector(15 downto 0);
    l1_stub_d05 : out std_logic_vector(15 downto 0);
    l1_stub_d06 : out std_logic_vector(15 downto 0);
    l1_stub_d07 : out std_logic_vector(15 downto 0);
    l1_stub_d08 : out std_logic_vector(15 downto 0);
    l1_stub_d09 : out std_logic_vector(15 downto 0);
    l1_stub_d10 : out std_logic_vector(15 downto 0);
    l1_stub_d11 : out std_logic_vector(15 downto 0);
    
    l2_fe_data : in std_logic_vector(31 downto 0);
    l2_stub_dv  : out std_logic_vector(11 downto 0);
    l2_stub_d00 : out std_logic_vector(15 downto 0);
    l2_stub_d01 : out std_logic_vector(15 downto 0);
    l2_stub_d02 : out std_logic_vector(15 downto 0);
    l2_stub_d03 : out std_logic_vector(15 downto 0);
    l2_stub_d04 : out std_logic_vector(15 downto 0);
    l2_stub_d05 : out std_logic_vector(15 downto 0);
    l2_stub_d06 : out std_logic_vector(15 downto 0);
    l2_stub_d07 : out std_logic_vector(15 downto 0);
    l2_stub_d08 : out std_logic_vector(15 downto 0);
    l2_stub_d09 : out std_logic_vector(15 downto 0);
    l2_stub_d10 : out std_logic_vector(15 downto 0);
    l2_stub_d11 : out std_logic_vector(15 downto 0);
   
    l3_fe_data : in std_logic_vector(31 downto 0);
    l3_stub_dv  : out std_logic_vector(11 downto 0);
    l3_stub_d00 : out std_logic_vector(15 downto 0);
    l3_stub_d01 : out std_logic_vector(15 downto 0);
    l3_stub_d02 : out std_logic_vector(15 downto 0);
    l3_stub_d03 : out std_logic_vector(15 downto 0);
    l3_stub_d04 : out std_logic_vector(15 downto 0);
    l3_stub_d05 : out std_logic_vector(15 downto 0);
    l3_stub_d06 : out std_logic_vector(15 downto 0);
    l3_stub_d07 : out std_logic_vector(15 downto 0);
    l3_stub_d08 : out std_logic_vector(15 downto 0);
    l3_stub_d09 : out std_logic_vector(15 downto 0);
    l3_stub_d10 : out std_logic_vector(15 downto 0);
    l3_stub_d11 : out std_logic_vector(15 downto 0);
   
	  l4_fe_data : in std_logic_vector(31 downto 0);
    l4_stub_dv  : out std_logic_vector(11 downto 0);
    l4_stub_d00 : out std_logic_vector(15 downto 0);
    l4_stub_d01 : out std_logic_vector(15 downto 0);
    l4_stub_d02 : out std_logic_vector(15 downto 0);
    l4_stub_d03 : out std_logic_vector(15 downto 0);
    l4_stub_d04 : out std_logic_vector(15 downto 0);
    l4_stub_d05 : out std_logic_vector(15 downto 0);
    l4_stub_d06 : out std_logic_vector(15 downto 0);
    l4_stub_d07 : out std_logic_vector(15 downto 0);
    l4_stub_d08 : out std_logic_vector(15 downto 0);
    l4_stub_d09 : out std_logic_vector(15 downto 0);
    l4_stub_d10 : out std_logic_vector(15 downto 0);
    l4_stub_d11 : out std_logic_vector(15 downto 0);
   
	  l5_fe_data : in std_logic_vector(31 downto 0);
    l5_stub_dv  : out std_logic_vector(11 downto 0);
    l5_stub_d00 : out std_logic_vector(15 downto 0);
    l5_stub_d01 : out std_logic_vector(15 downto 0);
    l5_stub_d02 : out std_logic_vector(15 downto 0);
    l5_stub_d03 : out std_logic_vector(15 downto 0);
    l5_stub_d04 : out std_logic_vector(15 downto 0);
    l5_stub_d05 : out std_logic_vector(15 downto 0);
    l5_stub_d06 : out std_logic_vector(15 downto 0);
    l5_stub_d07 : out std_logic_vector(15 downto 0);
    l5_stub_d08 : out std_logic_vector(15 downto 0);
    l5_stub_d09 : out std_logic_vector(15 downto 0);
    l5_stub_d10 : out std_logic_vector(15 downto 0);
    l5_stub_d11 : out std_logic_vector(15 downto 0));

end component;

component x6_fifo_manager is
  port(
  
    clk   : in std_logic;
    rst   : in std_logic;

-- Layer 0   

    l0_stub_in_dv : in std_logic_vector(11 downto 0);

    l0_stub_in_0 : in std_logic_vector(15 downto 0);
    l0_stub_in_1 : in std_logic_vector(15 downto 0);
    l0_stub_in_2 : in std_logic_vector(15 downto 0);
    l0_stub_in_3 : in std_logic_vector(15 downto 0);
    l0_stub_in_4 : in std_logic_vector(15 downto 0);
    l0_stub_in_5 : in std_logic_vector(15 downto 0);
    l0_stub_in_6 : in std_logic_vector(15 downto 0);
    l0_stub_in_7 : in std_logic_vector(15 downto 0);
    l0_stub_in_8 : in std_logic_vector(15 downto 0);
    l0_stub_in_9 : in std_logic_vector(15 downto 0);
    l0_stub_in_10 : in std_logic_vector(15 downto 0);
    l0_stub_in_11 : in std_logic_vector(15 downto 0);

    l0_stub_out_dv : out std_logic_vector(3 downto 0);

    l0_stub_out_0 : out std_logic_vector(16 downto 0);
    l0_stub_out_1 : out std_logic_vector(16 downto 0);
    l0_stub_out_2 : out std_logic_vector(16 downto 0);
    l0_stub_out_3 : out std_logic_vector(16 downto 0);

    l0_n_stub_in_dv : in std_logic;
    l0_n_stub_in_data : in std_logic_vector(15 downto 0);
    l0_p_stub_in_dv : in std_logic;
    l0_p_stub_in_data : in std_logic_vector(15 downto 0);
  
    l0_n_stub_out_dv : out std_logic;
    l0_n_stub_out_data : out std_logic_vector(15 downto 0);
    l0_p_stub_out_dv : out std_logic;
    l0_p_stub_out_data : out std_logic_vector(15 downto 0);
  
-- Layer 1   

    l1_stub_in_dv : in std_logic_vector(11 downto 0);

    l1_stub_in_0 : in std_logic_vector(15 downto 0);
    l1_stub_in_1 : in std_logic_vector(15 downto 0);
    l1_stub_in_2 : in std_logic_vector(15 downto 0);
    l1_stub_in_3 : in std_logic_vector(15 downto 0);
    l1_stub_in_4 : in std_logic_vector(15 downto 0);
    l1_stub_in_5 : in std_logic_vector(15 downto 0);
    l1_stub_in_6 : in std_logic_vector(15 downto 0);
    l1_stub_in_7 : in std_logic_vector(15 downto 0);
    l1_stub_in_8 : in std_logic_vector(15 downto 0);
    l1_stub_in_9 : in std_logic_vector(15 downto 0);
    l1_stub_in_10 : in std_logic_vector(15 downto 0);
    l1_stub_in_11 : in std_logic_vector(15 downto 0);

    l1_stub_out_dv : out std_logic_vector(3 downto 0);

    l1_stub_out_0 : out std_logic_vector(16 downto 0);
    l1_stub_out_1 : out std_logic_vector(16 downto 0);
    l1_stub_out_2 : out std_logic_vector(16 downto 0);
    l1_stub_out_3 : out std_logic_vector(16 downto 0);
   
    l1_n_stub_in_dv : in std_logic;
    l1_n_stub_in_data : in std_logic_vector(15 downto 0);
    l1_p_stub_in_dv : in std_logic;
    l1_p_stub_in_data : in std_logic_vector(15 downto 0);
  
    l1_n_stub_out_dv : out std_logic;
    l1_n_stub_out_data : out std_logic_vector(15 downto 0);
    l1_p_stub_out_dv : out std_logic;
    l1_p_stub_out_data : out std_logic_vector(15 downto 0);
  
-- Layer 2   

    l2_stub_in_dv : in std_logic_vector(11 downto 0);

    l2_stub_in_0 : in std_logic_vector(15 downto 0);
    l2_stub_in_1 : in std_logic_vector(15 downto 0);
    l2_stub_in_2 : in std_logic_vector(15 downto 0);
    l2_stub_in_3 : in std_logic_vector(15 downto 0);
    l2_stub_in_4 : in std_logic_vector(15 downto 0);
    l2_stub_in_5 : in std_logic_vector(15 downto 0);
    l2_stub_in_6 : in std_logic_vector(15 downto 0);
    l2_stub_in_7 : in std_logic_vector(15 downto 0);
    l2_stub_in_8 : in std_logic_vector(15 downto 0);
    l2_stub_in_9 : in std_logic_vector(15 downto 0);
    l2_stub_in_10 : in std_logic_vector(15 downto 0);
    l2_stub_in_11 : in std_logic_vector(15 downto 0);

    l2_stub_out_dv : out std_logic_vector(3 downto 0);  

    l2_stub_out_0 : out std_logic_vector(16 downto 0);
    l2_stub_out_1 : out std_logic_vector(16 downto 0);
    l2_stub_out_2 : out std_logic_vector(16 downto 0);
    l2_stub_out_3 : out std_logic_vector(16 downto 0);
	
    l2_n_stub_in_dv : in std_logic;
    l2_n_stub_in_data : in std_logic_vector(15 downto 0);
    l2_p_stub_in_dv : in std_logic;
    l2_p_stub_in_data : in std_logic_vector(15 downto 0);
  
    l2_n_stub_out_dv : out std_logic;
    l2_n_stub_out_data : out std_logic_vector(15 downto 0);
    l2_p_stub_out_dv : out std_logic;
    l2_p_stub_out_data : out std_logic_vector(15 downto 0);
  
-- Layer 3   

    l3_stub_in_dv : in std_logic_vector(11 downto 0);

    l3_stub_in_0 : in std_logic_vector(15 downto 0);
    l3_stub_in_1 : in std_logic_vector(15 downto 0);
    l3_stub_in_2 : in std_logic_vector(15 downto 0);
    l3_stub_in_3 : in std_logic_vector(15 downto 0);
    l3_stub_in_4 : in std_logic_vector(15 downto 0);
    l3_stub_in_5 : in std_logic_vector(15 downto 0);
    l3_stub_in_6 : in std_logic_vector(15 downto 0);
    l3_stub_in_7 : in std_logic_vector(15 downto 0);
    l3_stub_in_8 : in std_logic_vector(15 downto 0);
    l3_stub_in_9 : in std_logic_vector(15 downto 0);
    l3_stub_in_10 : in std_logic_vector(15 downto 0);
    l3_stub_in_11 : in std_logic_vector(15 downto 0);

    l3_stub_out_dv : out std_logic_vector(3 downto 0);

    l3_stub_out_0 : out std_logic_vector(16 downto 0);
    l3_stub_out_1 : out std_logic_vector(16 downto 0);
    l3_stub_out_2 : out std_logic_vector(16 downto 0);
    l3_stub_out_3 : out std_logic_vector(16 downto 0);
	
    l3_n_stub_in_dv : in std_logic;
    l3_n_stub_in_data : in std_logic_vector(15 downto 0);
    l3_p_stub_in_dv : in std_logic;
    l3_p_stub_in_data : in std_logic_vector(15 downto 0);
  
    l3_n_stub_out_dv : out std_logic;
    l3_n_stub_out_data : out std_logic_vector(15 downto 0);
    l3_p_stub_out_dv : out std_logic;
    l3_p_stub_out_data : out std_logic_vector(15 downto 0);
  
-- Layer 4   

    l4_stub_in_dv : in std_logic_vector(11 downto 0);

    l4_stub_in_0 : in std_logic_vector(15 downto 0);
    l4_stub_in_1 : in std_logic_vector(15 downto 0);
    l4_stub_in_2 : in std_logic_vector(15 downto 0);
    l4_stub_in_3 : in std_logic_vector(15 downto 0);
    l4_stub_in_4 : in std_logic_vector(15 downto 0);
    l4_stub_in_5 : in std_logic_vector(15 downto 0);
    l4_stub_in_6 : in std_logic_vector(15 downto 0);
    l4_stub_in_7 : in std_logic_vector(15 downto 0);
    l4_stub_in_8 : in std_logic_vector(15 downto 0);
    l4_stub_in_9 : in std_logic_vector(15 downto 0);
    l4_stub_in_10 : in std_logic_vector(15 downto 0);
    l4_stub_in_11 : in std_logic_vector(15 downto 0);

    l4_stub_out_dv : out std_logic_vector(3 downto 0);

    l4_stub_out_0 : out std_logic_vector(16 downto 0);
    l4_stub_out_1 : out std_logic_vector(16 downto 0);
    l4_stub_out_2 : out std_logic_vector(16 downto 0);
    l4_stub_out_3 : out std_logic_vector(16 downto 0);
	
    l4_n_stub_in_dv : in std_logic;
    l4_n_stub_in_data : in std_logic_vector(15 downto 0);
    l4_p_stub_in_dv : in std_logic;
    l4_p_stub_in_data : in std_logic_vector(15 downto 0);
  
    l4_n_stub_out_dv : out std_logic;
    l4_n_stub_out_data : out std_logic_vector(15 downto 0);
    l4_p_stub_out_dv : out std_logic;
    l4_p_stub_out_data : out std_logic_vector(15 downto 0);
  
-- Layer 5   

    l5_stub_in_dv : in std_logic_vector(11 downto 0);

    l5_stub_in_0 : in std_logic_vector(15 downto 0);
    l5_stub_in_1 : in std_logic_vector(15 downto 0);
    l5_stub_in_2 : in std_logic_vector(15 downto 0);
    l5_stub_in_3 : in std_logic_vector(15 downto 0);
    l5_stub_in_4 : in std_logic_vector(15 downto 0);
    l5_stub_in_5 : in std_logic_vector(15 downto 0);
    l5_stub_in_6 : in std_logic_vector(15 downto 0);
    l5_stub_in_7 : in std_logic_vector(15 downto 0);
    l5_stub_in_8 : in std_logic_vector(15 downto 0);
    l5_stub_in_9 : in std_logic_vector(15 downto 0);
    l5_stub_in_10 : in std_logic_vector(15 downto 0);
    l5_stub_in_11 : in std_logic_vector(15 downto 0);

    l5_stub_out_dv : out std_logic_vector(3 downto 0);

    l5_stub_out_0 : out std_logic_vector(16 downto 0);
    l5_stub_out_1 : out std_logic_vector(16 downto 0);
    l5_stub_out_2 : out std_logic_vector(16 downto 0);
    l5_stub_out_3 : out std_logic_vector(16 downto 0);

    l5_n_stub_in_dv : in std_logic;
    l5_n_stub_in_data : in std_logic_vector(15 downto 0);
    l5_p_stub_in_dv : in std_logic;
    l5_p_stub_in_data : in std_logic_vector(15 downto 0);
  
    l5_n_stub_out_dv : out std_logic;
    l5_n_stub_out_data : out std_logic_vector(15 downto 0);
    l5_p_stub_out_dv : out std_logic;
    l5_p_stub_out_data : out std_logic_vector(15 downto 0));

end component;

component am_chip is
  port(
  
    clk   : in std_logic;
    rst   : in std_logic;

    phi : in std_logic_vector(3 downto 0);
    z : in std_logic_vector(3 downto 0);

    chip_id   : in integer;

    opcode : in std_logic_vector(3 downto 0);
    tck : in std_logic;
    tdi : in std_logic;
    tms : in std_logic;
    tdo : out std_logic;

    l0_hit : in std_logic_vector(17 downto 0);
    l1_hit : in std_logic_vector(17 downto 0);
    l2_hit : in std_logic_vector(17 downto 0);
    l3_hit : in std_logic_vector(17 downto 0);
    l4_hit : in std_logic_vector(17 downto 0);
    l5_hit : in std_logic_vector(17 downto 0);
    en_wr : in std_logic_vector(5 downto 0);
    init_ev : in std_logic_vector(2 downto 0);
    sel_b : in std_logic;
    dr_b : out std_logic;
	  ladd : out std_logic_vector(20 downto 0));
	  
end component;


-- enable, reset and clock signals

  signal rst      : std_logic := '0';
  signal rst_b      : std_logic := '1';

  signal eor             : std_logic;

-- signals to/from test_controller (from/to slv_mgt module)

  signal start           : std_logic;
  signal start_res       : std_logic;
  signal stop            : std_logic;
  signal stop_res        : std_logic;
  signal vme_cmd_reg     : std_logic_vector(31 downto 0);
  signal vme_dat_reg_in  : std_logic_vector(31 downto 0);
  signal vme_dat_reg_out : std_logic_vector(31 downto 0);
  signal mode            : std_logic                    := '1';  -- read commands from file
  signal cmd_n           : std_logic_vector(9 downto 0) := "0000000000";
  signal busy            : std_logic;

-- signals to/from test_controller (from/to cmd and dat memories)

  signal vme_mem_addr     : std_logic_vector(9 downto 0);
  signal vme_mem_rden     : std_logic;
  signal vme_cmd_mem_out  : std_logic_vector(31 downto 0);
  signal vme_dat_mem_out  : std_logic_vector(31 downto 0);
  signal vme_dat_mem_wren : std_logic;
  signal vme_dat_mem_in   : std_logic_vector(31 downto 0);

-- signals between test_controller and vme_master_fsm and command_module

  signal vme_cmd     : std_logic;
  signal vme_cmd_rd  : std_logic;
  signal vme_addr    : std_logic_vector(23 downto 1);
  signal vme_wr      : std_logic;
  signal vme_wr_data : std_logic_vector(15 downto 0);
  signal vme_rd      : std_logic;
  signal vme_rd_data : std_logic_vector(15 downto 0);
--  signal vme_data    : std_logic_vector(15 downto 0);
  signal vme_data    : std_logic_vector(31 downto 0);
  signal x4_vme_data    : std_logic_vector(31 downto 0);

-- signals between vme_master_fsm and command_module

  signal berr        : std_logic;
  signal berr_out    : std_logic;
  signal x4_berr_out    : std_logic;
  signal as          : std_logic;
-- signal ds0 : std_logic;
-- signal ds1 : std_logic;
  signal ds          : std_logic_vector(1 downto 0);
  signal lword       : std_logic;
  signal write_b     : std_logic;
  signal iack        : std_logic;
  signal sysfail     : std_logic;
  signal sysfail_out : std_logic;
  signal am          : std_logic_vector(5 downto 0);
  signal ga          : std_logic_vector(5 downto 0);
--  signal adr         : std_logic_vector(23 downto 1);
  signal adr         : std_logic_vector(31 downto 1);
  signal oe_b        : std_logic;

-- signals between vme_master_fsm and cfebjtag and lvdbmon modules

  signal dtack   : std_logic;
  signal x4_dtack   : std_logic;
--  signal indata  : std_logic_vector(15 downto 0);
--  signal outdata : std_logic_vector(15 downto 0);
  signal indata  : std_logic_vector(31 downto 0);
  signal outdata : std_logic_vector(31 downto 0);

  signal tovme, doe_b : std_logic;

-- Signals From Hit Generators

  constant NL : integer := 6;
  constant NFE : integer := 8;

  type layer_data_in is array (NL-1 downto 0) of std_logic_vector(23 downto 0);
  signal hit_data : layer_data_in;

  signal hit_dv : std_logic_vector(NL-1 downto 0);

  type road_data is array (15 downto 0) of std_logic_vector(29 downto 0);
  signal road : road_data;

  signal road_dv : std_logic_vector(15 downto 0);

-- Signals To/From Hit FIFOs

	signal fifo_rst                 : std_logic_vector(NL-1 downto 0);
	signal fifo_aempty              : std_logic_vector(NL-1 downto 0);
	signal fifo_afull               : std_logic_vector(NL-1 downto 0);
	signal fifo_empty,fifo_empty_b  : std_logic_vector(NL-1 downto 0);
	signal fifo_full                : std_logic_vector(NL-1 downto 0);
	signal fifo_wren, fifo_wrck     : std_logic_vector(NL-1 downto 0);
	signal fifo_rden, fifo_rdck     : std_logic_vector(NL-1 downto 0);
  signal fifo_in, fifo_out : layer_data_in;
	type   fifo_cnt_type is array (NL-1 downto 0) of std_logic_vector(9 downto 0);
	signal fifo_wr_cnt, fifo_rd_cnt : fifo_cnt_type;

-- Signals From/To LAMBs

  type layer_data_out is array (NL-1 downto 0) of std_logic_vector(17 downto 0);
  type lamb_data_in is array (3 downto 0) of layer_data_out;
  signal lamb_data : lamb_data_in;
  signal am_data : lamb_data_in;

  type lamb_data_out is array (3 downto 0) of std_logic_vector(20 downto 0);
	signal lamb_ladd : lamb_data_out;
	signal x4_lamb_ladd : lamb_data_out;

  signal lamb_dr_b : std_logic_vector(3 downto 0);
  signal x4_lamb_dr_b : std_logic_vector(3 downto 0);

	type lamb_wren_type is array (3 downto 0) of std_logic_vector(NL-1 downto 0);
  signal lamb_wren : lamb_wren_type;
  signal am_wren : lamb_wren_type;

	type lamb_init_ev_type is array (3 downto 0) of std_logic_vector(2 downto 0);
  signal lamb_init_ev : lamb_init_ev_type;
  signal am_init_ev : lamb_init_ev_type;

  signal lamb_sel : std_logic_vector(3 downto 0);
  signal x4_lamb_sel : std_logic_vector(3 downto 0);

	type lamb_opcode_type is array (3 downto 0) of std_logic_vector(3 downto 0);
  signal lamb_opcode : lamb_opcode_type;
  signal x4_lamb_opcode : lamb_opcode_type;

  signal lamb_tck : std_logic_vector(3 downto 0);
  signal x4_lamb_tck : std_logic_vector(3 downto 0);

	signal lamb0_dr_b : std_logic := '1';
	signal lamb0_ladd : std_logic_vector(20 downto 0) := (others => '0');

-- Other signals

	signal odata : std_logic_vector(29 downto 0); -- OUT
	signal resfifo_b : std_logic_vector(1 downto 0); -- OUT
	signal wr_road	: std_logic; -- OUT
	signal init : std_logic; -- OUT
	signal push : std_logic_vector(5 downto 0); -- OUT
	signal bitmap_status : std_logic_vector(3 downto 0); -- OUT
	signal wrpam : std_logic; -- OUT
	signal rdbscan	: std_logic; -- OUT
	signal enb_b : std_logic; -- OUT
	signal dirw_b : std_logic; -- OUT
	signal add : std_logic_vector(2 downto 0); -- OUT

	signal lamb_spare : std_logic_vector(3 downto 0) := "0000"; -- IN  
	signal road_end : std_logic_vector(3 downto 0) := "0000"; -- IN     
	signal rhold_b : std_logic := '1'; -- IN          
	signal backhold_b : std_logic := '1'; -- IN     
	signal en_back : std_logic := '0'; -- IN
	signal back_init : std_logic := '0'; -- IN

	signal x4_p0_odata : std_logic_vector(29 downto 0); -- OUT
	signal x4_p1_odata : std_logic_vector(29 downto 0); -- OUT
	signal x4_p2_odata : std_logic_vector(29 downto 0); -- OUT
	signal x4_p3_odata : std_logic_vector(29 downto 0); -- OUT
	signal x4_resfifo_b : std_logic_vector(1 downto 0); -- OUT
	signal x4_wr_road	: std_logic_vector(3 downto 0); -- OUT
	signal x4_init : std_logic; -- OUT
	signal x4_push : std_logic_vector(5 downto 0); -- OUT
	signal x4_bitmap_status : std_logic_vector(3 downto 0); -- OUT
	signal x4_wrpam : std_logic; -- OUT
	signal x4_rdbscan	: std_logic; -- OUT
	signal x4_enb_b : std_logic; -- OUT
	signal x4_dirw_b : std_logic; -- OUT
	signal x4_add : std_logic_vector(2 downto 0); -- OUT


-- Logic Levels

	signal LOGIC0 : std_logic := '0';
	signal LOGIC1 : std_logic := '1';

signal  layer0_fe0_hit1_dv : std_logic;
signal  layer0_fe0_hit1_data : std_logic_vector(12 downto 0);
signal  layer0_fe0_hit2_dv : std_logic;
signal  layer0_fe0_hit2_data : std_logic_vector(12 downto 0);
signal  layer0_fe0_hit3_dv : std_logic;
signal  layer0_fe0_hit3_data : std_logic_vector(12 downto 0);

type layer_array is array (NL-1 downto 0) of std_logic_vector(3 downto 0);
signal layer : layer_array;

type fe_id_array is array (NFE-1 downto 0) of std_logic_vector(3 downto 0);
signal fe_id : fe_id_array;

type stub_data_vector is array (NFE-1 downto 0) of std_logic_vector(12 downto 0);
type stub_data_array is array (NL-1 downto 0) of stub_data_vector;
signal stub1_data, stub2_data, stub3_data : stub_data_array;

type do_stub_data_vector is array (11 downto 0) of std_logic_vector(15 downto 0);
type do_stub_data_array is array (NL-1 downto 0) of do_stub_data_vector;
signal do_stub_data : do_stub_data_array;

type do_stub_dv_array is array (NL-1 downto 0) of std_logic_vector(11 downto 0);
signal do_stub_dv : do_stub_dv_array;

type stub_dv_vector is array (NFE-1 downto 0) of std_logic;
type stub_dv_array is array (NL-1 downto 0) of stub_dv_vector;
signal stub1_dv, stub2_dv, stub3_dv : stub_dv_array;

type stub_dv_vector1 is array (NFE-1 downto 0) of std_logic_vector(2 downto 0);
type stub_dv_array1 is array (NL-1 downto 0) of stub_dv_vector1;
signal stub_dv : stub_dv_array1;

type fe_data_vector is array (NL-1 downto 0) of std_logic_vector(31 downto 0);
signal fe_data : fe_data_vector;

-- Jan 4
-- type fm_stub_data_vector is array (3 downto 0) of std_logic_vector(15 downto 0);
type fm_stub_data_vector is array (NL-1 downto 0) of std_logic_vector(16 downto 0);
type fm_stub_data_array is array (3 downto 0) of fm_stub_data_vector;
signal fm_stub_data : fm_stub_data_array;

type fm_stub_dv_array is array (NL-1 downto 0) of std_logic_vector(3 downto 0);
signal fm_stub_dv : fm_stub_dv_array;

-- Jan 4
-- type sf_stub_vector is array (3 downto 0) of std_logic_vector(15 downto 0);
type sf_stub_vector is array (NL-1 downto 0) of std_logic_vector(23 downto 0);
type sf_stub_array is array (3 downto 0) of sf_stub_vector;
signal sf_in, sf_out : sf_stub_array;

type sf_cnt_vector is array (NL-1 downto 0) of std_logic_vector(9 downto 0);
type sf_cnt_array is array (3 downto 0) of sf_cnt_vector;
signal sf_wr_cnt, sf_rd_cnt : sf_cnt_array;

type sf_ctrl_array is array (3 downto 0) of std_logic_vector(NL-1 downto 0);
signal sf_wren,sf_wrck,sf_rden,sf_rdck,sf_rst : sf_ctrl_array;

type sf_flag_array is array (3 downto 0) of std_logic_vector(NL-1 downto 0);
signal sf_empty_b,sf_empty,sf_aempty,sf_afull,sf_full : sf_flag_array;

type np_stub_data_vector is array (NL-1 downto 0) of std_logic_vector(15 downto 0);
signal n_stub_in_data, n_stub_out_data : np_stub_data_vector;
signal p_stub_in_data, p_stub_out_data : np_stub_data_vector;

signal n_stub_in_dv, n_stub_out_dv : std_logic_vector(NL-1 downto 0) := (others => '0');
signal p_stub_in_dv, p_stub_out_dv : std_logic_vector(NL-1 downto 0) := (others => '0');

signal z,phi : std_logic_vector(3 downto 0);

begin

      z <= std_logic_vector(to_unsigned(z_id, 4));
      phi <= std_logic_vector(to_unsigned(phi_id, 4));

sync_rst : process (reset,clk40MHz)

  begin
    if rising_edge(clk40MHz) then
      rst <= reset;
      rst_b <= not reset;
    end if;

end process;

  
  dtack <= 'H';

  eor <= '0', '1' after 5000 ns;

--  layer(0) <= "0001";
--  layer(1) <= "0010";
--  layer(2) <= "0011";
--  layer(3) <= "0100";
--  layer(4) <= "0101";
--  layer(5) <= "0110";
  layer(0) <= "0000";
  layer(1) <= "0001";
  layer(2) <= "0010";
  layer(3) <= "0011";
  layer(4) <= "0100";
  layer(5) <= "0101";
  
  GEN_MODULES : for I in NL-1 downto 0 generate
  
  begin

  FE_M : fe_cbc_module
    generic map(
      NLAYER => 6,  
      NFE => 8)  
    port map(
      clk => clk40MHz,
      rst => rst,
      en => enable,
      layer => layer(I),
      phi => phi,
      z => z,
      fe_data => fe_data(I));

  end generate GEN_MODULES;

  DO_M : x6_data_organizer
    generic map(
      NL => 6)  
    port map(

      clk => clk40MHz,
      rst => rst,

      phi => phi,
      z => z,
      
      l0_fe_data => fe_data(0),
	    l0_stub_dv => do_stub_dv(0),
	    l0_stub_d00 => do_stub_data(0)(0),
	    l0_stub_d01 => do_stub_data(0)(1),
	    l0_stub_d02 => do_stub_data(0)(2),
	    l0_stub_d03 => do_stub_data(0)(3),
	    l0_stub_d04 => do_stub_data(0)(4),
	    l0_stub_d05 => do_stub_data(0)(5),
	    l0_stub_d06 => do_stub_data(0)(6),
	    l0_stub_d07 => do_stub_data(0)(7),
	    l0_stub_d08 => do_stub_data(0)(8),
	    l0_stub_d09 => do_stub_data(0)(9),
	    l0_stub_d10 => do_stub_data(0)(10),
	    l0_stub_d11 => do_stub_data(0)(11),
    
	    l1_fe_data => fe_data(1),
	    l1_stub_dv => do_stub_dv(1),
	    l1_stub_d00 => do_stub_data(1)(0),
	    l1_stub_d01 => do_stub_data(1)(1),
	    l1_stub_d02 => do_stub_data(1)(2),
	    l1_stub_d03 => do_stub_data(1)(3),
	    l1_stub_d04 => do_stub_data(1)(4),
	    l1_stub_d05 => do_stub_data(1)(5),
	    l1_stub_d06 => do_stub_data(1)(6),
	    l1_stub_d07 => do_stub_data(1)(7),
	    l1_stub_d08 => do_stub_data(1)(8),
	    l1_stub_d09 => do_stub_data(1)(9),
	    l1_stub_d10 => do_stub_data(1)(10),
	    l1_stub_d11 => do_stub_data(1)(11),
    
	    l2_fe_data => fe_data(2),
	    l2_stub_dv => do_stub_dv(2),
	    l2_stub_d00 => do_stub_data(2)(0),
	    l2_stub_d01 => do_stub_data(2)(1),
	    l2_stub_d02 => do_stub_data(2)(2),
	    l2_stub_d03 => do_stub_data(2)(3),
	    l2_stub_d04 => do_stub_data(2)(4),
	    l2_stub_d05 => do_stub_data(2)(5),
	    l2_stub_d06 => do_stub_data(2)(6),
	    l2_stub_d07 => do_stub_data(2)(7),
	    l2_stub_d08 => do_stub_data(2)(8),
	    l2_stub_d09 => do_stub_data(2)(9),
	    l2_stub_d10 => do_stub_data(2)(10),
	    l2_stub_d11 => do_stub_data(2)(11),
   
	    l3_fe_data => fe_data(3),
	    l3_stub_dv => do_stub_dv(3),
	    l3_stub_d00 => do_stub_data(3)(0),
	    l3_stub_d01 => do_stub_data(3)(1),
	    l3_stub_d02 => do_stub_data(3)(2),
	    l3_stub_d03 => do_stub_data(3)(3),
	    l3_stub_d04 => do_stub_data(3)(4),
	    l3_stub_d05 => do_stub_data(3)(5),
	    l3_stub_d06 => do_stub_data(3)(6),
	    l3_stub_d07 => do_stub_data(3)(7),
	    l3_stub_d08 => do_stub_data(3)(8),
	    l3_stub_d09 => do_stub_data(3)(9),
	    l3_stub_d10 => do_stub_data(3)(10),
	    l3_stub_d11 => do_stub_data(3)(11),
   
	    l4_fe_data => fe_data(4),
	    l4_stub_dv => do_stub_dv(4),
	    l4_stub_d00 => do_stub_data(4)(0),
	    l4_stub_d01 => do_stub_data(4)(1),
	    l4_stub_d02 => do_stub_data(4)(2),
	    l4_stub_d03 => do_stub_data(4)(3),
	    l4_stub_d04 => do_stub_data(4)(4),
	    l4_stub_d05 => do_stub_data(4)(5),
	    l4_stub_d06 => do_stub_data(4)(6),
	    l4_stub_d07 => do_stub_data(4)(7),
	    l4_stub_d08 => do_stub_data(4)(8),
	    l4_stub_d09 => do_stub_data(4)(9),
	    l4_stub_d10 => do_stub_data(4)(10),
	    l4_stub_d11 => do_stub_data(4)(11),
   
	    l5_fe_data => fe_data(5),
	    l5_stub_dv => do_stub_dv(5),
	    l5_stub_d00 => do_stub_data(5)(0),
	    l5_stub_d01 => do_stub_data(5)(1),
	    l5_stub_d02 => do_stub_data(5)(2),
	    l5_stub_d03 => do_stub_data(5)(3),
	    l5_stub_d04 => do_stub_data(5)(4),
	    l5_stub_d05 => do_stub_data(5)(5),
	    l5_stub_d06 => do_stub_data(5)(6),
	    l5_stub_d07 => do_stub_data(5)(7),
	    l5_stub_d08 => do_stub_data(5)(8),
	    l5_stub_d09 => do_stub_data(5)(9),
	    l5_stub_d10 => do_stub_data(5)(10),
	    l5_stub_d11 => do_stub_data(5)(11));

  x6_np_stub_proc : process (n_stub_out_dv,n_stub_out_data,p_stub_out_dv,p_stub_out_data)

  begin

    for I in 0 to 5 loop
      n_stub_in_dv(I) <= p_stub_out_dv(I);
      n_stub_in_data(I) <= p_stub_out_data(I);
      p_stub_in_dv(I) <= n_stub_out_dv(I);
      p_stub_in_data(I) <= n_stub_out_data(I);
    end loop;
  
  end process;

  FM_M : x6_fifo_manager
    port map(
      clk => clk160MHz,
      rst => rst,

-- Layer 0   

      l0_stub_in_dv => do_stub_dv(0),

      l0_stub_in_0 => do_stub_data(0)(0),
      l0_stub_in_1 => do_stub_data(0)(1),
      l0_stub_in_2 => do_stub_data(0)(2),
      l0_stub_in_3 => do_stub_data(0)(3),
      l0_stub_in_4 => do_stub_data(0)(4),
      l0_stub_in_5 => do_stub_data(0)(5),
      l0_stub_in_6 => do_stub_data(0)(6),
      l0_stub_in_7 => do_stub_data(0)(7),
      l0_stub_in_8 => do_stub_data(0)(8),
      l0_stub_in_9 => do_stub_data(0)(9),
      l0_stub_in_10 => do_stub_data(0)(10),
      l0_stub_in_11 => do_stub_data(0)(11),

      l0_stub_out_dv => fm_stub_dv(0),

      l0_stub_out_0 => fm_stub_data(0)(0),
      l0_stub_out_1 => fm_stub_data(1)(0),
      l0_stub_out_2 => fm_stub_data(2)(0),
      l0_stub_out_3 => fm_stub_data(3)(0),

      l0_n_stub_in_dv => l0_n_stub_in_dv,
      l0_n_stub_in_data => l0_n_stub_in_data,
      l0_p_stub_in_dv => l0_p_stub_in_dv,
      l0_p_stub_in_data => l0_p_stub_in_data,
  
      l0_n_stub_out_dv => l0_n_stub_out_dv,
      l0_n_stub_out_data => l0_n_stub_out_data,
      l0_p_stub_out_dv => l0_p_stub_out_dv,
      l0_p_stub_out_data => l0_p_stub_out_data,
  
-- Layer 1   

      l1_stub_in_dv => do_stub_dv(1),

      l1_stub_in_0 => do_stub_data(1)(0),
      l1_stub_in_1 => do_stub_data(1)(1),
      l1_stub_in_2 => do_stub_data(1)(2),
      l1_stub_in_3 => do_stub_data(1)(3),
      l1_stub_in_4 => do_stub_data(1)(4),
      l1_stub_in_5 => do_stub_data(1)(5),
      l1_stub_in_6 => do_stub_data(1)(6),
      l1_stub_in_7 => do_stub_data(1)(7),
      l1_stub_in_8 => do_stub_data(1)(8),
      l1_stub_in_9 => do_stub_data(1)(9),
      l1_stub_in_10 => do_stub_data(1)(10),
      l1_stub_in_11 => do_stub_data(1)(11),

      l1_stub_out_dv => fm_stub_dv(1),

      l1_stub_out_0 => fm_stub_data(0)(1),
      l1_stub_out_1 => fm_stub_data(1)(1),
      l1_stub_out_2 => fm_stub_data(2)(1),
      l1_stub_out_3 => fm_stub_data(3)(1),
   
      l1_n_stub_in_dv => l1_n_stub_in_dv,
      l1_n_stub_in_data => l1_n_stub_in_data,
      l1_p_stub_in_dv => l1_p_stub_in_dv,
      l1_p_stub_in_data => l1_p_stub_in_data,
  
      l1_n_stub_out_dv => l1_n_stub_out_dv,
      l1_n_stub_out_data => l1_n_stub_out_data,
      l1_p_stub_out_dv => l1_p_stub_out_dv,
      l1_p_stub_out_data => l1_p_stub_out_data,
  
-- Layer 2   

      l2_stub_in_dv => do_stub_dv(2),

      l2_stub_in_0 => do_stub_data(2)(0),
      l2_stub_in_1 => do_stub_data(2)(1),
      l2_stub_in_2 => do_stub_data(2)(2),
      l2_stub_in_3 => do_stub_data(2)(3),
      l2_stub_in_4 => do_stub_data(2)(4),
      l2_stub_in_5 => do_stub_data(2)(5),
      l2_stub_in_6 => do_stub_data(2)(6),
      l2_stub_in_7 => do_stub_data(2)(7),
      l2_stub_in_8 => do_stub_data(2)(8),
      l2_stub_in_9 => do_stub_data(2)(9),
      l2_stub_in_10 => do_stub_data(2)(10),
      l2_stub_in_11 => do_stub_data(2)(11),

      l2_stub_out_dv => fm_stub_dv(2),

      l2_stub_out_0 => fm_stub_data(0)(2),
      l2_stub_out_1 => fm_stub_data(1)(2),
      l2_stub_out_2 => fm_stub_data(2)(2),
      l2_stub_out_3 => fm_stub_data(3)(2),
   	
      l2_n_stub_in_dv => l2_n_stub_in_dv,
      l2_n_stub_in_data => l2_n_stub_in_data,
      l2_p_stub_in_dv => l2_p_stub_in_dv,
      l2_p_stub_in_data => l2_p_stub_in_data,
  
      l2_n_stub_out_dv => l2_n_stub_out_dv,
      l2_n_stub_out_data => l2_n_stub_out_data,
      l2_p_stub_out_dv => l2_p_stub_out_dv,
      l2_p_stub_out_data => l2_p_stub_out_data,

-- Layer 3   

      l3_stub_in_dv => do_stub_dv(3),

      l3_stub_in_0 => do_stub_data(3)(0),
      l3_stub_in_1 => do_stub_data(3)(1),
      l3_stub_in_2 => do_stub_data(3)(2),
      l3_stub_in_3 => do_stub_data(3)(3),
      l3_stub_in_4 => do_stub_data(3)(4),
      l3_stub_in_5 => do_stub_data(3)(5),
      l3_stub_in_6 => do_stub_data(3)(6),
      l3_stub_in_7 => do_stub_data(3)(7),
      l3_stub_in_8 => do_stub_data(3)(8),
      l3_stub_in_9 => do_stub_data(3)(9),
      l3_stub_in_10 => do_stub_data(3)(10),
      l3_stub_in_11 => do_stub_data(3)(11),

      l3_stub_out_dv => fm_stub_dv(3),

      l3_stub_out_0 => fm_stub_data(0)(3),
      l3_stub_out_1 => fm_stub_data(1)(3),
      l3_stub_out_2 => fm_stub_data(2)(3),
      l3_stub_out_3 => fm_stub_data(3)(3),
   		
      l3_n_stub_in_dv => l3_n_stub_in_dv,
      l3_n_stub_in_data => l3_n_stub_in_data,
      l3_p_stub_in_dv => l3_p_stub_in_dv,
      l3_p_stub_in_data => l3_p_stub_in_data,
  
      l3_n_stub_out_dv => l3_n_stub_out_dv,
      l3_n_stub_out_data => l3_n_stub_out_data,
      l3_p_stub_out_dv => l3_p_stub_out_dv,
      l3_p_stub_out_data => l3_p_stub_out_data,

-- Layer 4   

      l4_stub_in_dv => do_stub_dv(4),

      l4_stub_in_0 => do_stub_data(4)(0),
      l4_stub_in_1 => do_stub_data(4)(1),
      l4_stub_in_2 => do_stub_data(4)(2),
      l4_stub_in_3 => do_stub_data(4)(3),
      l4_stub_in_4 => do_stub_data(4)(4),
      l4_stub_in_5 => do_stub_data(4)(5),
      l4_stub_in_6 => do_stub_data(4)(6),
      l4_stub_in_7 => do_stub_data(4)(7),
      l4_stub_in_8 => do_stub_data(4)(8),
      l4_stub_in_9 => do_stub_data(4)(9),
      l4_stub_in_10 => do_stub_data(4)(10),
      l4_stub_in_11 => do_stub_data(4)(11),

      l4_stub_out_dv => fm_stub_dv(4),

      l4_stub_out_0 => fm_stub_data(0)(4),
      l4_stub_out_1 => fm_stub_data(1)(4),
      l4_stub_out_2 => fm_stub_data(2)(4),
      l4_stub_out_3 => fm_stub_data(3)(4),
   		
      l4_n_stub_in_dv => l4_n_stub_in_dv,
      l4_n_stub_in_data => l4_n_stub_in_data,
      l4_p_stub_in_dv => l4_p_stub_in_dv,
      l4_p_stub_in_data => l4_p_stub_in_data,
  
      l4_n_stub_out_dv => l4_n_stub_out_dv,
      l4_n_stub_out_data => l4_n_stub_out_data,
      l4_p_stub_out_dv => l4_p_stub_out_dv,
      l4_p_stub_out_data => l4_p_stub_out_data,

-- Layer 5   

      l5_stub_in_dv => do_stub_dv(5),

      l5_stub_in_0 => do_stub_data(5)(0),
      l5_stub_in_1 => do_stub_data(5)(1),
      l5_stub_in_2 => do_stub_data(5)(2),
      l5_stub_in_3 => do_stub_data(5)(3),
      l5_stub_in_4 => do_stub_data(5)(4),
      l5_stub_in_5 => do_stub_data(5)(5),
      l5_stub_in_6 => do_stub_data(5)(6),
      l5_stub_in_7 => do_stub_data(5)(7),
      l5_stub_in_8 => do_stub_data(5)(8),
      l5_stub_in_9 => do_stub_data(5)(9),
      l5_stub_in_10 => do_stub_data(5)(10),
      l5_stub_in_11 => do_stub_data(5)(11),

      l5_stub_out_dv => fm_stub_dv(5),

      l5_stub_out_0 => fm_stub_data(0)(5),
      l5_stub_out_1 => fm_stub_data(1)(5),
      l5_stub_out_2 => fm_stub_data(2)(5),
      l5_stub_out_3 => fm_stub_data(3)(5),
   		
      l5_n_stub_in_dv => l5_n_stub_in_dv,
      l5_n_stub_in_data => l5_n_stub_in_data,
      l5_p_stub_in_dv => l5_p_stub_in_dv,
      l5_p_stub_in_data => l5_p_stub_in_data,
  
      l5_n_stub_out_dv => l5_n_stub_out_dv,
      l5_n_stub_out_data => l5_n_stub_out_data,
      l5_p_stub_out_dv => l5_p_stub_out_dv,
      l5_p_stub_out_data => l5_p_stub_out_data

	);

  GEN_SF1 : for I in 3 downto 0 generate

    GEN_SF2 : for J in NL-1 downto 0 generate
  
              begin

                sf_in(I)(J)(16 downto 0) <= fm_stub_data(I)(J);
                sf_in(I)(J)(23 downto 17) <= (others => '0');
                sf_wren(I)(J) <= fm_stub_dv(J)(I);
                sf_wrck(I)(J) <= clk160MHz;
--                sf_rden(I)(J) <= '0';
                sf_rdck(I)(J) <= clk100MHz;
                sf_rst(I)(J) <= rst;
  
                FIFO_M : FIFO_DUALCLOCK_MACRO
                  generic map (
                    DEVICE                  => "VIRTEX6",  -- Target Device: "VIRTEX5", "VIRTEX6" 
                    ALMOST_FULL_OFFSET      => X"0080",    -- Sets almost full threshold
                    ALMOST_EMPTY_OFFSET     => X"0080",    -- Sets the almost empty threshold
-- Jan 4
--                  DATA_WIDTH              => 16,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
--                  DATA_WIDTH              => 17,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
                    DATA_WIDTH              => 24,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
                    FIFO_SIZE               => "36Kb",     -- Target BRAM, "18Kb" or "36Kb" 
                    FIRST_WORD_FALL_THROUGH => false)  -- Sets the FIFO FWFT to TRUE or FALSE

                  port map (
                    ALMOSTEMPTY => sf_aempty(I)(J),  		-- Output almost empty 
                    ALMOSTFULL  => sf_afull(I)(J),   		-- Output almost full
                    DO          => sf_out(I)(J),     		-- Output data
                    EMPTY       => sf_empty(I)(J),   		-- Output empty
                    FULL        => sf_full(I)(J),    		-- Output full
                    RDCOUNT     => sf_rd_cnt(I)(J),  		-- Output read count
                    RDERR       => open,               -- Output read error
                    WRCOUNT     => sf_wr_cnt(I)(J),  		-- Output write count
                    WRERR       => open,               -- Output write error
                    DI          => sf_in(I)(J),      		-- Input data
                    RDCLK       => sf_rdck(I)(J),    		-- Input read clock
                    RDEN        => sf_rden(I)(J),    		-- Input read enable
                    RST         => sf_rst(I)(J),       -- Input reset
                    WRCLK       => sf_wrck(I)(J),    		-- Input write clock
                    WREN        => sf_wren(I)(J)       -- Input write enable
                  );

		sf_empty_b(I)(J) <= not sf_empty(I)(J);
		
    end generate GEN_SF2;

  end generate GEN_SF1;

  AMC_M : am_controller
    port map(

	    phi => phi,
	    z  => z,

      init => open,

      clk => clk100MHz,

-- From/To VME connector 

      vme_data => x4_vme_data,  -- inout
      vadd => adr, -- in
		  am => am, -- in
      geadd => ga(4 downto 0), -- in
      as_b => as, -- in
      ds0_b => ds(0), -- in
      ds1_b => ds(1), -- in
      berr_b => x4_berr_out, -- out
      iack_b => iack, -- in
      lword_b => lword, -- in
      write_b => write_b,
      dtack_b => x4_dtack,

-- From/To Stub FIFOs

      lay0_p0_in			=> sf_out(0)(0)(20 downto 0),
      lay1_p0_in			=> sf_out(0)(1)(20 downto 0),
      lay2_p0_in			=> sf_out(0)(2)(20 downto 0),
      lay3_p0_in			=> sf_out(0)(3)(20 downto 0),
      lay4_p0_in			=> sf_out(0)(4)(20 downto 0),
      lay5_p0_in   => sf_out(0)(5)(20 downto 0),
 
      p0_ef_b      => sf_empty_b(0), 
      p0_rden_b    => sf_rden(0), 

      lay0_p1_in			=> sf_out(1)(0)(20 downto 0),
      lay1_p1_in			=> sf_out(1)(1)(20 downto 0),
      lay2_p1_in			=> sf_out(1)(2)(20 downto 0),
      lay3_p1_in			=> sf_out(1)(3)(20 downto 0),
      lay4_p1_in			=> sf_out(1)(4)(20 downto 0),
      lay5_p1_in   => sf_out(1)(5)(20 downto 0),
 
      p1_ef_b      => sf_empty_b(1), 
      p1_rden_b    => sf_rden(1), 

      lay0_p2_in			=> sf_out(2)(0)(20 downto 0),
      lay1_p2_in			=> sf_out(2)(1)(20 downto 0),
      lay2_p2_in			=> sf_out(2)(2)(20 downto 0),
      lay3_p2_in			=> sf_out(2)(3)(20 downto 0),
      lay4_p2_in			=> sf_out(2)(4)(20 downto 0),
      lay5_p2_in   => sf_out(2)(5)(20 downto 0),
 
      p2_ef_b      => sf_empty_b(2), 
      p2_rden_b    => sf_rden(2), 

      lay0_p3_in			=> sf_out(3)(0)(20 downto 0),
      lay1_p3_in			=> sf_out(3)(1)(20 downto 0),
      lay2_p3_in			=> sf_out(3)(2)(20 downto 0),
      lay3_p3_in			=> sf_out(3)(3)(20 downto 0),
      lay4_p3_in			=> sf_out(3)(4)(20 downto 0),
      lay5_p3_in   => sf_out(3)(5)(20 downto 0),
 
      p3_ef_b      => sf_empty_b(3), 
      p3_rden_b    => sf_rden(3), 

-- From/To LAMB_A

      A0_HIT       	  => am_data(0)(0),
      A1_HIT       	  => am_data(0)(1),
      A2_HIT       	  => am_data(0)(2),
      A3_HIT       	  => am_data(0)(3),
      A4_HIT       	  => am_data(0)(4),
      A5_HIT       	  => am_data(0)(5),
      enA_wr			       => am_wren(0),
      init_ev0_lamb0  => am_init_ev(0)(0),
      init_ev1_lamb0  => am_init_ev(0)(1),
      init_ev2_lamb0  => am_init_ev(0)(2),
      sel0_b      		  => x4_lamb_sel(0),
      opcode0_out     => x4_lamb_opcode(0),
 		  dr0_b    			    => x4_lamb_dr_b(0),
      ladd0    		     => x4_lamb_ladd(0),
      tck_am_lamb0    => x4_lamb_tck(0),
      
-- From/To LAMB_B

      B0_HIT       	  => am_data(1)(0),
      B1_HIT       	  => am_data(1)(1),
      B2_HIT       	  => am_data(1)(2),
      B3_HIT       	  => am_data(1)(3),
      B4_HIT       	  => am_data(1)(4),
      B5_HIT       	  => am_data(1)(5),
      enB_wr			       => am_wren(1),
      init_ev0_lamb1  => am_init_ev(1)(0),
      init_ev1_lamb1  => am_init_ev(1)(1),
      init_ev2_lamb1  => am_init_ev(1)(2),
      sel1_b      		  => x4_lamb_sel(1),
      opcode1_out     => x4_lamb_opcode(1),
 		  dr1_b    			    => x4_lamb_dr_b(1),
      ladd1    		     => x4_lamb_ladd(1),
      tck_am_lamb1    => x4_lamb_tck(1),

-- From/To LAMB_C

      C0_HIT       	  => am_data(2)(0),
      C1_HIT       	  => am_data(2)(1),
      C2_HIT       	  => am_data(2)(2),
      C3_HIT       	  => am_data(2)(3),
      C4_HIT       	  => am_data(2)(4),
      C5_HIT       	  => am_data(2)(5),
      enC_wr			       => am_wren(2),
      init_ev0_lamb2  => am_init_ev(2)(0),
      init_ev1_lamb2  => am_init_ev(2)(1),
      init_ev2_lamb2  => am_init_ev(2)(2),
      sel2_b      		  => x4_lamb_sel(2),
      opcode2_out     => x4_lamb_opcode(2),
 		  dr2_b    			    => x4_lamb_dr_b(2),
      ladd2    		     => x4_lamb_ladd(2),
      tck_am_lamb2    => x4_lamb_tck(2),
 
-- From/To LAMB_D

      D0_HIT       	  => am_data(3)(0),
      D1_HIT       	  => am_data(3)(1),
      D2_HIT       	  => am_data(3)(2),
      D3_HIT       	  => am_data(3)(3),
      D4_HIT       	  => am_data(3)(4),
      D5_HIT       	  => am_data(3)(5),
      enD_wr			       => am_wren(3),
      init_ev0_lamb3  => am_init_ev(3)(0),
      init_ev1_lamb3  => am_init_ev(3)(1),
      init_ev2_lamb3  => am_init_ev(3)(2),
      sel3_b      		  => x4_lamb_sel(3),
      opcode3_out     => x4_lamb_opcode(3),
 		  dr3_b    			    => x4_lamb_dr_b(3),
      ladd3    		     => x4_lamb_ladd(3),
      tck_am_lamb3    => x4_lamb_tck(3),
 
-- Other signals

      p0_odata => x4_p0_odata,
      p1_odata => x4_p1_odata,
      p2_odata => x4_p2_odata,
      p3_odata => x4_p3_odata,
      resfifo0_b => x4_resfifo_b(0),
      resfifo1_b => x4_resfifo_b(1),
      wr_road => x4_wr_road,
      push => x4_push,
      bitmap_status => x4_bitmap_status,
      wrpam => x4_wrpam,
      rdbscan => x4_rdbscan,
      enb_b => x4_enb_b,
      dirw_b => x4_dirw_b,
      add => x4_add,
      lamb_spare => lamb_spare,
      road_end => road_end,
      rhold_b => rhold_b,
      backhold_b => backhold_b,   
      en_back => en_back,
--      back_init => x4_back_init
      back_init => rst
      
      );

  GEN_AM : for I in 3 downto 0 generate
  begin

  AM_M : am_chip

    port map (
  
      clk => clk100MHz,
      rst => rst,

      phi => phi,
      z => z,

      chip_id => I,

      opcode => "0000",
      tck => '0',
      tms => '0',
      tdi => '0',
      tdo => open,
    
      l0_hit => am_data(I)(0),
      l1_hit => am_data(I)(1),
      l2_hit => am_data(I)(2),
      l3_hit => am_data(I)(3),
      l4_hit => am_data(I)(4),
      l5_hit => am_data(I)(5),
      en_wr => am_wren(I),
      init_ev => am_init_ev(I),
      sel_b => x4_lamb_sel(I),
      dr_b => x4_lamb_dr_b(I),
	    ladd => x4_lamb_ladd(I)
	
        );
 
 end generate;


  adr(31 downto 24) <= (others => '0');        

  PMAP_file_handler_road_gen : file_handler_road_gen
    port map(
      clk => clk100MHz,
      phi => phi,
      z => z,
      eor => eor,
      p0_road_data => x4_p0_odata,
      p0_road_dv => x4_wr_road(0),
      p1_road_data => x4_p1_odata,
      p1_road_dv => x4_wr_road(1),
      p2_road_data => x4_p2_odata,
      p2_road_dv => x4_wr_road(2),
      p3_road_data => x4_p3_odata,
      p3_road_dv => x4_wr_road(3)
      );

  PMAP_file_handler : file_handler

    port map(

      clk             => clk160MHz,
      start           => start,
      vme_cmd_reg     => vme_cmd_reg,
      vme_dat_reg_in  => vme_dat_reg_in,
      vme_dat_reg_out => vme_dat_mem_in,
      vme_cmd_rd      => vme_mem_rden,
      vme_dat_wr      => vme_dat_mem_wren
      );

  vme_cmd_mem_out <= vme_cmd_reg;
  vme_dat_mem_out <= vme_dat_reg_in;

  PMAP_test_controller : test_controller

    port map(

      clk       => clk160MHz,
      rstn      => rst_b,
      sw_reset  => rst,
      tc_enable => enable,

      -- From/To SLV_MGT Module

      start     => start,
      start_res => start_res,
      stop      => stop,
      stop_res  => stop_res,
      mode      => mode,
      cmd_n     => cmd_n,
      busy      => busy,

      vme_cmd_reg     => vme_cmd_reg,
      vme_dat_reg_in  => vme_dat_reg_in,
      vme_dat_reg_out => vme_dat_reg_out,

-- To/From VME Master

      vme_cmd    => vme_cmd,
      vme_cmd_rd => vme_cmd_rd,

      vme_addr    => vme_addr(23 downto 1),
      vme_wr      => vme_wr,
      vme_wr_data => vme_wr_data,
      vme_rd      => vme_rd,
      vme_rd_data => vme_rd_data,

-- From/To VME_CMD Memory and VME_DAT Memory

      vme_mem_addr     => vme_mem_addr,
      vme_mem_rden     => vme_mem_rden,
      vme_cmd_mem_out  => vme_cmd_mem_out,
      vme_dat_mem_out  => vme_dat_mem_out,
      vme_dat_mem_wren => vme_dat_mem_wren,
      vme_dat_mem_in   => vme_dat_mem_in

      );


  PMAP_VME_Master : vme_master
    port map (

      clk      => clk160MHz,
      rstn     => rst_b,
      sw_reset => rst,

      vme_cmd     => vme_cmd,
      vme_cmd_rd  => vme_cmd_rd,
      vme_wr      => vme_cmd,
      vme_addr    => vme_addr(23 downto 1),
      vme_wr_data => vme_wr_data,
      vme_rd      => vme_rd,
      vme_rd_data => vme_rd_data,

      ga   => ga,
      addr => adr(23 downto 1),
      am   => am,

      as      => as,
      ds0     => ds(0),
      ds1     => ds(1),
      lword   => lword,
      write_b => write_b,
      iack    => iack,
      berr    => berr,
      sysfail => sysfail,
      dtack   => dtack,

      oe_b     => oe_b,
      data_in  => outdata(15 downto 0),
      data_out => indata(15 downto 0)

      );

  indata(31 downto 16) <= (others => '0');
  
  vme_d00_buf : IOBUF port map (O => outdata(0), IO => vme_data(0), I => indata(0), T => oe_b);
  vme_d01_buf : IOBUF port map (O => outdata(1), IO => vme_data(1), I => indata(1), T => oe_b);
  vme_d02_buf : IOBUF port map (O => outdata(2), IO => vme_data(2), I => indata(2), T => oe_b);
  vme_d03_buf : IOBUF port map (O => outdata(3), IO => vme_data(3), I => indata(3), T => oe_b);
  vme_d04_buf : IOBUF port map (O => outdata(4), IO => vme_data(4), I => indata(4), T => oe_b);
  vme_d05_buf : IOBUF port map (O => outdata(5), IO => vme_data(5), I => indata(5), T => oe_b);
  vme_d06_buf : IOBUF port map (O => outdata(6), IO => vme_data(6), I => indata(6), T => oe_b);
  vme_d07_buf : IOBUF port map (O => outdata(7), IO => vme_data(7), I => indata(7), T => oe_b);
  vme_d08_buf : IOBUF port map (O => outdata(8), IO => vme_data(8), I => indata(8), T => oe_b);
  vme_d09_buf : IOBUF port map (O => outdata(9), IO => vme_data(9), I => indata(9), T => oe_b);
  vme_d10_buf : IOBUF port map (O => outdata(10), IO => vme_data(10), I => indata(10), T => oe_b);
  vme_d11_buf : IOBUF port map (O => outdata(11), IO => vme_data(11), I => indata(11), T => oe_b);
  vme_d12_buf : IOBUF port map (O => outdata(12), IO => vme_data(12), I => indata(12), T => oe_b);
  vme_d13_buf : IOBUF port map (O => outdata(13), IO => vme_data(13), I => indata(13), T => oe_b);
  vme_d14_buf : IOBUF port map (O => outdata(14), IO => vme_data(14), I => indata(14), T => oe_b);
  vme_d15_buf : IOBUF port map (O => outdata(15), IO => vme_data(15), I => indata(15), T => oe_b);

  vme_d16_buf : IOBUF port map (O => outdata(16), IO => vme_data(16), I => indata(16), T => oe_b);
  vme_d17_buf : IOBUF port map (O => outdata(17), IO => vme_data(17), I => indata(17), T => oe_b);
  vme_d18_buf : IOBUF port map (O => outdata(18), IO => vme_data(18), I => indata(18), T => oe_b);
  vme_d19_buf : IOBUF port map (O => outdata(19), IO => vme_data(19), I => indata(19), T => oe_b);
  vme_d20_buf : IOBUF port map (O => outdata(20), IO => vme_data(20), I => indata(20), T => oe_b);
  vme_d21_buf : IOBUF port map (O => outdata(21), IO => vme_data(21), I => indata(21), T => oe_b);
  vme_d22_buf : IOBUF port map (O => outdata(22), IO => vme_data(22), I => indata(22), T => oe_b);
  vme_d23_buf : IOBUF port map (O => outdata(23), IO => vme_data(23), I => indata(23), T => oe_b);
  vme_d24_buf : IOBUF port map (O => outdata(24), IO => vme_data(24), I => indata(24), T => oe_b);
  vme_d25_buf : IOBUF port map (O => outdata(25), IO => vme_data(25), I => indata(25), T => oe_b);
  vme_d26_buf : IOBUF port map (O => outdata(26), IO => vme_data(26), I => indata(26), T => oe_b);
  vme_d27_buf : IOBUF port map (O => outdata(27), IO => vme_data(27), I => indata(27), T => oe_b);
  vme_d28_buf : IOBUF port map (O => outdata(28), IO => vme_data(28), I => indata(28), T => oe_b);
  vme_d29_buf : IOBUF port map (O => outdata(29), IO => vme_data(29), I => indata(29), T => oe_b);
  vme_d30_buf : IOBUF port map (O => outdata(30), IO => vme_data(30), I => indata(30), T => oe_b);
  vme_d31_buf : IOBUF port map (O => outdata(31), IO => vme_data(31), I => indata(31), T => oe_b);
 
end slice_arch;
