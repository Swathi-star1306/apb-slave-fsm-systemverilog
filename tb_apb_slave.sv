module tb;

logic PCLK;
logic PRESETn;

logic PSEL;
logic PENABLE;
logic PWRITE;

logic [7:0] PADDR;
logic [7:0] PWDATA;

logic [7:0] PRDATA;
logic PREADY;


apb_slave dut(

.PCLK(PCLK),
.PRESETn(PRESETn),

.PSEL(PSEL),
.PENABLE(PENABLE),
.PWRITE(PWRITE),

.PADDR(PADDR),
.PWDATA(PWDATA),

.PRDATA(PRDATA),
.PREADY(PREADY)

);


initial
begin

PCLK = 0;

forever #5 PCLK = ~PCLK;

end


initial
begin

PRESETn = 0;

PSEL = 0;
PENABLE = 0;
PWRITE = 0;

PADDR = 0;
PWDATA = 0;

#20;

PRESETn = 1;



// WRITE OPERATION

@(posedge PCLK);

PSEL = 1;
PENABLE = 1;
PWRITE = 1;

PADDR = 8'h10;
PWDATA = 8'hAA;

@(posedge PCLK);

PSEL = 0;
PENABLE = 0;



// READ OPERATION

@(posedge PCLK);

PSEL = 1;
PENABLE = 1;
PWRITE = 0;

PADDR = 8'h10;

@(posedge PCLK);

PSEL = 0;
PENABLE = 0;


#20;

$finish;

end


initial
begin

$monitor("TIME=%0t PSEL=%0b PENABLE=%0b PWRITE=%0b PADDR=%0h PWDATA=%0h PRDATA=%0h PREADY=%0b",
$time,PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA,PREADY);

end

endmodule
