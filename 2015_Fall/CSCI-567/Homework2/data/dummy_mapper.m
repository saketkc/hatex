function [mappedcontainer] = dummy_mapper(object)
%% Generic mapper function
value = {};
l = length(object);
polynomial = zeros(l+1,1)';

p(1) = 1;
p(l+1) = -1;
r =  roots(p);
if l<=2
%value{1} = zeros(l,1)';
value{1}=[1];
value{2}=[-1];
else
    for i=1:l
    array = zeros(2,1)';
    array(1) = real(r(i));
    array(2) = imag(r(i));
    value{i} = (array);
    end
end
mappedcontainer =  containers.Map(object,value);
end
