% close all
clearvars -except d r

r = randi(100000)%815,5123(6)
rng(r)%705410,1337,12816,723,8675309,17327218,1776,371753,86759,1121,1990,1578,179216,290811,122686

N  = 3;% Number of objects
writeCSVFile = false;
% For drawing objects and tails
tstep = 10;
tlen = 500*tstep;

kscale = 1e12;% numerical precision
G  = 6.67e-11*kscale;

cmap = cool(N);
me = 2e24/kscale/kscale;
m  = me*ones(N,1)';
% m(1) = 2*me;
R0 = 1e8/kscale^(1/3);
dt = 100;
t  = 0:dt:4500000;
NT = numel(t);

rs    = R0;
rmax  = 1.1*rs;
rsmax = 5*rs;

states        = zeros(6,NT,N);
states(:,1,1) = zeros(6,1);

for j = 1:N

        vscale = sqrt(me*G/R0);

        temp(1:3) = R0*randn(1,3);
        temp(4:6) = vscale.*randn(1,3)/2;

        [childPos, childVel] = deal(temp(1:3),temp(4:6));
        states(1:3,1,j) = childPos;
        states(4:6,1,j) = childVel;

end

s = squeeze(states(:,1,:));
s = s(:);
%% Integrate Equations of Motion to get solution
[tout,sout] = ode89(@(t,y)ThreeBodyEOMs(t,y,m,N,G),t,s);
NT = numel(tout);
t  = tout;
s  = permute(reshape(sout,[NT,6,N]),[2,1,3]);

E = getEnergyFunc(t,s,m,N,G);% Total energy should be conserved

E = 100*(E-E(1))/E(1);
disp(max(abs(E)))

rcm = zeros(3,NT,N);
for j = 1:NT
    rcm(:,j,:) = repmat(getCM(s(:,j,:),m),[1,1,N]);
end

if writeCSVFile
    csv_filename = 'spheres2_data.csv';
    fid = writePositionDataToCSV(s(1:3,:,:)-rcm,csv_filename);
end

d = [];
for j = 1:N
    for k = (j+1):N
        temp = s(1:3,:,j)-s(1:3,:,k);
        temp = sqrt(sum(temp.^2,1));
        d    = cat(1,d,temp(:));
    end
end

ax3=[];ax1=[];
f3 = figure(3);
cla(ax3)
ax3 = gca;
phE = plot(ax3,t,E,'-','LineWidth',2);
hold all
mhE = plot(ax3,t(1),E(1),'ow');
ylabel(ax3,'\DeltaE (%)','Color','w','FontSize',10)
ax3.XColor='w';
ax3.YColor='w';

f3.Color = 'k';
ax3.Color = 0*[1,1,1]/3.2;
ylim(100*[-.05,.05])


figure(1)
f1 = gcf;
cla(ax1)
ax1 = gca;
f1.Color = 'k';
ax1.Color = 0*[1,1,1]/3.2;
axis off

ax1.ColorOrder=cmap;

hold all
for i = 1:N
    plot3(ax1,s(1,:,i)-rcm(1,:,i),s(2,:,i)-rcm(2,:,i),...
        s(3,:,i)-rcm(3,:,i),'LineWidth',.1,'Color',cmap(i,:))
    ph1(i) = plot3(s(1,:,i)-rcm(1,:,i),s(2,:,i)-rcm(2,:,i),...
        s(3,:,i)-rcm(3,:,i),'o','Color','m');
    ph1(i).MarkerFaceColor = cmap(i,:);
end
xlim(ax1,2*[-rmax,rmax])
ylim(ax1,2*[-rmax,rmax])
zlim(ax1,2*[-rmax,rmax])
axis equal
% ax1.View
%% Plotting Stuff for Video

figh = figure(2);
ax = gca;
cla
figh.Color = 'k';
ax.Color = 0*[1,1,1]/3.2;

hold all
for i = 1:N

    ph(i) = plot3(ax,0,0,0,'LineWidth',2);
    ph(i).Color = cmap(i,:);
    mh(i) = plot3(ax,0,0,0,'o','MarkerSize',8,'Color',cmap(i,:));
    mh(i).MarkerFaceColor = cmap(i,:);

end

xlim(ax,[-rmax,rmax])
ylim(ax,[-rmax,rmax])
zlim(ax,[-rmax,rmax])
axis square

% ax.Color=09[1,1,1]/3;
ax.XTickLabel    = [];
ax.YTickLabel    = [];
ax.ZTickLabel    = [];
ax.GridLineStyle = 'none';

%% Update plots

cam_angle=0;
ivec = 1:tstep:NT;
it = 0;
for i = ivec
    it = it + 1;
    idplot = (i-tlen):tstep:i;
    idplot(idplot<=0)=[];

    % if numel(idplot)>tlen
    %     idplot(1)=[];
    % end

    for j = 1:N
        % if i>tlen
        ph(j).XData = s(1,idplot,j);
        ph(j).YData = s(2,idplot,j);
        ph(j).ZData = s(3,idplot,j);
        % end
        mh(j).XData = s(1,i,j);
        mh(j).YData = s(2,i,j);
        mh(j).ZData = s(3,i,j);
        
        if rand<.5
        ph1(j).XData = s(1,idplot(end),j)-rcm(1,idplot(end),j);
        ph1(j).YData = s(2,idplot(end),j)-rcm(2,idplot(end),j);
        ph1(j).ZData = s(3,idplot(end),j)-rcm(3,idplot(end),j);
        end
        % ph3(j).XData = t(1,idplot);
        % ph3(j).YData = s(2,idplot);

    end

    % phE.XData = t(idplot);
    % ph3.YData = E(idplot);

    mhE.XData = t(idplot(:));
    mhE.YData = E(idplot(:));
    % figure(3),
    % plot(ax3,t(idplot(end)),E(idplot(end)),'om')
    % plot
% drawnow
    rmaxf = getMaxDistanceFunc(s(1:3,i,:),N);
    
    lam = .99;
    rmax = lam*rmax+(1-lam)*rmaxf;

    xcm = rcm(1,i,1);
    ycm = rcm(2,i,1);
    zcm = rcm(3,i,1);

    % cam_angle = cam_angle + 0.001; % Increment angle for a slow orbit
    % cam_x = rmax * cos(cam_angle);
    % cam_y = rmax * sin(cam_angle);
    % cam_z = rmax / 2; % Position slightly above the plane
    % campos(ax,[cam_x, cam_y, cam_z]);  % Move the camera in an orbit
    % camtarget(ax,[xcm, ycm, zcm]);           % Keep the camera focused on the origin

    xlim(ax,1.5*[-rmax,rmax]+1*xcm)
    ylim(ax,1.5*[-rmax,rmax]+1*ycm)
    zlim(ax,1.5*[-rmax,rmax]+1*zcm)

    % ax.View = ax1.View;
    ax.CameraPosition=ax1.CameraPosition+rcm(:,i,1)';
    ax.CameraTarget = ax1.CameraTarget+rcm(:,i,1)';
    ax.CameraViewAngle = ax1.CameraViewAngle;
    % axis tight
    drawnow
    % cla(ax3)
    % ax1.CameraPosition=ax.CameraPosition+rcm(:,i,1)';
    % ax1.CameraTarget = ax.CameraTarget+rcm(:,i,1)';
    % ax1.CameraViewAngle = ax.CameraViewAngle;
    %     frame = getframe(gcf);
    %     writeVideo(myvid,frame)

end

% close(myvid)
