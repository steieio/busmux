

module busmux #(
    parameter DATAW = 8
) (
    input  wire               i_clk,
    input  wire               i_rst,
    input  wire               i_stb,
    input  wire               i_we,
    input  wire [7:0]         i_addr,
    input  wire [(DATAW-1):0] i_data,
    output wire               o_ack,
    output wire [(DATAW-1):0] o_data, 
    output wire               o_xor
);

    wire [(DATAW-1):0] r2_data;
    wire [(DATAW-1):0] r3_data;
    wire [(DATAW-1):0] r4_data;
    wire [(DATAW-1):0] r5_data;

    wire              xor2;
    wire              xor3;
    wire              xor4;
    wire              xor5;

    reg               r2_we;
    reg               r3_we;
    reg               r4_we;
    reg               r5_we;

    reg               r_stb;
    reg               r_ack;
    reg [(DATAW-1):0] r_data;

    assign o_ack = r_ack;
    assign o_data = r_data;
    assign o_xor = ^{xor5, xor4, xor3, xor2};

    tworegs r2 (
        .i_clk (i_clk),
        .i_rst (i_rst),
        .i_we  (r2_we),
        .i_addr (i_addr),
        .i_data (i_data),
        .o_data (r2_data),
        .o_xor (xor2)
    );

    threeregs r3 (
        .i_clk (i_clk),
        .i_rst (i_rst),
        .i_we  (r3_we),
        .i_addr (i_addr),
        .i_data (i_data),
        .o_data (r3_data),
        .o_xor (xor3)
    );

    fourregs r4 (
        .i_clk (i_clk),
        .i_rst (i_rst),
        .i_we  (r4_we),
        .i_addr (i_addr),
        .i_data (i_data),
        .o_data (r4_data),
        .o_xor (xor4)
    );

    fiveregs r5 (
        .i_clk (i_clk),
        .i_rst (i_rst),
        .i_we  (r5_we),
        .i_addr (i_addr),
        .i_data (i_data),
        .o_data (r5_data),
        .o_xor (xor5)
    );

    always @(posedge i_clk) begin
        if (i_stb && i_we) begin
            r2_we <= (i_addr[6:4]==3'h0);
            r3_we <= (i_addr[6:4]==3'h1);
            r4_we <= (i_addr[6:4]==3'h2);
            r5_we <= (i_addr[6:4]==3'h3);
        end else begin
            r2_we <= 1'b0;
            r3_we <= 1'b0;
            r4_we <= 1'b0;
            r5_we <= 1'b0;
        end
    end

    always @(posedge i_clk) begin
        case(i_addr[6:4])
        3'h0:    r_data <= r2_data;
        3'h1:    r_data <= r3_data;
        3'h2:    r_data <= r4_data;
        default: r_data <= r5_data;
        endcase
    end   

    always @(posedge i_clk) begin
        r_stb <= i_stb;
    end

    always @(posedge i_clk) begin
        if (!r_ack) begin
            r_ack <= r_stb;
        end else begin
            r_ack <= 1'b0;
        end
    end

endmodule
