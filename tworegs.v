

module tworegs #(
    parameter DATAW = 8
) (
    input  wire               i_clk,
    input  wire               i_rst,
    input  wire               i_we,
    input  wire [7:0]         i_addr,
    input  wire [(DATAW-1):0] i_data,
    output wire [(DATAW-1):0] o_data,
    output wire               o_xor
);

    reg [(DATAW-1):0] reg0;
    reg [(DATAW-1):0] reg1;

    reg [(DATAW-1):0] r_data;

    assign o_data[(DATAW-1):0] = r_data[(DATAW-1):0];
    assign o_xor = ^{reg1, reg0};

    always @(posedge i_clk) begin
        if (i_rst) begin
            reg0 <= 32'h0;
            reg1 <= 32'h0;
        end
        else if (i_we) begin
            case(i_addr[0])
            2'h0: reg0 <= i_data;
            2'h1: reg1 <= i_data;
            default: begin end
            endcase
        end
    end

    always @(posedge i_clk) begin
        case(i_addr[0])
        2'h0:    r_data <= reg0;
        default: r_data <= reg1;
        endcase
    end

endmodule
