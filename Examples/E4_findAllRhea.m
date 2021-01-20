close all;
clear; 

%Test Git
% Recall that RESSlib should be in Matlab Path 

showImages=1; 

load('CassiniAll.mat'); % All Cassini spk kernels are obtained from
                        % exercise 3 (E3_Cassini Trajectory)
                        
spacecraftid='CASSINI';
encounter='SATURN';

L=getAllLists(spacecraftid,encounter); % get summary files

% Load time kernel

MK{end+1}='https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0012.tls';
MK{end+1}='https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/sat427.bsp';
MK{end+1}='https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/sat393.bsp';
initSPICEv(fullK(MK)); % fullK forms the full list needed by initSPICEv


% Time of all images
et=zeros(L.nd,1);
for i=1:L.nd
    et(i)=cspice_str2et(L.timestr{i});
end

onlyRHEA=find(strcmp(L.target,"RHEA")); % Indices of all Rhea images NOT sorted by time

% Sort by et
[~,indx]=sort(et(onlyRHEA));
onlyRHEA=onlyRHEA(indx);

%%

% A-Download and represent some images (arbitrarily selected)

for i=3400:3400 
    fprintf('Rhea Image %d/%d <%s>\n',i,numel(onlyRHEA),L.timestr{onlyRHEA(i)});
    a=getVoyagerCassiniImage(L,onlyRHEA(i),'CALIB');
    if showImages==1
        figure
        imshow(a);
    end
end

% B-Plot the distance from Rhea to Cassini for each image; download and
% represent the 10 images taken from shorter distance. Print their time
% WARNING: ALL CASSINI KERNELS SHOULD BE LOADED TO RUN THIS 

et_Rhea=et(onlyRHEA); % Time only of the images correspondent to Rhea
et_Rhea=et_Rhea.'; 
 
% Computation of the distance

frame = 'ECLIPJ2000';
abcorr = 'NONE';
observer='SUN';

[dCassini,lt]=cspice_spkezr('CASSINI',et_Rhea,frame,abcorr,observer);
[dRhea,lt]=cspice_spkezr('RHEA',et_Rhea,frame,abcorr,observer);
d=dCassini-dRhea; 
d=d(1:3,:); 
nd=vecnorm(d); % [km]

% Plots

image_number=1:length(onlyRHEA);

figure(1)
plot(image_number,nd,'k')
% set(figure(1),'Renderer', 'painters', 'Position', [400 400 500 350]);
set(gca,'TickLabelInterpreter','latex','fontsize',10)
xlabel('Number of the image','interpreter','latex','FontSize',12);
ylabel('Distance from Rhea to Cassini','interpreter','latex','FontSize',12);
grid

figure(2)
plot(et_Rhea,nd,'k')
set(gca,'TickLabelInterpreter','latex','fontsize',10)
xlabel('ET','interpreter','latex','FontSize',12);
ylabel('Distance from Rhea to Cassini','interpreter','latex','FontSize',12);
grid

% Representation of the 10 images taken from the the shorter distance

[Min_nd,Pos_Min]=sort(nd);

for i=1:10
    fprintf('Rhea Image %d/%d <%s>\n',Pos_Min(i),numel(onlyRHEA),L.timestr{onlyRHEA(Pos_Min(i))});
    a=getVoyagerCassiniImage(L,onlyRHEA(Pos_Min(i)),'CALIB');
    imshow(a)
end

%% Plot satelits


utctime0='2009-03-10'; % Our end date
et0 = cspice_str2et ( utctime0 ); % Call SPICE to convert it to ET1
utctime1='2009-03-14'; % Our end date
et1 = cspice_str2et ( utctime1 ); % Call SPICE to convert it to ET1
et=linspace(et0,et1,20);

LW=3; % LineWidth of the plots

frame = 'ECLIPJ2000';
abcorr = 'NONE';

observer = '699'; % Solar System  barycenter
scale = 149597871 ; % AU (km) 

% Positions

[dCassini,lt] = cspice_spkezr('CASSINI',et,frame,abcorr,observer);
[dSaturn,lt] = cspice_spkezr('699',et,frame,abcorr,observer);

[dTitan, lt] = cspice_spkezr('606',et,frame,abcorr,observer);
[dEnceladus, lt] = cspice_spkezr('602',et,frame,abcorr,observer);
[dMimas, lt] = cspice_spkezr('601',et,frame,abcorr,observer);
[dTethys, lt] = cspice_spkezr('603',et,frame,abcorr,observer);
[dDione, lt] = cspice_spkezr('604',et,frame,abcorr,observer);
[dIapetus, lt] = cspice_spkezr('608',et,frame,abcorr,observer);
[dHyperion, lt] = cspice_spkezr('607',et,frame,abcorr,observer);
[dRhea, lt] = cspice_spkezr('605',et,frame,abcorr,observer);
[dEpimetheus, lt] = cspice_spkezr('611',et,frame,abcorr,observer);
[dJanus, lt] = cspice_spkezr('610',et,frame,abcorr,observer);
[dPhoebe, lt] = cspice_spkezr('608',et,frame,abcorr,observer);
[dTelesto, lt] = cspice_spkezr('613',et,frame,abcorr,observer);
[dPolydeuces, lt] = cspice_spkezr('634',et,frame,abcorr,observer);
[dMethone, lt] = cspice_spkezr('632',et,frame,abcorr,observer);

figure(3)

