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
utctime1='2020-12-21 T20:00:00'; % Our end date
et1 = cspice_str2et ( utctime1 ); % Call SPICE to convert it to ET1
utctime2='2250-01-01'; % Our end date
et2 = cspice_str2et ( utctime2 ); % Call SPICE to convert it to ET1
et=[linspace(et0,et1,10000)  linspace(et1,et2,10000)]; % Vector of instants

frame = 'ECLIPJ2000'; % Referece frames
abcorr = 'NONE'; % No corrections
observer = '0'; %  It doesn't matter

[dearth,lt] = cspice_spkpos('399',et,frame,abcorr,observer); % Pos Earth
[djup, lt] = cspice_spkpos('5',et,frame,abcorr,observer); % Pos Jupiter
[dsat, lt] = cspice_spkpos('6',et,frame,abcorr,observer); % Pos Saturn

a = djup - dearth;      % Vector from Earth to Jupiter
b = dsat - dearth;      % Vector from Earth to Saturn

for i=1:numel(et)
    dateAux = cspice_et2utc(et(i), 'C', 0);    % Date in Calendar format
    stringDate = append(dateAux(1:4),'-',lower(dateAux(6:8)),'-',dateAux(10:11)); % Date in 'InputFormat'
    dates(i) = datetime(stringDate,'InputFormat','yyyy-MMM-dd');  % Dates in datetime
    norma(i) = norm(a(:,i));    % Norm of each vector
    normb(i) = norm(b(:,i));
    angle(i) = rad2deg(acos((dot(a(:,i),b(:,i)))/(norma(i)*normb(i)))); % Angle at each instant
end
figure(1);
set(findall(gcf,'-property','FontSize'),'FontSize',18)
plot(dates,angle);
xlabel('date');
ylabel('degrees');
title(sprintf('Angular distance between Jupiter and Saturn seen from Earth'))
set(findall(gcf,'-property','FontSize'),'FontSize',18)

min = min(angle);
[df, mindate] = find(angle==min);

figure(2);
set(findall(gcf,'-property','FontSize'),'FontSize',18)
plot(dates(mindate(1)-1:mindate(1)+2),angle(mindate(1)-1:mindate(1)+2));
xlabel('date');
ylabel('degrees');
title(sprintf('Angular distance between Jupiter and Saturn seen from Earth 21/12/2020'))
set(findall(gcf,'-property','FontSize'),'FontSize',18)


X = ['Angular distance in ', datestr(dates(10000)),': ', num2str(angle(10000)), 'degrees'];
disp(X);

disp('References:')
link = '<a href = "http://nightskyonline.info/wp-content/uploads/2016/10/2020_Jupiter_Saturn_close_encounter_poster_A3_size.pdf">When Will the Next Great Conjunctions Take Place?</a>';
disp(link);

endSPICE; % Unload the kernels 