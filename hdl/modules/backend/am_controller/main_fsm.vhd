library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity main_fsm is
    Port ( clk : 			in  STD_LOGIC;		
           init : 		in  STD_LOGIC;
           pok : 			in  STD_LOGIC_VECTOR (5 downto 0);		--hit ready in the input FF
           dr : 			in  STD_LOGIC;									--road ready in the FIFO
			  rhold : 		in  STD_LOGIC;									--hold of road from next board
			  hee_reg : 	in  STD_LOGIC_VECTOR (5 downto 0);		--end event of hit register
			  
			  finish_road :   in  STD_LOGIC;								--no roads from LAMB
			  rd_fifo : 		in  STD_LOGIC_VECTOR (5 downto 0);	
			  
			  need_opc_data : in STD_LOGIC;
			  addr_wr_opc : 	in STD_LOGIC_VECTOR (4 downto 0);
			  addr_rd_opc : 	buffer STD_LOGIC_VECTOR (4 downto 0);
			  rd_opc_ram : 	buffer STD_LOGIC;
			  
			  curr_state : 	buffer  STD_LOGIC_VECTOR (2 downto 0);	
			  last_hreg_ee : 	buffer  STD_LOGIC;						--ANDed of end event of hit
			  
			  init_iam : 		out  STD_LOGIC;							--inizialize Associative Memory
   
           rpush : 			out  STD_LOGIC;							--push out the road
			  sel_IAM : 		out  STD_LOGIC;							--select road or word of end event
           en : 				out  STD_LOGIC_VECTOR (5 downto 0);	--enable register before the LAMB
           pop : 				out  STD_LOGIC_VECTOR (5 downto 0);	--request a hit in input
			 
			  count_patt : 	out  STD_LOGIC_VECTOR (31 downto 0);
			  count_event : 	out  STD_LOGIC_VECTOR (31 downto 0);
			  init_stat_count : in  STD_LOGIC
			  
			 );
			 
end main_fsm;

architecture main_fsm_architecture of main_fsm is

	--define a codify for the state of the machine
	subtype state is std_logic_vector(2 downto 0);
	constant reset : state := "000";
	constant receive_hit : state := "001";
	constant wait_t0 : state := "010";
	constant send_road : state := "011";
	constant read_opcode : state := "100"; 	
	constant send_opcode : state := "101";
	constant wait_t1 : state := "110";
	constant send_init_event : state := "111";
	
	signal init_ok: STD_LOGIC;
	
	signal no_roads: STD_LOGIC;
	signal next_state: state;
	
	signal send_new_opc : STD_LOGIC;
	
	--signal of hold road
--	signal rholdreg_n: STD_LOGIC;
--	signal irhold_n: STD_LOGIC;
	
	--signal of to generate the signal of data valid for test
	signal rd_fifo_d1: STD_LOGIC_VECTOR (5 downto 0); 
	signal tmode_lamb_dv: STD_LOGIC_VECTOR (5 downto 0);

	--conter for the number of event and pattern
	signal count_patt_sig : STD_LOGIC_VECTOR (31 downto 0);
	signal count_event_sig : STD_LOGIC_VECTOR (31 downto 0);
	
	--signal for state wait_t0
	signal count_t0 : STD_LOGIC_VECTOR (4 downto 0);
	--constant COUNTER_MAX_T0 : STD_LOGIC_VECTOR (4 downto 0) := "10010";  
	constant COUNTER_MAX_T0 : STD_LOGIC_VECTOR (4 downto 0) := "10011";  
	
	--signal for state wait_t1
	signal count_t1 : STD_LOGIC_VECTOR (4 downto 0);
	--constant COUNTER_MAX_T1 : STD_LOGIC_VECTOR (4 downto 0) := "10011";  
	--constant COUNTER_MAX_T1 : STD_LOGIC_VECTOR (4 downto 0) := "10101";  
	constant COUNTER_MAX_T1 : STD_LOGIC_VECTOR (4 downto 0) := "10110";  
	