% Plot positions
plot3(dCassini(1,:)/scale,dCassini(2,:)/scale,dCassini(3,:)/scale,'Color', [0, 0, 255] / 255,'LineWidth',LW)
hold on
plot3(dTitan(1,:)/scale,dTitan(2,:)/scale,dTitan(3,:)/scale,'Color', [0, 255, 0] / 255,'LineWidth',LW)
plot3(dEnceladus(1,:)/scale,dEnceladus(2,:)/scale,dEnceladus(3,:)/scale,'Color', [0, 255, 255] / 255,'LineWidth',LW)
plot3(dMimas(1,:)/scale,dMimas(2,:)/scale,dMimas(3,:)/scale,'Color', [255, 0, 0] / 255,'LineWidth',LW)
plot3(dTethys(1,:)/scale,dTethys(2,:)/scale,dTethys(3,:)/scale,'Color', [255, 0, 255] / 255,'LineWidth',LW)
plot3(dDione(1,:)/scale,dDione(2,:)/scale,dDione(3,:)/scale,'Color', [255, 255, 0] / 255,'LineWidth',LW)
plot3(dIapetus(1,:)/scale,dIapetus(2,:)/scale,dIapetus(3,:)/scale,'Color', [255, 255, 255] / 255,'LineWidth',LW)
plot3(dHyperion(1,:)/scale,dHyperion(2,:)/scale,dHyperion(3,:)/scale,'Color', [0, 100, 200] / 255,'LineWidth',LW)
plot3(dRhea(1,:)/scale,dRhea(2,:)/scale,dRhea(3,:)/scale,'Color', [200, 100, 0] / 255,'LineWidth',LW)
plot3(dEpimetheus(1,:)/scale,dEpimetheus(2,:)/scale,dEpimetheus(3,:)/scale,'Color', [50, 150, 255] / 255,'LineWidth',LW)
plot3(dJanus(1,:)/scale,dJanus(2,:)/scale,dJanus(3,:)/scale,'Color', [150, 50, 150] / 255,'LineWidth',LW)
plot3(dPhoebe(1,:)/scale,dPhoebe(2,:)/scale,dPhoebe(3,:)/scale,'Color', [255, 50, 150] / 255,'LineWidth',LW)
plot3(dTelesto(1,:)/scale,dTelesto(2,:)/scale,dTelesto(3,:)/scale,'Color', [255, 255, 100] / 255,'LineWidth',LW)
plot3(dPolydeuces(1,:)/scale,dPolydeuces(2,:)/scale,dPolydeuces(3,:)/scale,'Color', [100, 255, 150] / 255,'LineWidth',LW)
plot3(dMethone(1,:)/scale,dMethone(2,:)/scale,dMethone(3,:)/scale,'Color', [200, 100, 50] / 255,'LineWidth',LW)
hold on %Plot current positions
plot3(dCassini(1,20)/scale,dCassini(2,20)/scale,dCassini(3,20)/scale,'r*','LineWidth',LW)
plot3(dTitan(1,20)/scale,dTitan(2,20)/scale,dTitan(3,20)/scale,'r*','LineWidth',LW)
plot3(dEnceladus(1,20)/scale,dEnceladus(2,20)/scale,dEnceladus(3,20)/scale,'r*','LineWidth',LW)
plot3(dMimas(1,20)/scale,dMimas(2,20)/scale,dMimas(3,20)/scale,'r*','LineWidth',LW)
plot3(dTethys(1,20)/scale,dTethys(2,20)/scale,dTethys(3,20)/scale,'r*','LineWidth',LW)
plot3(dDione(1,20)/scale,dDione(2,20)/scale,dDione(3,20)/scale,'r*','LineWidth',LW)
plot3(dIapetus(1,20)/scale,dIapetus(2,20)/scale,dIapetus(3,20)/scale,'r*','LineWidth',LW)
plot3(dHyperion(1,20)/scale,dHyperion(2,20)/scale,dHyperion(3,20)/scale,'r*','LineWidth',LW)
plot3(dRhea(1,20)/scale,dRhea(2,20)/scale,dRhea(3,20)/scale,'r*','LineWidth',LW)
plot3(dEpimetheus(1,20)/scale,dEpimetheus(2,20)/scale,dEpimetheus(3,20)/scale,'r*','LineWidth',LW)
plot3(dJanus(1,20)/scale,dJanus(2,20)/scale,dJanus(3,20)/scale,'r*','LineWidth',LW)
plot3(dPhoebe(1,20)/scale,dPhoebe(2,20)/scale,dPhoebe(3,20)/scale,'r*','LineWidth',LW)
plot3(dTelesto(1,20)/scale,dTelesto(2,20)/scale,dTelesto(3,20)/scale,'r*','LineWidth',LW)
plot3(dPolydeuces(1,20)/scale,dPolydeuces(2,20)/scale,dPolydeuces(3,20)/scale,'r*','LineWidth',LW)
plot3(dMethone(1,20)/scale,dMethone(2,20)/scale,dMethone(3,20)/scale,'r*','LineWidth',LW)
xlabel('AU');
ylabel('AU');
zlabel('AU');
axis('equal');
legend({'Cassini','Titan','Enceladus','Mimas','Tethys','Dione','Iapetus','Hyperion', ...
    'Rhea','Epimetheus','Janus','Phoebe','Telesto','Polydeuces','Methone', 'current positions'});
title('Cassini trajectoy 13/03/2009');
grid
set(findall(gcf,'-property','FontSize'),'FontSize',18);


