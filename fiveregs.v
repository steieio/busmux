

module fiveregs #(
    parameter DATAW = 8
) (
    input  wire               i_clk,
    input  wire               i_rst,
    input  wire               i_we,
    input  wire [7:0]         i_addr,
    input  wire [(DATAW-1):0] i_data,
    output wire [(DATAW-1):0] o_data
);

    reg [(DATAW-1):0] reg0;
    reg [(DATAW-1):0] reg1;
    reg [(DATAW-1):0] reg2;
    reg [(DATAW-1):0] reg3;
    reg [(DATAW-1):0] reg4;

    reg [(DATAW-1):0] r_data;

    assign o_data[(DATAW-1):0] = r_data[(DATAW-1):0];

    always @(posedge i_clk) begin
        if (i_rst) begin
            reg0 <= 32'h0;
            reg1 <= 32'h0;
            reg2 <= 32'h0;
            reg3 <= 32'h0;
            reg4 <= 32'h0;
        end
        else if (i_we) begin
            case(i_addr[2:0])
            3'h0: reg0 <= i_data;
            3'h1: reg1 <= i_data;
            3'h2: reg2 <= i_data;
            3'h3: reg3 <= i_data;
            3'h4: reg4 <= i_data;
            default: begin end
            endcase
        end
    end

    always @(posedge i_clk) begin
        case(i_addr[2:0])
        3'h0:    r_data <= reg0;
        3'h1:    r_data <= reg1;
        3'h2:    r_data <= reg2;
        3'h3:    r_data <= reg3;
        default: r_data <= reg4;
        endcase
    end

endmodule
