function s = getInitialVelocity(pp,pc,G,me)

r  = -pp+pc(1,:);
rn = norm(r);

vscale = sqrt(me*G/rn);

if size(pc,1)>1
    r2 = pp-pc(2,:);
    dr = r-r2;
else
    % pc(2,:) = pc(1,:)+;
    % r2 = ;
    dr = randn(1,3);
end

r = r/rn;

zhat = cross(r/rn,dr);
zhat = zhat/norm(zhat);

vr   = cross(zhat,r/rn);
vr   = vr./norm(vr);
s    = pc(1,:);

s(4:6) = vr.*vscale/2;

return
end