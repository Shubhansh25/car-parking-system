`timescale 1ns / 1ps


module tb_parking_system;

  // Inputs
  reg clk;
  reg rst_n;
  reg entry_detect;
  reg exit_detect;
  reg [1:0] pass_1;
  reg [1:0] pass_2;

  // Outputs
  wire GREEN_LED;
  wire RED_LED;
 

  // initialising parking module as circuit under test
  parking_system cut (
  .clk(clk), 
  .rst_n(rst_n), 
  .entry_detect(entry_detect), 
  .exit_detect(exit_detect), 
  .pass_1(pass_1), 
  .pass_2(pass_2), 
  .GREEN_LED(GREEN_LED), 
  .RED_LED(RED_LED)
 
 );
 initial begin
 clk = 0;
 forever #10 clk = ~clk;
 end
 initial begin
 // Initialize Inputs
 rst_n = 0;
 entry_detect = 0;
 exit_detect = 0;
 pass_1 = 0;
 pass_2 = 0;
 // Wait 100 ns for global reset to finish
 #100;
      rst_n = 1;
 #20;
 entry_detect = 1;
 #1000;
 entry_detect = 0;
 pass_1 = 1;
 pass_2 = 2;
 #2000;
 exit_detect =1;
 #3000
 entry_detect=1;
 exit_detect=1; 
 pass_1 = 1;
 pass_2 = 2;
 
 // Add stimulus here

 end
      
endmodule
