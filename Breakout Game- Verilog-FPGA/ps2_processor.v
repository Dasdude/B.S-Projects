module ps2_processor(input tx_start , input [3:0] Data ,input clk, output reg right, left,reset);
  always @(posedge clk)
  begin
    if(tx_start==1)
      begin
        if(Data==6)
          begin 
          right=1;
          left=0;
          reset=0;
          end
        if(Data==4)
          begin
            right=0;
            left=1;
            reset=0;
          end
        if(Data==1)
          begin
            reset=1;
            right=0;
            left=0;
            
            
          end
          
      end
    else
      begin
        right=0;
        reset=0;
        left=0;
      end
  end
  
  
endmodule
