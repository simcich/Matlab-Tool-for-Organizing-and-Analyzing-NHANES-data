% MATLAB function: download and merge datasets from several years of the NHANES 
% and return a struct with the merged data
% 
% Syntax:
%   [DM] = dlmergnhanes(arrsurfix, arryears, arrData, master)
% 
% Parameters:
%   arrsurfix - array of surfix corresponding to each year, the format is e.g. "D"
%   arryears - array of cycles to download, format is "2005-2006"
%   arrData - array of datasets to download from each year cycle, e.g. "DEMO"
% 
% Example:
%   arrsurfix = {'D' 'E' 'F' 'G' 'H'};
%   arryears = {'2005-2006' '2007-2008' '2009-2010' '2011-2012' '2013-2014'};
%   arrData = {'DEMO' 'BPX' 'BMX'};
%   master = 1;
% 
%   cd 'C:\Users\simcich\Desktop\dl_merge_data_NHANES\data'; %data dir
%   [DM] = dlmergnhanes(arrsurfix, arryears, arrData, master)
% 
% Cite as / credit as:

% Reference
% A Matlab Tool for Organizing and Analyzing NHANES Data
% Cichosz, S. L., Jensen, M. H., Larsen, T. K. & Hejlesen, O., 16 jun. 2020, 
% Digital Personalized Health and Medicine. IOS Press, Bind 270. 
% s. 1179-1180 2 s. (Studies in Health Technology and Informatics , Bind 270).


function [DM] = dlmergnhanes(arrsurfix, arryears, arrData, master)


totalPat =0; % total subjects

for k=1:length(arryears)
    
    
    
    nhsYrs = arryears{k};
    surfix = arrsurfix{k};
    
    %% download data from cdc
    for i=1:length(arrData)
        
        wData = arrData{i};
        
        url = ['https://wwwn.cdc.gov/Nchs/Nhanes/' nhsYrs '/' wData '_' surfix '.XPT'];
        filename = [wData '_' surfix '.XPT'];
        outfilename = websave(filename,url)
        
    end
    
    %% Merge data
    wData = arrData{1};
    filename = [wData '_' surfix '.XPT'];
    tempData = xptread(filename);
    totalPat = totalPat + size(tempData,1);
    
    Data.years = nhsYrs;
    for i=1:length(arrData)
        
        wData = arrData{i};
        filename = [wData '_' surfix '.XPT'];
        Data.(wData) = xptread(filename);
        
    end
    DM.test = '1';
    DM.(['merge' nhsYrs(1:4)]) = Data.(arrData{1});
    
    for i=1:length(arrData)
        DM.(['merge' nhsYrs(1:4)]) = outerjoin(DM.(['merge' nhsYrs(1:4)]),Data.(arrData{i}),'MergeKeys',true,'Type','left')
    end
    clear Data
    
end

sound(sin(1:3000));

end