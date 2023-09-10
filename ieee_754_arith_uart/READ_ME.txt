--- Yongatek Microelectronics Internship Project ---


This is a floating point arithmetics project for Nexys 4 DDR board.  Top
module receives 11 byte packets in accordance with UART protocol.If header and footer
bytes are requested ones (x"BA" and x"DB")it processes some arithmetic operations.
2. byte is command byte (x"00"=> '+' | x"01"=> '-' | x"02"=> '*' | x"03"=> '/' ).
Other 8 byte's first 4 is a floating point number which is based IEEE 754. Left
bytes are also a IEEE 754 floating point number. Top module applies necessary
arithmetics and returns a 6 byte packet. This packet has same header and footer. Left 4
bytes are of course final floating point number which is result. Necessary modules
are available. There are coded test benches for almost all of the modules one by
one. Also sample packets are generated with Matlab and recorded in a text file
"1000_data_i.txt". Calculated final packets with Matlab are recorded in a different text file
"1000_data_o.txt". Finally the sample packets have given to top module in a test bench and
outputs have taken to "1000_data_w.txt". In a Matlab script errors are compared and
plotted.        
