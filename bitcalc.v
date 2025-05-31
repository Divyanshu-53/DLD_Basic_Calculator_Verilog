module bitcalc (
    input [3:0] a,         
    input [3:0] b,         
    input [1:0] mode,      
    output reg [7:0] result,
    output reg [3:0] remainder 
);

    reg [3:0] sum, diff;   
    reg [3:0] partial_prod;
    reg [7:0] quotient;    
    reg carry, borrow;     
    integer i;             

    always @(*) begin
        
        result = 8'b0;
        remainder = 4'b0;
        carry = 0;
        borrow = 0;

        case (mode)
            2'b00: begin 
                sum = 4'b0;
                carry = 0;
                for (i = 0; i < 4; i = i + 1) begin
                    
                    sum[i] = a[i] ^ b[i] ^ carry;
                    carry = (a[i] & b[i]) | (a[i] & carry) | (b[i] & carry);
                end
                result[3:0] = sum;
                result[4] = carry; 
            end

            2'b01: begin 
                diff = 4'b0;
                borrow = 0;
                for (i = 0; i < 4; i = i + 1) begin
                    diff[i] = a[i] ^ b[i] ^ borrow;
                    borrow = (~a[i] & b[i]) | ((~a[i] | b[i]) & borrow);
                end
                result[3:0] = diff;
                result[4] = borrow; 
            end

            2'b10: begin 
                partial_prod = 4'b0;
                result = 8'b0;
                for (i = 0; i < 4; i = i + 1) begin
                    if (b[i] == 1) begin
						  //partial_prod = a; 
						 // result = result + (partial_prod << i); 
                        result = result + (a << i); 
                    end
                end
            end

            2'b11: begin 
                quotient = 8'b0;
                remainder = 4'b0;
                for (i = 3; i >= 0; i = i - 1) begin
                    remainder = (remainder << 1) | a[i];
                    if (remainder >= b) begin
                        remainder = remainder - b;
                        quotient[i] = 1;
                    end else begin
                        quotient[i] = 0;
                    end
                end
                result[3:0] = quotient[3:0];
                remainder = remainder;
            end
        endcase
    end

endmodule
