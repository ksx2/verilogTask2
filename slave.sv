module slave
//#(parameter control_reg_ADDR = 4'h0, // адрес контрольного регистра
//  parameter output_reg_ADDR = 4'h4) // адрес регистра, где хранится значение
(
  input wire PWRITE, // сигнал, выбирающий режим записи или чтения (1 - запись, 0 - чтение)
  input wire PCLK,  // сигнал синхронизации
  input wire PSEL,  // сигнал выбора переферии 
  input wire [31:0] PRWADDR, // Адрес регистра
  input wire [31:0] PRWDATA,  // Данные для записи в регистр
  output reg [31:0] PRWDATA1=0, // Данные, прочитанные из регистра
  output reg [31:0] PRWDATA2=0, // Данные, прочитанные из регистра
  input wire PENABLE,   // сигнал разрешения
  output reg PREADY = 0  // сигнал готовности 
);

reg [63:0] pi_value; // Предполагаемое значение числа Pi
reg [63:0] e_value;
reg [31:0] pi_out_msb; // Старшие биты числа Pi
reg [31:0] pi_out_lsb; // Младшие биты числа Pi
reg [31:0] e_out_msb; // Старшие биты числа e
reg [31:0] e_out_lsb; // Младшие биты числа e

always @(posedge PCLK)
begin
$display("%b",PRWADDR);
if(PRWADDR == 32'b0000_0000_0000_0000_0000_0000_0000_0100)
begin
pi_value = $realtobits(3.1415);
PRWDATA1 <= pi_value[63:32];
PRWDATA2 <= pi_value[31:0];
$display("-----------");
$display("data1: %b,data2: %b,data: %b",PRWDATA1,PRWDATA2,pi_value);
end
if(PRWADDR == 32'b0000_0000_0000_0000_0000_0000_0000_1000)
    begin
e_value = $realtobits(2.7182);
PRWDATA1 <= e_value[63:32];
PRWDATA2 <= e_value[31:0];
$display("-----------");
$display("data1: %b,data2: %b,data: %b",PRWDATA1,PRWDATA2,e_value);
end
end
   

always @(posedge PCLK) begin
  if(PSEL == 1'b1 && PENABLE == 1'b0 && PWRITE == 1'b0) begin 
    PREADY = 0; 
  end
    
  else if(PSEL == 1'b1 && PENABLE == 1'b1 && PWRITE == 1'b0) begin 
    PREADY = 1;
  end

  else if(PSEL == 1'b1 && PENABLE == 1'b0 && PWRITE == 1'b1) begin 
    PREADY = 0; 
  end

  else if(PSEL == 1'b1 && PENABLE == 1'b1 && PWRITE == 1'b1) begin 
    PREADY = 1;
  end

  else begin
    PREADY = 0;
  end

  
end
endmodule