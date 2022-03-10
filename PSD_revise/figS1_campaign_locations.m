%% this script will plot the geo location of the measurements 

clearvars;
clc;
close all;
%% paths 
mainpath    = '/Users/jun-work/Desktop/UCLA';
addpath('/Users/jun-work/Desktop/UCLA/codes/functions/'); % Add path for MATLAB addons
plotpath    = sprintf('%s/plots/paper1/',mainpath);


%% 
name = {strvcat({'FENNEC 2011','(Ryder et al., 2013a & 2015)'}),...
        strvcat({'FENNEC-SAL','(Ryder et al., 2013b)'}),...
        strvcat({'DARPO','(Wagner et al., 2009)'}),...
        strvcat({'SALTRACE (Barbados)','(Weinzierl et al., 2017)'}),...
        strvcat({'SALTRACE (Cape Verde)','(Weinzierl et al., 2017)'}),...
        }; 
latlon = {[23.18 360-7], [28 360-16],[38 360-7.9], [12 360-60], [15 360-23]}; 
MarkerColor = {'m','k','k','k','k'};
locationAdjustLat = [-1 -1 -0.5 0 -3];
locationAdjustLon = [-12 -12 -7.7  1 -1];


p  =figure;
set(p,'position',[10 10 1100 800]);

for ii= 1:length(name)
    
    geoscatter(latlon{ii}(1),latlon{ii}(2),200,MarkerColor{ii},'^','LineWidth',2); hold on
    %geolimits([0 50],[360-70 30])
    
    % add the campaign name
    text(latlon{ii}(1)+locationAdjustLat(ii),latlon{ii}(2)+locationAdjustLon(ii),...
        name{ii},'color',MarkerColor{ii},'FontSize',16,'FontWeight','bold')
end
geobasemap colorterrain

%print(p,'-dpng','-r150',sprintf('%s/fig1s_locations',plotpath));