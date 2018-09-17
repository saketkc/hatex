function [mappedcontainer] = binary_mapper(object)
%% Generic mapper function
value = {};
l = length(object);
for i=1:length(object)
    array = zeros(l,1)';
    array(i) = 1;
    value{i} = (array);
end
mappedcontainer =  containers.Map(object,value);
end

    
    