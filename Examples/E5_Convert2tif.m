% Converts all images in cache to tif format 
% WARNING: this can generate a lot of data
clear 
close all

myFiles = dir(sprintf('%s/imgo/*mat',getHomeSpice)); %gets all wav files in struct
for k = 1:length(myFiles)
    fprintf('<%s>\n',myFiles(k).name);
    load(sprintf('%s/imgo/%s',getHomeImages,myFiles(k).name));
    imshow(a);
    if strcmp(class(a),'single')
        b=uint8(255*a);
    else
        b=uint16(65535*a);
    end
    
    ftif=strrep(sprintf('%s/imgo/%s',getHomeImages,myFiles(k).name),'mat','tif');
    imwrite(b,ftif);
end