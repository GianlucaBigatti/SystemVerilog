package math_pkg;
    function automatic logic [1] is_power_of_two(
        input logic signed [7:0] x);
        return (x & (x-1)) ? 0 : 1; 
    endfunction

task automatic logic [7:0] gray_to_binary(
    input logic signed [7:0] gray
    output logic signed [7:0] binary);
        for (int i = 0; i < 8; i++)begin
            binary[i] = binary[i] ^ gray[7:i];
        end
        return binary[7:0];
endtask

//00000001
function automatic logic [3:0] count_leading_zeros(
    input logic signed [7:0] x
    output logic [3:0] count;)
        for(int i = 8; i > 0; i--)begin
            if(x == 0) count++;
            else return count;
        end
        return count;
endfunction        