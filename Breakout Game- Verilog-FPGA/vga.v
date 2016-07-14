module vga(input reset,input [2:0] level, input [7:0] min , input [7:0] sec, input [15:0] gamepoint,input [7:0] ballx,platex,input [6:0] bally,platey,input [5:0] ballsize,platesize,input clk,output reg [7:0] x,output reg [6:0] y,output reg plot,output reg [2:0] color);
reg startrepaint;
reg [7:0] painterlocx;
reg [6:0] painterlocy;
reg repaintdone;
reg [7:0] lastballx,lastplatex;
reg [6:0] lastbally,lastplatey;
reg [6:0] sevenseg [8:0];



function m (input [3:0] seseg,input [7:0] x,sx, input [6:0] y,sy);
  
  begin
  
    m=0;
    if(sevenseg[seseg][0]==1)
      begin
        if(sx<=x&x<=sx+5& y==sy)
          m=1;
        
          
      end
      
      if(sevenseg[seseg][1]==1)
      begin
        if(sx+5==x&y<=sy+5& y>=sy)
          m=1;
          
      end
      if(sevenseg[seseg][2]==1)
      begin
        if(sx==x&y<=sy+5& y>=sy)
          m=1;
          
      end
      if(sevenseg[seseg][3]==1)
      begin
        if(sx<=x&x<sx+5& y==sy+5)
          m=1;
          
      end
      if(sevenseg[seseg][4]==1)
      begin
        if(sx+5==x&y<=sy+10& y>=sy+5)
          m=1;
          
      end
      if(sevenseg[seseg][5]==1)
      begin
        if(sx<=x&x<sx+5& y==sy+10)
          m=1;
          
      end
      if(sevenseg[seseg][6]==1)
      begin
        if(sx==x&y<=sy+10& y>=sy+5)
          m=1;
          
      end
    end
  endfunction
always @(posedge clk)
begin
  if(reset==1)
  begin
    lastballx=0;
    lastbally=0;
    lastplatex=0;
    lastplatey=0;
    plot=0;
    startrepaint=0;
    repaintdone=1;
    painterlocx=0;
    painterlocy=0;
  end  
