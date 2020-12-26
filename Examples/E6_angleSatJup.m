% Sergi Berdor December 2020
% Simple example to start with SPICE
% Plot the angle formed by Jupiter and Saturn seen from Earth during 4 years
% (2018-01-01 to 2022-01-01)
close all;
clear;

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
observer = '0'; %  It doesn't matter

[dearth,lt] = cspice_spkpos('399',et,frame,abcorr,observer); % Pos Earth
[djup, lt] = cspice_spkpos('5',et,frame,abcorr,observer); % Pos Jupiter
[dsat, lt] = cspice_spkpos('6',et,frame,abcorr,observer); % Pos Saturn

% angle0 = rad2deg(cspice_vsep(dearth,djup));
% angle1 = rad2deg(cspice_vsep(dearth,dsat));

a = djup - dearth;      % Vector from Earth to Jupiter
b = dsat - dearth;      % Vector from Earth to Saturn
for i=1:1000
    norma(i) = norm(a(:,i));    % Norm of each vector
    normb(i) = norm(b(:,i));
    angle(i) = rad2deg(acos((dot(a(:,i),b(:,i)))/(norma(i)*normb(i)))); % Angle at each instant
end

plot(et, angle,'k') % Do the plot 
set(findall(gcf,'-property','FontSize'),'FontSize',18)
xlabel('time');
ylabel('angle');
title(sprintf('Angle formed by Jupiter and Saturn seen from Earth'))
legend({'degrees(º)'});
set(findall(gcf,'-property','FontSize'),'FontSize',18)

endSPICE; % Unload the kernels 