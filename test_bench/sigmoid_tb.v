`define TEST_BENCH
`include "../config.v"
`include "../sigmoid.v"




module test_sigmoid;
  reg[11:0] sum;
  wire[7:0] s;
  sigmoid  #(12, 8) sigmoidins(sum, s);
  reg[7:0] i;
  initial
  begin
    $monitor($time,,
    "sum = %d s = %d",
    sum, s);
    #10 sum=12'h60;
    for(i=1;i<197;i=i+1)
     #10 sum=sum-1;
     
  end
endmodule
