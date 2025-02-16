module RoundRobinArbiter(clk, rstN,req,grant);
input wire clk;
input wire rstN;
input wire [7:0] req;
output reg [7:0] grant;

reg [2:0] pointer;
reg [7:0] mask;

always @(posedge clk or negedge rstN) begin
    if (!rstN) begin
        pointer <= 3'b000;
        mask <= 8'b11111111;
        grant <= 8'b00000000;
    end else begin
        // Condition 1: Equal Priority, Condition 3: Dynamic Scanning
        if (req[pointer]) begin
            grant <= 1 << pointer;
        end else begin
            // Condition 2: Active Request Management
            pointer <= pointer + 1;
            if (pointer == 8) pointer <= 0;
        end
    end
end

// Condition 4: Bandwidth Reallocation
always @(*) begin
    if (&grant == 1'b0) begin
        grant <= req;
    end
end

endmodule