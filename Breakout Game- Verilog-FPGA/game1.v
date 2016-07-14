module game1(output reg [15:0] point_bcd ,output reg  SOUND_END , SOUND_WALL ,SOUND_PLATE , output reg [7:0] TIME_SEC , TIME_MIN,output reg [2:0]GAME_LVL ,output reg  [7:0] ball_x , plate_x , output  reg [6:0] ball_y , plate_y ,output reg [5:0] ball_size,plate_size, input right , left,reset , clk);
	reg clk_ball , clk_plate;
	integer i = 0;
	integer j = 0;
	integer TIME = 0;
	integer TIME_WHOLE_SEC;
	integer point;
	integer temp;
	integer z; 
	integer time_min_integer;
	integer time_sec_integer;
	reg TIME_FLAG = 0;
	reg[ 7:0] test;
	reg END;
	integer plate_speed  ;
	integer ball_x_speed ;
	integer ball_y_speed ;
	integer ball_clk_speed;
	//game parameters
	parameter change_lvl_time = 8;
	parameter MAX_LVL = 9;
	// plate parameters
	parameter plate_height = 15;
	parameter initial_plate_size = 40;
	parameter initial_plate_x = 20;
	parameter initial_plate_speed =1;
	parameter plate_level_reduction = 5;
	parameter plate_clk_speed = 500000;	
	parameter min_plate_size = 15;
	// hardware specs params
	parameter clk_freq= 50000000  ;
	// resolution and margins params
	parameter width_begin = 0 ;
	parameter width_end = 160;
	parameter signed height_begin = 0;
	parameter height_end = 120;
  // ball_params
  parameter initial_ball_clk_speed = 400000;
	parameter initial_ball_x = 18;
	parameter initial_ball_y = 20;
	parameter initial_ball_speed_x = 0;
	parameter initial_ball_speed_y = -1;
	parameter initial_ball_size =7 ;
	
	
	 function automatic [15:0] bin_BCD(input integer   a);
	integer k;
	integer h;
	integer flag;
	begin
	k = a;
	flag = 0;
	for(h =0 ; h<9 & flag == 0 ; h = h+1)begin
		if(k<1000)
			flag = 1;
			else
		k= k- 1000;
	end 
	if(flag == 1)
		h = h-1;
	flag = 0;
	bin_BCD[15:12] = h;
	for(h =0 ; h<9 & flag ==0 ; h = h+1)begin
		if(k<100)
			flag = 1;
			else
		k= k- 100;
	end 
	if(flag == 1)
		h = h-1;
	flag = 0;
	bin_BCD[11:8] = h;
	for(h =0 ; h<9 & flag == 0 ; h = h+1)begin
		if(k<10)
			flag = 1;
			else
		k= k- 10;
	end 
	if(flag == 1)
		h = h-1;
	flag = 0;
	bin_BCD[7:4] = h;
	bin_BCD[3:0] = k;
	
	end
	endfunction
	function integer  inc_speed(input integer speed);begin
	if(speed >50000)
		inc_speed = speed-30000 ;
		else begin
		
		
		
		    inc_speed = speed -5000;
		end
	end
	endfunction
	function integer abs_speed(input integer speed);begin
	if(speed >=0)
		abs_speed = speed ;
		else
		abs_speed = -speed;
	end
	endfunction
	function hit (input [7:0] ballx1 , ballx2 , platex1 , platex2);begin
		if((ballx1>= platex1 & ballx1 <=platex2) | (ballx2>=platex1 & ballx2 <= platex2))
			hit = 1;
			else
			hit  = 0;
	end
	endfunction
	always @(posedge clk)begin
		if(reset ==1)begin
		    TIME = 0;
		    TIME_SEC = 0;
		    TIME_MIN = 0;
		    time_sec_integer = 0;
		    time_min_integer = 0;
		    plate_y = height_end - plate_height;
		    TIME_WHOLE_SEC = 0;
		    plate_speed = initial_plate_speed;
		    GAME_LVL = 0;
		    point = 0;
		    point_bcd = 0;
		    clk_ball = 0;
		    clk_plate = 0;
		    i =0;
		    j=0;
		    ball_size = initial_ball_size;
        	test = 0 ; //        teeeeeeeeeeeeeeesssssssssssssssssttttttttttttt	    
		    
		    
		    
		  end
		  else begin
		test = test +1;
		test = test +1 ;
		test = test +1;
		if(i==ball_clk_speed)begin
			i = 0;
			clk_ball = ~clk_ball;
		end
		if(j== plate_clk_speed)begin
			j =0 ;
			clk_plate = ~ clk_plate;
			end
		if(TIME == clk_freq)begin
		  if(time_sec_integer == 59)begin
		    time_sec_integer = 0;
		    TIME_SEC  = bin_BCD(time_sec_integer);
		    time_min_integer = time_min_integer+1;
		    TIME_MIN = bin_BCD(time_min_integer);
		    end
		    else begin
			time_sec_integer = time_sec_integer + 1;
			TIME_SEC = bin_BCD(time_sec_integer);
			point = point + GAME_LVL + 1;
			end
			temp = point;
			point_bcd = bin_BCD(temp);
			TIME_WHOLE_SEC = TIME_WHOLE_SEC +1 ;
			if(TIME_WHOLE_SEC % change_lvl_time == 0 & TIME_WHOLE_SEC != 0)begin
			  if( plate_size != min_plate_size)
			    if(GAME_LVL <= MAX_LVL)
			  GAME_LVL = GAME_LVL + 1;
			  end
			TIME = 0;
		end
			i = i+1;
			j = j+1;
			TIME = TIME +1;
			end
		end
	always @(posedge clk_ball or posedge reset)begin
		
	if(reset == 1)begin
	      ball_x_speed = initial_ball_speed_x;
		    ball_y_speed = initial_ball_speed_y;
		    ball_x = initial_ball_x;
		    ball_y = initial_ball_y;
		    plate_size = initial_plate_size;
		    TIME_FLAG = 0;
		    END = 0;
		    ball_clk_speed = initial_ball_clk_speed;
		    
	  end
	  else begin
	  if(END != 0) begin
	if(  TIME_WHOLE_SEC != 0 &  TIME_WHOLE_SEC % change_lvl_time ==0 & TIME_FLAG == 0 )begin
	 if(GAME_LVL <= MAX_LVL & plate_size != min_plate_size)begin
		if(plate_size > plate_level_reduction + min_plate_size)begin
		  plate_size = plate_size - plate_level_reduction;
		  end
		  else 
		    plate_size = min_plate_size;
		 
		ball_clk_speed = inc_speed(ball_clk_speed);
		 
		
		TIME_FLAG = 1;
		end
	end
		else begin
		if(TIME_WHOLE_SEC %change_lvl_time != 0)begin
		TIME_FLAG = 0;
	end
	end
		temp = ball_x;
	    if(temp > width_end - ball_x_speed -ball_size| temp < width_begin- ball_x_speed )begin
	     if(temp  >width_end- ball_x_speed - ball_size)
	       ball_x = width_end - ball_size;
	       else
	         ball_x = width_begin;
	    end
	    else
		ball_x = ball_x + ball_x_speed;
		temp = ball_y;
		if(temp < height_begin  - ball_y_speed | temp  > height_end- ball_y_speed - ball_size)begin
		    if(temp  <  - ball_y_speed + height_begin)begin
		      ball_y  = height_begin;
		        
		        
		       end
		        else
		          ball_y = height_end - ball_size;
		  end
		  else
		ball_y = ball_y + ball_y_speed;
		if(ball_x <= width_begin | ball_x +ball_size>= width_end)begin // hits left and right side of screen
		SOUND_WALL = 1;
		if(ball_x <= width_begin)
		  ball_x_speed = abs_speed(ball_x_speed);
		else
		  ball_x_speed = -abs_speed(ball_x_speed);
		$display(ball_x_speed);
		end
		else
			SOUND_WALL = 0;
		
	
		if(ball_y >= height_end-plate_height-ball_size  )begin   // if hits the plate
		
			if(hit(ball_x , ball_x+ball_size , plate_x , plate_x + plate_size)==1)begin
				ball_y_speed = -abs_speed( ball_y_speed);
				SOUND_PLATE = 1;
				end
	end
		else
		SOUND_PLATE = 0;
		if(ball_y <= height_begin)begin // if hits the sky
		SOUND_WALL = 1;
			ball_y_speed = abs_speed(ball_y_speed);
		end
		if(ball_y + ball_size >= height_end)begin //if hits the ground
		  SOUND_END = 1;
		  ball_y_speed = 0;
		  ball_x_speed = 0;
		  END = 1;
		  end
		  else begin
			SOUND_END =0 ;
			
			end
	end
		else begin
		SOUND_END = 0;
	end
	end
end
	always @(posedge clk_plate or posedge reset)begin
	  if(reset ==1 ) begin
	    plate_x = initial_plate_x;
	    end
	    else begin
		if(right ==1)begin
		if(plate_x  < width_end - plate_size)begin
		  if(plate_x + plate_size + plate_speed > width_end)
				plate_x = width_end - plate_size;
				else
			plate_x = plate_x + plate_speed;
			
		end
		
	end
		if(left == 1)begin
			if(plate_x > width_begin )begin
				if(plate_x > plate_speed)
				plate_x = plate_x - plate_speed;
				else
				plate_x = width_begin;
				
				
			end
		end
		end
	end
	
	
endmodule