begin
	
	--counter for the pattern in output
	count_patt_proc:process (clk) 
	begin
		if (clk='1' and clk'event) then
			if (init='1' or init_stat_count = '1') then 
				count_patt_sig <= (others => '0');
			elsif (dr = '1') then
				count_patt_sig <= count_patt_sig + 1;
			end if;
		end if;
	end process; 
			
	--counter for the number of hit in input
	count_event_proc:process (clk) 
	begin
		if (clk='1' and clk'event) then
			if (init='1' or init_stat_count = '1') then 
				count_event_sig <= (others => '0');
			elsif (curr_state = send_init_event) then
				count_event_sig <= count_event_sig + 1;
			end if;
		end if;
	end process; 
	
	count_patt <= count_patt_sig;
	count_event <= count_event_sig;
	
	--there is no road if the data ready and the one cycle data ready delay is de-assert
	no_roads <= finish_road;
	
	--Reset of the register before the LAMB
	init_iam <= init_ok or init;
		
	--AND to all register ee
   last_hreg_ee <= hee_reg(0) and hee_reg(1) and hee_reg(2) and hee_reg(3) and hee_reg(4) and hee_reg(5);
  				
	--Signal to generate the tmode_lamb_dv 	
	process (clk, init)
	begin
		if (init = '1') then
			rd_fifo_d1 <= (others => '0');
			tmode_lamb_dv <= (others => '0'); 
		elsif(clk'event and clk = '1') then
			rd_fifo_d1 <= rd_fifo;
			tmode_lamb_dv <= rd_fifo_d1; 
	   end if;
	end process;
	
	--define the counter for the state_t0
	count_proc_t0: process(clk, init_ok, init)
	begin
		if(init = '1' or init_ok = '1') then
			count_t0 <= COUNTER_MAX_T0;
		elsif(clk'event and clk = '1') then
			if(curr_state = wait_t0) then
				count_t0 <= count_t0 - 1;
			end if;
		end if;
	end process;
	
	--define the counter for the state_t1 prova per l'init event
	count_proc_t1: process(clk, init, curr_state)
	begin
		if(init = '1' or (curr_state = send_init_event or curr_state = send_road)) then
			count_t1 <= COUNTER_MAX_T1;
		elsif(clk'event and clk = '1') then
			if(curr_state = wait_t1) then
				count_t1 <= count_t1 - 1;
			end if;
		end if;
	end process;
	
	--insert the counter to increment the RAM address to read opcode
	--the counter is reset when there is an init event
	rd_opc_addr_proc: process(clk, init, init_ok)
	begin
		if(init = '1' or init_ok = '1') then
			addr_rd_opc <= (others => '0');
		elsif(clk'event and clk = '1') then
			if(rd_opc_ram = '1') then
				addr_rd_opc <= addr_rd_opc + 1;
			end if;
		end if;
	end process;
	
	--control if the write and read address is egual
	send_new_opc <= '0' when (addr_rd_opc = addr_wr_opc) else '1';
	
	--sequential process that update the present state
	sequential_process: process(clk, init)
	begin
		if(clk'event and clk='1') then
			if(init='1') then
				curr_state <= reset;
			else
				curr_state <= next_state;
			end if;
		end if;
	end process sequential_process;
	
	--combinatory process
	combinatory_process: process(curr_state, send_new_opc, need_opc_data, count_t0, count_t1, pok, dr, init, rhold, no_roads, last_hreg_ee, hee_reg, tmode_lamb_dv)
	begin
		case curr_state is
			when reset =>
				--State of reset the AMboard and the Associative Memory. 
				
				pop <= "000000";		--do not ask input hit
	    	
				sel_IAM <= '0';     --select the road
	   
				rpush <= '0';			--do not push out the road
	   
				en <= "000000";		--disable the register before the LAMB
				
				init_ok <= '0'; 		--init event to the board
				
				rd_opc_ram <= '0';	--disable the read opcode from RAM
				
				if(init='1') then
					next_state <=  curr_state;
				else 
					next_state <=  receive_hit;
				end if;
	   
			when receive_hit =>
				--Reading the hit from the input buses and control the end event of hit
				--Enable to send out the roads
				
				--write the register before the LAMB is enable if there is the pok (hit is avaible on the register) 
				--the register is disable if there is the ee on the register in input (hee_reg=1).
				en(0) <=  (not hee_reg(0)) and (pok(0) or tmode_lamb_dv(0));	
				en(1) <=  (not hee_reg(1)) and (pok(1) or tmode_lamb_dv(1));	
				en(2) <=  (not hee_reg(2)) and (pok(2) or tmode_lamb_dv(2));	
				en(3) <=  (not hee_reg(3)) and (pok(3) or tmode_lamb_dv(3));	
				en(4) <=  (not hee_reg(4)) and (pok(4) or tmode_lamb_dv(4));	
				en(5) <=  (not hee_reg(5)) and (pok(5) or tmode_lamb_dv(5));	
				   
				--the pop is always enable because we want to register also the word of ee 
				pop(0) <= (not hee_reg(0));
				pop(1) <= (not hee_reg(1));
				pop(2) <= (not hee_reg(2));
				pop(3) <= (not hee_reg(3));
				pop(4) <= (not hee_reg(4));
				pop(5) <= (not hee_reg(5));    
		 
				rpush <= dr;		--enable the register to send out the road to P3

				sel_IAM <= '1';	--select the road from the LAMB
				
				init_ok <= '0'; 	--init event to the board
				
				rd_opc_ram <= '0';	--disable the read opcode from RAM
				
				if (init='1') then
						next_state <= reset;
				elsif (last_hreg_ee='1') then
						--whene there is the EndEvent from all buses jump in the state WAIT T0
						next_state <= wait_t0;
				else 
						next_state <= curr_state;
				end if;
				
	
			when wait_t0 =>
				--Wait 18 cycle of clock to permit at the last road of the AMchips
				--to be in the glue chip
				
				en <= "000000"; 		--disable the register before the LAMB (the ee do not send to the LAMB)
	   
				pop <= "000000";		--disable the register in input. do not ask hit of new event
	   	  
				sel_IAM <= '1';		--select the road
				
				rpush <=  dr; 			--enable the register send out the road if there is the data ready
				
				init_ok <= '0'; 		--init event to the board
				
				rd_opc_ram <= '0';	--disable the read opcode from RAM

				if (init = '1') then
					next_state <= reset;
				elsif (count_t0 = "00000") then
					next_state <= send_road;						
				else 
					next_state <= curr_state;
				end if;

			when send_road =>
				--Send out the road. We control when the road are finish.
				
				en <= "000000"; 		--disable the register before the LAMB (the ee do not send to the LAMB)
	   
				pop <= "000000";		--disable the register in input. do not ask hit of new event
	   	  
				sel_IAM <= '1';		--select the road
		 	
				rpush <=  dr; 			--enable the register send out the road if there is the data ready
				
				init_ok <= '0'; 		--init event to the board
				
				rd_opc_ram <= '0';	--disable the read opcode from RAM
		
				if (init='1') then
					next_state <=  reset;
				--elsif (no_roads = '1' and rhold = '0') then 
				elsif (no_roads = '1' and rhold = '0' and send_new_opc = '0') then 
					--when there is no road jump to the state that send the init event 
					next_state <=  send_init_event;
				elsif (no_roads = '1' and rhold = '0' and send_new_opc = '1') then 
					next_state <= read_opcode;
				else 
					next_state <=  curr_state;  
				end if;
				

			when read_opcode =>
				--Read the opcode from the RAM
				en <= "000000"; 		--disable the register before the LAMB (the ee do not send to the LAMB)
	   
				pop <= "000000";		--disable the register in input. do not ask hit of new event
	   	  
				sel_IAM <= '1';		--select the road
				
				rpush <=  '0'; 		--disable the register send out the road if there is the data ready
				
				init_ok <= '0'; 		--init event to the board
				
				rd_opc_ram <= '1';		--enable the read opcode from RAM
				
				--devo incrementare l'indirizzo di lettura
				
				--faccio la transizione sullo stato send opcode
				if(init = '1') then
					next_state <= reset;
				else
					next_state <= send_opcode;
				end if;
				
			when send_opcode =>
				--Send opcode to LAMB and control if is a one or two word.
				en <= "000000"; 		--disable the register before the LAMB (the ee do not send to the LAMB)
	   
				pop <= "000000";		--disable the register in input. do not ask hit of new event
	   	  
				sel_IAM <= '1';		--select the road
				
				rpush <=  '0'; 		--disable the register send out the road if there is the data ready
				
				init_ok <= '0'; 		--init event to the board
				
				rd_opc_ram <= need_opc_data;		--enable the read new data is the opcode is composted by two words
				
				if(init = '1') then
					next_state <= reset;
				elsif(need_opc_data = '0') then
					next_state <= wait_t1;
				else
					next_state <= curr_state;
				end if;
				
			when wait_t1 =>
				--Wait 18 cycle of clock to permit at the last road of the AMchips
				--to be in the glue chip
				
				en <= "000000"; 		--disable the register before the LAMB (the ee do not send to the LAMB)
	   
				pop <= "000000";		--disable the register in input. do not ask hit of new event
	   	  
				sel_IAM <= '1';		--select the road
				
				rpush <=  '0'; 		--disable the register send out the road if there is the data ready
				
				init_ok <= '0'; 		--init event to the board
				
				rd_opc_ram <= '0';	--disable the read opcode from RAM

				if (init = '1') then
					next_state <= reset;
				elsif (count_t1 = "00000") then
					next_state <= send_road;						
				else 
					next_state <= curr_state;
				end if;		
			
			when send_init_event =>
				--Send out the word of ee of the road. Inizialize the associative memory
		
				en <= "000000"; 		--disable the register before the LAMB (the ee do not send to the LAMB)
	   
				pop <= "000000";		--disable the register in input. do not ask hit of new event	
	 		
				sel_IAM <= '0';		--select the word of ee
		 
				rpush <= '1';			--send out only the ee of the road 
				
				init_ok <= '1'; 		--init event to the board
				
				rd_opc_ram <= '0';	--disable the read opcode from RAM
	     
				--only one need of clock to send out the word of ee
				if(init = '1') then
					next_state <= reset;
				else
					next_state <= receive_hit;
				end if;
			
			when others =>
				--State that consider all condition of the value of signal 
				--in std_logic 
				
				pop <= "000000";		--do not ask input hit
	 	
				sel_IAM <= '0';     --select the road
	   
				rpush <= '0';			--do not push out the road
	   
				en <= "000000";		--disable the register before the LAMB
				
				init_ok <= '0'; 		--init event to the board
				
				rd_opc_ram <= '0';	--disable the read opcode from RAM
				
				if(init='1') then
					next_state <=  reset;
				else 
					next_state <=  curr_state;  
				end if;
				
		end case;
		
	end process combinatory_process;

end main_fsm_architecture;

