function [mappedcontainer] = binary_mapper(object)
%% Generic mapper function
value = {};
l = length(object);
value{l} = zeros(l-1,1)';

for i=1:length(object)-1
    ob = object(i);
    if isequal(ob,Inf)
        array = NaN(l-1,1)';
    else
        array = zeros(l-1,1)';
        array(i) = 1;    
    end
    value{i} = (array);
end
mappedcontainer =  containers.Map(object,value);
end

    
    