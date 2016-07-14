module Audio (input clk,input reset, input Hit_wall , Hit_ground ,Hit_plate,Data_request , output reg Data_ready , output reg [3:0] sound_code);
  reg beginwall;
  reg beginground;
  reg beginplate;
  reg [1:0] soundmark;
  reg [3:0] hitplate [2:0];
  reg [3:0] hitground [2:0];
  reg [3:0] hitwall [2:0];
  
    always @(posedge clk)
    begin
          if(reset==1)
          begin
            beginwall=0;
            beginground=0;
            beginplate=0;
            soundmark=0;
            hitground[0]=4'b0111;
            hitground[1]=4'b0101;
            hitground[2]=4'b0001;
            hitplate[0]=4'b0011;
            hitplate[1]=4'b0110;
            hitplate[2]=4'b0010;
            hitwall[0]=4'b0111;
            hitwall[1]=4'b0110;
            hitwall[2]=4'b0101;
            
          end
        else    
          begin
            
        if(soundmark==4)
        begin
          beginground=0;
          beginwall=0;
          beginplate=0;
          soundmark=0;
        end
          if(Hit_ground==1)
              begin
              beginground=1;
              beginwall=0;
              end
          if(Hit_plate==1)
              begin
              beginplate=1;
              beginwall=0;
              end
          if(Hit_wall==1)
              begin
              beginwall=1;
              beginplate=0;
              end
                
      if(Data_request==1)
      begin
          if(beginground==1&&Data_ready==0)
          begin
              sound_code=hitground[soundmark];
              soundmark=soundmark+1;
              Data_ready=1;
          end
          if(beginwall==1)
          begin
              sound_code=hitwall[soundmark];
              soundmark=soundmark+1;
              Data_ready=1;
          end
          if(beginplate==1)
          begin
              sound_code=hitplate[soundmark];
              soundmark=soundmark+1;
              Data_ready=1;
          end
      end
      else
        Data_ready=0;
  end
        
    end
endmodule

