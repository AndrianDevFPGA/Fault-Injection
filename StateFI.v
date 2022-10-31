`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2022 11:08:35 AM
// Design Name: 
// Module Name: StateFI
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


module StateFI( 
               clk,
               rst,
               start,
               faulttype,
               dataIn,
               dataOut

    );
    parameter DataSize = 31;
    parameter SizeFault = 3;
    
    // input port
    input clk;
    input rst;
    input start; 
    input [SizeFault -1:0] faulttype;
    input [DataSize-1:0] dataIn;
    
    // output port 
    output reg [DataSize-1:0] dataOut;
    reg [DataSize-1:0] dataOut1;
    reg [DataSize-1:0] dataOut2;
    reg [DataSize-1:0] dataOut3;
    // state Machine 
    integer state;
    integer counter;
    
    always @ (posedge clk)
      begin
        if (rst)
          begin
            state <= 0;
            dataOut <= 32'dx;
            counter <= 0;
          end 
        else
          counter <= counter +1;
          begin
            case (state)
              0:
                begin
                  if (counter ==2)
                    begin
                      state <= 1;
                    end
                  else
                    begin
                      state <= 0;
                    end 
                end 
              1:
                begin
                  if (start==1 && faulttype == 3'd1)
                    begin
                      state <= 2;
                    end 
                  else if (start==1 && faulttype == 3'd2)
                    begin
                      state <= 3;
                    end 
                  else if (start ==1 && faulttype ==3'd3)
                    begin
                      state <= 4;
                    end
                  else
                    begin
                      state <= 1;
                    end 
                end 
              2 :
                begin
                  if (start ==0)
                    begin
                      state <= 1;
                    end
                  else
                    begin
                      state <= 2;
                    end 
                end 
              3:
                begin
                  if (start == 0)
                    begin
                      state <= 1;
                    end
                  if (faulttype ==3'd3)
                    begin
                      state <= 4;
                    end  
                  if (faulttype == 3'd1)
                    begin
                      state <= 2;
                    end
                  else
                    begin
                      state <= 3;
                    end 
                end 
             4:
               begin
                 if (start == 0)
                   begin
                     state <= 1;
                   end 
                 else
                   begin
                     state <= 4;
                   end 
             end 
            endcase
          end 
      end 
    
    always @ (negedge clk)
      begin
        case (state)
          0:
            begin
              dataOut <= 32'dx;
            end 
          1:
            begin
              dataOut <= dataIn;
            end
          2:
            begin
              dataOut <= {dataIn[31:30],4'b1111,dataIn[25:0]};
            end 
          3:
            begin
              dataOut <= dataIn *2;
            end 
          4:
            begin
              dataOut <= 32'dx;
            end 
        endcase
      end 
    
endmodule


/*
// Test bench
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2022 11:43:37 AM
// Design Name: 
// Module Name: tbFI
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


module tbFI(

    );
    
    parameter DataSize = 31;
    parameter SizeFault = 3;
    
    // input port
    reg clk;
    reg rst;
    reg start; 
    reg [SizeFault -1:0] faulttype;
    reg [DataSize-1:0] dataIn;
    
    // output port 
    wire [DataSize-1:0] dataOut;
    
    StateFI DUT( 
               clk,
               rst,
               start,
               faulttype,
               dataIn,
               dataOut

    );
    
    initial
      begin
        clk =0;
        rst = 1;
        start = 0;
        faulttype =0;
        dataIn = 32'd42;
        #10 
        rst =0;
        #100 
        start = 1;
        faulttype =2;
        #300 
        faulttype =1;
        #300 
        faulttype =3;
        #300 
        start =0; 
      end 
    
    
    always 
      begin
        #5 clk = ! clk;
      end 
endmodule


*/
