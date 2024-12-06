function rcm = getCM(s,m)

x   = squeeze(s(1,1,:))';
xcm = sum(x.*m)/sum(m);

y   = squeeze(s(2,1,:))';
ycm = sum(y.*m)/sum(m);

z   = squeeze(s(3,1,:))';
zcm = sum(z.*m)/sum(m);

rcm(1:3,1,1) = [xcm,ycm,zcm];

return
end