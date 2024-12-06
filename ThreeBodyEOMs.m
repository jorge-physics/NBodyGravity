function ds = ThreeBodyEOMs(t,s,m,N,G)

idp = 1:3;
 
s  = reshape(s',[6,N]);
sp = s(idp,:);

a    = zeros(N);

for i = 1:N
    for j = setdiff(1:N,i)

        r  = sp(:,j)-sp(:,i);
        rn = norm(r);
        r3 = rn.^3;

        a(i,j) = G*m(j)/r3;

    end
end

atot = zeros(3,N);
for i = 1:N% Loop through N Objects
    atemp = zeros(3,1);
    for j = setdiff(1:N,i)% Consider only the other masses

        r     = sp(:,j)-sp(:,i);
        atemp = atemp + a(i,j).*r;% form total acceleration

    end
    atot(:,i) = atemp;
end

ds(1:3,:) = s(4:6,:);
ds(4:6,:) = atot;

ds = ds(:);

return
end