module vgapros_tb2  ; 

parameter seg0y  = 8 ;
parameter seg27x  = 143 ;
parameter seg05x  = 125 ;
parameter seg1y  = 50 ;
parameter seg2y  = 80 ;
parameter seg38x  = 150 ;
parameter seg16x  = 132 ;
parameter seg4x  = 135 ; 
  reg    reset   ; 
  reg  [7:0]  sec   ; 
  wire    plot   ; 
  wire  [7:0]  x   ; 
  reg  [2:0]  level   ; 
  wire  [6:0]  y   ; 
  reg  [5:0]  platesize   ; 
  reg    clk   ; 
  reg  [7:0]  ballx   ; 
  reg  [7:0]  min   ; 
  reg  [15:0]  gamepoint   ; 
  reg  [6:0]  bally   ; 
  reg  [7:0]  platex   ; 
  reg  [5:0]  ballsize   ; 
  wire  [2:0]  color   ; 
  reg  [6:0]  platey   ; 
  initial
  begin
    clk=0;
    reset=1;
    #3 reset=0;
    level=4;
    sec=8'b01010010;
    min=8'b00110111;
    gamepoint=16'b0001_0110_1000_0000;
    bally<=0;
    ballx<=110;
    platesize<=10;
    ballsize<=5;
    platex<=170;
    platey<=100;
    #20000 
    ballx<=200;
    
  end
  always #1
  begin
    clk=~clk;
  end
  
  vga    
   DUT  ( 
       .reset (reset ) ,
      .sec (sec ) ,
      .plot (plot ) ,
      .x (x ) ,
      .level (level ) ,
      .y (y ) ,
      .platesize (platesize ) ,
      .clk (clk ) ,
      .ballx (ballx ) ,
      .min (min ) ,
      .gamepoint (gamepoint ) ,
      .bally (bally ) ,
      .platex (platex ) ,
      .ballsize (ballsize ) ,
      .color (color ) ,
      .platey (platey ) ); 

endmodule

