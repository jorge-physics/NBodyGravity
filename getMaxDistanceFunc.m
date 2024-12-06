function dmax = getMaxDistanceFunc(s,N)

it = 0;
for i = 1:N
    for j = setdiff(1:N,i)
        it = it + 1;

        d(:,it)=abs(s(:,1,i)-s(:,1,j));

    end
end

dmax = max(d(:));

return
end