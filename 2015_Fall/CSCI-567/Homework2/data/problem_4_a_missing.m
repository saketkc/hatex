function [ missing ] = problem_4_a_missing( array )
missing = 0;
for i=1:length(array)
    i
    if isnan(array{i}) or strcmp(array{i},'')
            missing = missing+1;
    end    
end
end
