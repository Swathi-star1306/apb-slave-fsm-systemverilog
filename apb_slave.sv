module apb_slave(

input logic PCLK,
input logic PRESETn,

input logic PSEL,
input logic PENABLE,
input logic PWRITE,

input logic [7:0] PADDR,
input logic [7:0] PWDATA,

output logic [7:0] PRDATA,
output logic PREADY

);

typedef enum logic [1:0]
{
SETUP,
WRITE,
READ
} state_type;

state_type present_state,next_state;

logic [7:0] mem [255:0];

always_ff @(posedge PCLK or negedge PRESETn)
begin

if(!PRESETn)
present_state <= SETUP;

else
present_state <= next_state;

end


always_comb
begin

next_state = present_state;

case(present_state)

SETUP:
begin

if(PSEL && PENABLE && PWRITE)
next_state = WRITE;

else if(PSEL && PENABLE && !PWRITE)
next_state = READ;

else
next_state = SETUP;

end


WRITE:
begin

next_state = SETUP;

end


READ:
begin

next_state = SETUP;

end

endcase

end


always_ff @(posedge PCLK or negedge PRESETn)
begin

if(!PRESETn)
begin

PRDATA <= 0;
PREADY <= 0;

end

else
begin

case(present_state)

SETUP:
begin

PREADY <= 0;

end


WRITE:
begin

mem[PADDR] <= PWDATA;

PREADY <= 1;

end


READ:
begin

PRDATA <= mem[PADDR];

PREADY <= 1;

end

endcase

end

end

endmodule