else
  begin
  case (min[7:4])
    4'd0:sevenseg[0]=119;
    4'd1:sevenseg[0]=18;
    4'd2:sevenseg[0]=107;
    4'd3:sevenseg[0]=59;
    4'd4:sevenseg[0]=30;
    4'd5:sevenseg[0]=61;
    4'd6:sevenseg[0]=124;
    4'd7:sevenseg[0]=19;
    4'd8:sevenseg[0]=127;
    4'd9:sevenseg[0]=63;
  endcase
  case (min[3:0])
    4'd0:sevenseg[1]=119;
    4'd1:sevenseg[1]=18;
    4'd2:sevenseg[1]=107;
    4'd3:sevenseg[1]=59;
    4'd4:sevenseg[1]=30;
    4'd5:sevenseg[1]=61;
    4'd6:sevenseg[1]=124;
    4'd7:sevenseg[1]=19;
    4'd8:sevenseg[1]=127;
    4'd9:sevenseg[1]=63;
  endcase
  case (sec[7:4])
    4'd0:sevenseg[2]=119;
    4'd1:sevenseg[2]=18;
    4'd2:sevenseg[2]=107;
    4'd3:sevenseg[2]=59;
    4'd4:sevenseg[2]=30;
    4'd5:sevenseg[2]=61;
    4'd6:sevenseg[2]=124;
    4'd7:sevenseg[2]=19;
    4'd8:sevenseg[2]=127;
    4'd9:sevenseg[2]=63;
  endcase
  case (sec[3:0])
    4'd0:sevenseg[3]=119;
    4'd1:sevenseg[3]=18;
    4'd2:sevenseg[3]=107;
    4'd3:sevenseg[3]=59;
    4'd4:sevenseg[3]=30;
    4'd5:sevenseg[3]=61;
    4'd6:sevenseg[3]=124;
    4'd7:sevenseg[3]=19;
    4'd8:sevenseg[3]=127;
    4'd9:sevenseg[3]=63;
  endcase
  case (level[2:0])
    3'd0:sevenseg[4]=119;
    3'd1:sevenseg[4]=18;
    3'd2:sevenseg[4]=107;
    3'd3:sevenseg[4]=59;
    3'd4:sevenseg[4]=30;
    3'd5:sevenseg[4]=61;
    3'd6:sevenseg[4]=124;
    3'd7:sevenseg[4]=19;
  endcase
  case (gamepoint[15:12])
    4'd0:sevenseg[5]=119;
    4'd1:sevenseg[5]=18;
    4'd2:sevenseg[5]=107;
    4'd3:sevenseg[5]=59;
    4'd4:sevenseg[5]=30;
    4'd5:sevenseg[5]=61;
    4'd6:sevenseg[5]=124;
    4'd7:sevenseg[5]=19;
    4'd8:sevenseg[5]=127;
    4'd9:sevenseg[5]=63;
  endcase
  case (gamepoint[11:8])
    4'd0:sevenseg[6]=119;
    4'd1:sevenseg[6]=18;
    4'd2:sevenseg[6]=107;
    4'd3:sevenseg[6]=59;
    4'd4:sevenseg[6]=30;
    4'd5:sevenseg[6]=61;
    4'd6:sevenseg[6]=124;
    4'd7:sevenseg[6]=19;
    4'd8:sevenseg[6]=127;
    4'd9:sevenseg[6]=63;
  endcase
  
  case (gamepoint[7:4])
    4'd0:sevenseg[7]=119;
    4'd1:sevenseg[7]=18;
    4'd2:sevenseg[7]=107;
    4'd3:sevenseg[7]=59;
    4'd4:sevenseg[7]=30;
    4'd5:sevenseg[7]=61;
    4'd6:sevenseg[7]=124;
    4'd7:sevenseg[7]=19;
    4'd8:sevenseg[7]=127;
    4'd9:sevenseg[7]=63;
  endcase
  
  case (gamepoint[3:0])
    4'd0:sevenseg[8]=119;
    4'd1:sevenseg[8]=18;
    4'd2:sevenseg[8]=107;
    4'd3:sevenseg[8]=59;
    4'd4:sevenseg[8]=30;
    4'd5:sevenseg[8]=61;
    4'd6:sevenseg[8]=124;
    4'd7:sevenseg[8]=19;
    4'd8:sevenseg[8]=127;
    4'd9:sevenseg[8]=63;
  endcase
  if(ballx!=lastballx || platex!=lastplatex || bally!=lastbally || platey!=lastplatey)
    begin
		  plot=1;
		  startrepaint=1;
		  repaintdone=0;
    		painterlocx=0;painterlocy=0;
		  lastballx=ballx ; lastplatex=platex ; lastbally=lastbally ; lastplatey=platey;
    end
    
	if(startrepaint==1)
	begin
		
		
		x=painterlocx;
		y=painterlocy;
		
		if(painterlocx>=ballx&painterlocx<=ballx+ballsize&painterlocy>=bally&painterlocy<=bally+ballsize)
			color=0;
		else
		begin
			if(painterlocx>=platex&painterlocx<=platex+platesize&painterlocy>=105)
			color=3'b110;
			else
			color=3'b111;
		end
		
		  if(m(0,painterlocx,125, painterlocy,8)==1)
		    color=3'b000;
		    
		  if(m(1,painterlocx,132, painterlocy,8)==1)
		    color=3'b000;
		  if(m(2,painterlocx,143, painterlocy,8)==1)
		    color=3'b000;
		  if(m(3,painterlocx,150, painterlocy,8)==1)
		    color=3'b000;
		  if(m(4,painterlocx,135, painterlocy,50)==1)
		    color=3'b000;
		  if(m(5,painterlocx,125, painterlocy,80)==1)
		    color=3'b000;
		  if(m(6,painterlocx,132, painterlocy,80)==1)
		    color=3'b000;
  		  if(m(7,painterlocx,143, painterlocy,80)==1)
		    color=3'b000;

		  if(m(8,painterlocx,150, painterlocy,80)==1)
		    color=3'b000;
		  
	
		  
		
		if(painterlocx==121)
		  color=3'b0;
		if(painterlocx>=137&painterlocx<=139&painterlocy>=10&painterlocy<=12)
		  color=3'b0;
		if(painterlocx>=137&painterlocx<=139&painterlocy>=14&painterlocy<=16)
		  color =3'b0;
		
		        
		
		
		if(painterlocx==8'd160)
			begin
			  if(painterlocy==7'd120)
			    begin
			       startrepaint=0;
				     repaintdone=1;
				     plot=0;
				     painterlocy=0;
				     painterlocx=0;
				  end
				else
				  begin
			       
			       painterlocy=painterlocy+1;
			       painterlocx=0;
			       
			    end
			 end
		else
			 begin
			 painterlocx=painterlocx+1;
			 end
			end
	 end
	 	
		
		
	
	
	
end

	
endmodule
