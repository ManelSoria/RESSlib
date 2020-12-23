close all;
clear; 

%Test Git
% Recall that RESSlib should be in Matlab Path 

spacecraftid='CASSINI';
encounter='SATURN';


L=getAllLists(spacecraftid,encounter); % get summary files


% Load time kernel

MK={'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0012.tls'};
initSPICEv(fullK(MK));

% Time of all images
et=zeros(L.nd,1);
for i=1:L.nd
    et(i)=cspice_str2et(L.timestr{i});
end

onlyRHEA=find(strcmp(L.target,"RHEA")); % Indices of all Rhea images NOT sorted by time

% Sort by et
[~,indx]=sort(et(onlyRHEA));
onlyRHEA=onlyRHEA(indx);

% A-Download and represent some images (arbitrarily selected)
for i=2000:2010% 1:numel(onlyRHEA) 
    fprintf('Rhea Image %d/%d <%s>\n',i,numel(onlyRHEA),L.timestr{onlyRHEA(i)});
    a=getVoyagerCassiniImage(L,onlyRHEA(i),'CALIB');
    imshow(a);
end

% B-Plot the distance from Rhea to Cassini for each image; download and
% represent the 10 images taken from shorter distance. Print their time
% WARNING: ALL CASSINI KERNELS SHOULD BE LOADED TO RUN THIS 

% .. to be done

