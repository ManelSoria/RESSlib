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

utctime0='1850-01-01'; % Our starting date
et0 = cspice_str2et ( utctime0 ); % Call SPICE to convert it to ET0
utctime1='2020-12-21'; % Our end date
et1 = cspice_str2et ( utctime1 ); % Call SPICE to convert it to ET1
utctime2='2250-01-01'; % Our end date
et2 = cspice_str2et ( utctime2 ); % Call SPICE to convert it to ET1
et=[linspace(et0,et1,3000)  linspace(et1,et2,3000)]; % Vector of instants

frame = 'ECLIPJ2000'; % Referece frames
abcorr = 'NONE'; % No corrections
observer = '0'; %  It doesn't matter

[dearth,lt] = cspice_spkpos('399',et,frame,abcorr,observer); % Pos Earth
[djup, lt] = cspice_spkpos('5',et,frame,abcorr,observer); % Pos Jupiter
[dsat, lt] = cspice_spkpos('6',et,frame,abcorr,observer); % Pos Saturn

a = djup - dearth;      % Vector from Earth to Jupiter
b = dsat - dearth;      % Vector from Earth to Saturn



for i=1:6000
    stringDates(i) = convert2DateNum(cspice_et2utc(et(i), 'C', 0));
    norma(i) = norm(a(:,i));    % Norm of each vector
    normb(i) = norm(b(:,i));
    angle(i) = rad2deg(acos((dot(a(:,i),b(:,i)))/(norma(i)*normb(i)))); % Angle at each instant
end
figure(1);
set(findall(gcf,'-property','FontSize'),'FontSize',18)
plot(stringDates,angle);
xlabel('date');
ylabel('angle');
title(sprintf('Angle formed by Jupiter and Saturn seen from Earth'))
set(findall(gcf,'-property','FontSize'),'FontSize',18)

figure(2);
set(findall(gcf,'-property','FontSize'),'FontSize',18)
plot(stringDates(2998:3002),angle(2998:3002));
xlabel('date');
ylabel('angle');
title(sprintf('Angle formed by Jupiter and Saturn seen from Earth 21/12/2020'))
set(findall(gcf,'-property','FontSize'),'FontSize',18)


endSPICE; % Unload the kernels 



function p = convert2DateNum(x)

switch x(6:8)
    case 'JAN'
        month = '01';
    case 'FEB'
        month = '02';
    case 'MAR'
        month = '03';
    case 'APR'
        month = '04';
    case 'MAY'
        month = '05';
    case 'JUN'
        month = '06';
    case 'JUL'
        month = '07';
    case 'AUG'
        month = '08';
    case 'SEP'
        month = '09';
    case 'OCT'
        month = '10';
    case 'NOV'
        month = '11';
    otherwise
        month = '12';
end
date = append(x(1:4),'-',month,'-',x(10:11));
p = datetime(date,'InputFormat','yyyy-MM-dd')
end