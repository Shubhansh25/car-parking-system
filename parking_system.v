`timescale 1ns / 1ps
module parking_system( 
                input clk,rst_n,
 input entry_detect, exit_detect, 
 input [1:0] pass_1, pass_2,
 output wire GREEN_LED,RED_LED
 
    );
     // Moore FSM : o/p depend on present state
 parameter IDLE = 3'b000, WAIT_PASSWORD = 3'b001, WRONG_PASS = 3'b010, RIGHT_PASS = 3'b011,STOP = 3'b100;

 reg[2:0] present_state, next_state;
 reg[31:0] counter_wait;
 reg red_tmp,green_tmp;
 // Next state or idle
 always @(posedge clk or negedge rst_n)//here reset is active low
 begin
 if(~rst_n) //reset==0
 present_state = IDLE;
 else
 present_state = next_state;
 end
 // counter_wait
 always @(posedge clk or negedge rst_n) 
 begin
 if(~rst_n) 
 counter_wait <= 0;
 else if(present_state==WAIT_PASSWORD)
 counter_wait <= counter_wait + 1;
 else 
 counter_wait <= 0;
 end
 // change state

 always @(*)
 begin
 case(present_state)//connecting the states
 IDLE: begin
         if(entry_detect == 1)
 next_state = WAIT_PASSWORD;
 else
 next_state = IDLE;
 end
 WAIT_PASSWORD: begin
 if(counter_wait <= 3)
 next_state = WAIT_PASSWORD;
 else 
 begin
 if((pass_1==2'b01)&&(pass_2==2'b10))//correct pass 12
 next_state = RIGHT_PASS;
 else
 next_state = WRONG_PASS;
 end
 end
 WRONG_PASS: begin
 if((pass_1==2'b01)&&(pass_2==2'b10))
 next_state = RIGHT_PASS;
 else
 next_state = WRONG_PASS;
 end
 RIGHT_PASS: begin
 if(entry_detect==1 && exit_detect == 1)
 next_state = STOP;
 else if(exit_detect == 1)
 next_state = IDLE;
 else
 next_state = RIGHT_PASS;
 end
 STOP: begin
 if((pass_1==2'b01)&&(pass_2==2'b10))
 next_state = RIGHT_PASS;
 else
 next_state = STOP;
 end
 default: next_state = IDLE;
 endcase
 end
 // LEDs 
 always @(posedge clk) begin 
 case(present_state)
 IDLE: begin
 green_tmp = 1'b0;
 red_tmp = 1'b0;

 end
 WAIT_PASSWORD: begin
 green_tmp = 1'b0;
 red_tmp = 1'b1;

 end
 WRONG_PASS: begin
 green_tmp = 1'b0;
 red_tmp = ~red_tmp;

 end
 RIGHT_PASS: begin
 green_tmp = ~green_tmp;
 red_tmp = 1'b0;

 end
 STOP: begin
 green_tmp = 1'b0;
 red_tmp = ~red_tmp;

 end
 endcase
 end
 assign RED_LED = red_tmp  ;
 assign GREEN_LED = green_tmp;

endmodule
