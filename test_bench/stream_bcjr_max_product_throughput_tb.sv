`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2020 12:34:29 PM
// Design Name: 
// Module Name: stream_bcjr_max_product_throughput_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stream_bcjr_max_product_throughput_tb();

parameter BITS = 32, PRECISION = "SINGLE";
parameter BITS_PER_SYMBOL = 2, SYMBOLS = 5;
parameter STATES = 4, NIN = 1, NOUT = 2, RECURSIVE = 7;
parameter int POLY[NOUT] = '{ 5, 7 };
trellis_if #(.STATES(STATES), .NIN(NIN), .NOUT(NOUT), .RECURSIVE(RECURSIVE), .POLY(POLY)) trellis();
real LLRVector[BITS_PER_SYMBOL][SYMBOLS];
real LLR_D[BITS_PER_SYMBOL][SYMBOLS];

logic in_valid;
logic out_valid;

logic in_valid_stream;
logic [BITS-1:0] LLRVector_stream[BITS_PER_SYMBOL];
logic out_valid_stream;
logic [BITS-1:0] LLR_D_stream[BITS_PER_SYMBOL];

logic clk;

task CompareAlphaMetrics();
  for (int i = 0; i < STATES; i++)
    begin
      real a1;
      real a2;
      logic [BITS-1:0] temp;
      a1 = bcjr_max_product_behav1.AlphaMetric[i][1];
      //temp = stream_bcjr_max_product1.AlphaMetric[i][1];
      //temp = stream_bcjr_max_product1.AlphaMetric[i][1];
      a2 = $bitstoshortreal(temp);
      if (a1 != a2)
        $display("%d %f %f\n", temp, a1, a2);
    end
endtask

task BehavTest(input real LLRVectorIn[BITS_PER_SYMBOL][SYMBOLS]);
 in_valid <= 1;
  for (int i = 0; i < BITS_PER_SYMBOL; i++)
    for (int j = 0; j < SYMBOLS; j++)
      begin
        LLRVector[i][j] <= LLRVectorIn[i][j];
      end
  @(posedge clk)
  in_valid <= 0;
  while (out_valid == 0) @(posedge clk);
  //CompareAlphaMetrics();
  for (int i = 0; i < BITS_PER_SYMBOL; i++)
    for (int j = 0; j < SYMBOLS; j++)
      LLRVector[i][j] <= 0.0;
endtask

task StreamTest(input real LLRVectorIn[BITS_PER_SYMBOL][SYMBOLS]);
 in_valid_stream <= 1;
 for (int i = 0; i < SYMBOLS; i++)
   begin
    for (int j = 0; j < BITS_PER_SYMBOL; j++)
      LLRVector_stream[j] <= $shortrealtobits(LLRVectorIn[j][i]);
   @(posedge clk);
   end
 in_valid_stream <= 0;
 LLRVector_stream <= '{ default : 0 };
endtask

task Test(input real LLRVectorIn[BITS_PER_SYMBOL][SYMBOLS]);
  fork
    BehavTest(LLRVectorIn);
    StreamTest(LLRVectorIn);
  join
endtask

real LLRVector1[BITS_PER_SYMBOL][SYMBOLS] = '{'{2, -2, -2,  2, -2 }, '{2,  2, -2,  2,  2}};
real LLRVector2[BITS_PER_SYMBOL][SYMBOLS] = '{'{2,  2, -2,  2,  2}, '{2, -2, -2,  2, -2 }};
real LLRVector3[BITS_PER_SYMBOL][SYMBOLS] = '{'{-2,  2,  2, -2,  2 }, '{-2, -2, 2, -2, -2}};
real LLRVector4[BITS_PER_SYMBOL][SYMBOLS] = '{'{-2, -2,  2, -2, -2}, '{-2,  2, 2, -2,  2 }};
real LLRVector5[BITS_PER_SYMBOL][SYMBOLS] = '{'{ 0, 0, 0, 0, 0 }, '{ 0, 0, 0, 0, 0 }};

initial
  begin
    in_valid = 0;
    LLRVector = '{ default : 0 };
    in_valid_stream = 0;
    LLRVector_stream = '{ default : 0 };
    @(posedge clk);
    Test(LLRVector1);
    @(posedge clk);
    Test(LLRVector2);
    @(posedge clk);
    Test(LLRVector3);
    @(posedge clk);
    Test(LLRVector4);
    @(posedge clk);
    Test(LLRVector5);
    @(posedge clk);
    @(posedge clk);
    Test(LLRVector1);
    Test(LLRVector2);
    Test(LLRVector3);
    Test(LLRVector4);
    Test(LLRVector1);
    Test(LLRVector2);
    Test(LLRVector3);
    Test(LLRVector4);
    Test(LLRVector1);
    Test(LLRVector2);
    Test(LLRVector3);
    Test(LLRVector4);
    Test(LLRVector1);
    Test(LLRVector2);
    Test(LLRVector3);
    Test(LLRVector4);
    Test(LLRVector1);
    Test(LLRVector2);
    Test(LLRVector3);
    Test(LLRVector4);
    Test(LLRVector1);
    Test(LLRVector2);
    Test(LLRVector3);
    Test(LLRVector4);  
    Test(LLRVector1);              
    @(posedge clk);
    repeat (100) @(posedge clk);
    $stop;
  end
initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end

bcjr_max_product_behav
#(.BITS_PER_SYMBOL(BITS_PER_SYMBOL), .SYMBOLS(SYMBOLS))
bcjr_max_product_behav1
(
.trellis,
.in_valid,
.LLRVector,
.out_valid,
.LLR_D
);

stream_bcjr_max_product
#(.BITS(BITS), .PRECISION(PRECISION), .BITS_PER_SYMBOL(BITS_PER_SYMBOL), .SYMBOLS(SYMBOLS), .STATES(STATES))
stream_bcjr_max_product1
(
.clk,
.trellis,
.in_valid(in_valid_stream),
.LLRVector(LLRVector_stream),
.out_valid(out_valid_stream),
.LLR_D(LLR_D_stream)
);

endmodule
