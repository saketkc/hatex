function [newdata] = transformdata(data)
    newdata = [];
    rows = size(data,1);
    columns = size(data,2);
    features_to_transform = [2, 7, 8, 14, 15, 16, 26, 29];

    for idx = 1:columns
        col = data(:,idx);
        if (any(idx==features_to_transform))
            first = (col==-1);
            second = (col==0);
            third = (col==1);
            concat = [first second third];
            newdata = [newdata first second third];
        else
            newdata(:,end+1) = col;
        end
    end
end
