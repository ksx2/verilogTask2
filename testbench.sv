`include "master.sv"
`include "slave.sv"

module testbench;

reg [0:0] PCLK;
reg [0:0] PRESET;

reg [0:0] PSEL;
reg [0:0] transfer;
reg [0:0] PWRITE;

reg [31:0] PADDR;
reg [31:0] PDATA;

wire [0:0] PENABLE;
wire [31:0] PRWDATA;
wire [31:0] PRWADDR;

wire [31:0] PRDATA1;
wire [31:0] PRDATA2;
wire [0:0] PREADY;

reg [63:0] control_reg;

master m (
    .PCLK(PCLK),
    .PRESET(PRESET),
    .PSEL(PSEL),
    .PREADY(PREADY),
    .transfer(transfer),
    .PWRITE(PWRITE),      
    .PADDR(PADDR),
    .PDATA(PDATA),

    .PENABLE(PENABLE),
    .PRWDATA(PRWDATA),
    .PRWADDR(PRWADDR)
);

slave s (
    .PCLK(PCLK),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PRWDATA(PRWDATA),  // master out, slave in data
    .PRWADDR(PRWADDR),  // master out, slava in addr
    .PRWDATA1(PRDATA1),        // slave out data
    .PRWDATA2(PRDATA2),
    .PREADY(PREADY)        
);

reg [63:0] pi_value; // Предполагаемое значение числа Pi
reg [63:0] e_value;

// сначала делаем чтение в мастере,
// потом делаем передачу в слейв, где мы читаем память и изменяем
// в соответствии с заданием


initial begin

    $display("start");
    $dumpfile("testbench.vcd");
    $dumpvars(0,testbench);
    PADDR = 32'b0000_0000_0000_0000_0000_0000_0000_0100;
    PDATA = 0;

    PWRITE = 1'b1;
    
    PCLK = 1'b0;
    PRESET = 0;
    PSEL = 0;
    transfer = 1'b1;

    PRESET = 1;
    #10;

    PRESET = 0;
    PSEL = 1;
    #40;

    PSEL = 0;
    #20;
    
    
    PADDR = 32'b0000_0000_0000_0000_0000_0000_0000_0100;
    PSEL = 1;
    #40;
    PSEL = 0;
    pi_value[63:32] <= PRDATA1  ;
    pi_value[31:0] <= PRDATA2  ;
    
    #20;
    control_reg = 64'b0_10000000000_1001001000011100101011000000100000110001001001101111;//pi
    $display("Pi-------------------");
    $display("higher bits %b",PRDATA1);
    $display("lower bits %b",PRDATA2);
    $display("sign :%b",pi_value[63:63]);
    $display("exponent :%b",pi_value[62:52]);
    $display("mantissa :%b",pi_value[51:0]);
    if(control_reg==pi_value)
    begin
    $display("Control reg check : Same");
    end 
    else 
    begin
    $display("Control reg check :  not Same");
    end
    

    
    PADDR = 32'b0000_0000_0000_0000_0000_0000_0000_1000;
    PSEL = 1;
    #40;
    PSEL = 0;
    e_value[63:32] <= PRDATA1  ;
    e_value[31:0] <= PRDATA2  ;
    #20;
    control_reg = 64'b0_10000000000_0101101111101101111110100100001111111110010111001001;//e
    $display("e-------------------");
    $display("higher bits %b",PRDATA1);
    $display("lower bits %b",PRDATA2);
    $display("sign :%b",e_value[63:63]);
    $display("exponent :%b",e_value[62:52]);
    $display("mantissa :%b",e_value[51:0]);
    if(control_reg==e_value)
    begin
    $display("Control reg check : Same");
    end 
    else 
    begin
    $display("Control reg check :  not Same");
    end

   
    $finish;
end

always begin
    #5 PCLK = ~PCLK;
end

endmodule
