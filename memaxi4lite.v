module axi4literam (
    clk, rst,

    awvalid, awready, awaddr, awprot,

    wvalid, wready, wdata, wstrb,

    bvalid, bready, bresp,

    arvalid, arready, araddr, arprot,

    rvalid, rready, rdata, rresp

);
    //Global Signals
    input clk;
    input rst;
    
    // Write Address Channel
    input [15:0] awaddr;    // Write Address
    input [2:0] awprot;     // Write Protection
    input awvalid;          // If 1 then write else Don't
    output awready;         // If Previous Value is 1 Then can accept Write Address

    // Write Data Channel
    input [31:0] wdata;     // Write Data
    input [3:0] wstrb;      // Write Strobe
    input wvalid;           // If 1 then (wdata and wstrb are correct) else its not
    output wready;          // If Previous Value is 1 Then can accept Write Data

    // Write Response Channel
    input bready;           // If 1 then Master can accept write data
    output bvalid;          // If 1 then bresp is valid else its not
    output [1:0] bresp;     // Indicates Status of Write Response

    // Read Address Channel
    input [15:0] araddr;    // Read Address
    input [2:0] arprot;     // Not going to be used
    input arvalid;          // If 1 then read else Don't Read
    output arready;         // If Previous Value is 1 Then Read else Don't

    // Read Data Channel
    input rready;           // If 1 then Read else Don't 
    output rvalid;          // If 1 then Rdata has Data else it Doesn't
    output [1:0] rresp;     // Status of Read Data
    output [31:0] rdata;    // Read Data

    // Memory
    reg [7:0] memory [65535:0];

    reg arready_reg, rvalid_reg;
    reg awready_reg, wready_reg, bvalid_reg;
    reg [31:0]rdata_reg;
    reg wr_en;
    reg rd_en;

    assign bresp = 3'b000;
    assign rresp = 2'b00;

    assign awready = awready_reg;
    assign wready = wready_reg;
    assign bvalid = bvalid_reg;
    assign arready = arready_reg;
    assign rdata = rdata_reg;
    assign rvalid = rvalid_reg;

    always @(*) begin
        wr_en = 1'b0;
        awready_next = 1'b0;
        wready_next = 1'b0;
        bvalid_next = bvalid_reg && !bready;
        if (awvalid && wvalid && (!bvalid || bready) && (!awready && !wready)) begin
            awready_next = 1'b1;
            wready_next = 1'b1;
            bvalid_next = 1'b1;
            wr_en = 1'b1;
        end

        rd_en = 1'b0;
        arready_next = 1'b0;
        rvalid_next = rvalid_reg && !(rready);
        if (arvalid && (!rvalid || rready) && (!arready)) begin
            arready_next = 1'b1;
            rvalid_next = 1'b1;
            rd_en = 1'b1;
        end
    end
    always @(posedge clk ) begin
        arready_reg <= arready_next;
        rvalid_reg <= rvalid_next;
        awready_reg <= awready_next;
        wready_reg <= wready_next;
        bvalid_reg <= bvalid_next;

        if () begin
            
        end

        if (mem_rd_en) begin
            rdata_reg <= mem[araddr];
        end

        if (rst) begin
            awready_reg <= 1'b0;
            wready_reg <= 1'b0;
            bvalid_reg <= 1'b0;
            arready_reg <= 1'b0;
            rvalid_reg <= 1'b0;
        end
    end
endmodule