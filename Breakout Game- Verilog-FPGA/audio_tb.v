module audio_tb  ; 
 
  reg    Hit_wall   ; 
  wire    Data_ready   ; 
  reg    Data_request   ; 
  reg    Hit_plate   ; 
  reg    clk   ; 
  wire  [3:0]  sound_code   ; 
  reg    Hit_ground   ; 
  reg    reset   ; 
  audio  
   DUT  ( 
       .Hit_wall (Hit_wall ) ,
      .Data_ready (Data_ready ) ,
      .Data_request (Data_request ) ,
      .Hit_plate (Hit_plate ) ,
      .clk (clk ) ,
      .sound_code (sound_code ) ,
      .Hit_ground (Hit_ground ) ,
      .reset (reset ) ); 
    always #1
    begin
    clk=~clk;
    end
    always @(posedge clk)
    begin
      if(Data_ready==1)
        begin
          #5
          Data_request=0;
        end
      if(Data_ready==0)
        begin
          #2
          Data_request=1;
        end
    end
    initial 
    begin
      clk=0;
      reset=1;
      #5
      reset=0;
      #5
      Hit_wall=1;
      #2
      Hit_wall=0;
      #10
      
      Hit_plate=1;
      #2
      Hit_plate=0;
      #20
      Hit_ground=1;
      #2 
      Hit_ground=0;
  end  

endmodule

