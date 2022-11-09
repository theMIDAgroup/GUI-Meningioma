%% [str_x] = ConvertNum2Str(x)
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function converts a number in a string, and it uses comma (,) as 
% decimal separator instead of the traditional dot (.)
% -------------------------------------------------------------------------
%%%% called by:  Write_Txt_Radiomics

function[str_x] = ConvertNum2Str(x)

minus = [];
if x<0, minus = '-'; end
x = abs(x);
str_x = [minus num2str(floor(x))];

temp = x-floor(x);
temp_str = num2str(temp);
if temp~=  0
    str_x = [str_x ',' temp_str(3:end)];
end
end