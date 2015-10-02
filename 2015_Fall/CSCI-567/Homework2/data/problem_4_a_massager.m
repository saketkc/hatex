function [ massaged_array, missing ] = problem_4_a_massager(type, cell)
massaged_array = [];
missing = 0;    
for i=2:length(cell)
    if strcmp(type, 'num')
        massaged_array(i-1) = str2double(cell{i});
        if isnan(massaged_array(i-1))
            missing = missing+1;
        end
        
    else
        massaged_array{i-1} = strtrim(cell{i});
        if strcmp(massaged_array{i-1},'')
            missing = missing+1;
        end
    end
    
end
end

