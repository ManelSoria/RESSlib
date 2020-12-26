% Manel Soria July 2019
% E1_Earth: Simple example to start with SPICE
% Plot Earth and Moon position during 80 days from 2000-01-01
close all;
clear;
addpath('../RESSlib'); % Path to our toolkit: Robotic Exploration of the Solar System li
% List of the kernels URL:
METAKR={ 'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0012.tls', ...
 'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/de430.bsp', ...
 'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/Gravity.tpc' };
initSPICEv(fullK(METAKR)); % Init SPICE and load the kernels, if needed
utctime0='2018-01-01 T00:00:00'; % Our starting date
et0 = cspice_str2et ( utctime0 ); % Call SPICE to convert it to ET0
utctime1='2022-01-01 T00:00:00'; % Our end date
et1 = cspice_str2et ( utctime1 ); % Call SPICE to convert it to ET1
et=linspace(et0,et1,1000); % Vector of instants
frame = 'ECLIPJ2000'; % Referece frames
abcorr = 'NONE'; % No corrections
observer = '0'; %  3 Earth System barycenter
% observer = '0'; % Solar System barycenter Try this

[dearth,lt] = cspice_spkpos('399',et,frame,abcorr,observer); % Earth state (km)
[djup, lt] = cspice_spkpos('5',et,frame,abcorr,observer); % Jupiter state (km)
[dsat, lt] = cspice_spkpos('6',et,frame,abcorr,observer); % Saturn state (km)

% angle0 = rad2deg(cspice_vsep(dearth,djup));
% angle2 = rad2deg(cspice_vsep(dearth,dsat));

%plot de temps i angle
a = djup - dearth;
b = dsat - dearth;
for i=1:1000
    norma(i) = norm(a(:,i));
    normb(i) = norm(b(:,i));
    angle(i) = rad2deg(acos((dot(a(:,i),b(:,i)))/(norma(i)*normb(i))));
end

% angle = abs(angle0 - angle2);
% 
% 
% plot(et, angle0,'r') % Do the plot 
% hold on
% plot(et, angle2,'b') % Do the plot 
% hold on
plot(et, angle,'k') % Do the plot 
set(findall(gcf,'-property','FontSize'),'FontSize',18)
xlabel('time');
ylabel('angle');
title(sprintf('Angle between Jupiter and Saturn seen from Earth'))
legend({'degrees(º)'});
set(findall(gcf,'-property','FontSize'),'FontSize',18)

endSPICE; % Unload the kernels 