function [k,mid_val]=find_k(y,s)
% find the k defined in Nikolov's paper with respect to y which is a
% d-dimensional vector
    accuracy=1e-10;
    mid_val=sum(y)/s;
    
    if mid_val >= y(1)+accuracy
        k=-1;
        return
    end

    for i=1:s
        k=i;
        mid_val=sum(y((k+1):end))/(s-k);
        if mid_val >= y(k+1)-accuracy && mid_val < y(k)+accuracy
            return
        end
    end
end
