%% Script for Fig 2 in the manuscript
% This script plots simulated atmospheric PSD and observations from aged dust 
% 
% Jun Meng, March 2022 updated 
%
% Notes: 1. plot subplots in one figure
%        2. observations are converted. 
% 

clearvars;
clc;
close all;

%% paths 
mainpath    = '/Users/jun-work/Desktop/UCLA';
addpath('/Users/jun-work/Desktop/UCLA/code_plots_GRL_revise/PSD_revise/functions/'); % Add path for MATLAB addons
plotpath    = sprintf('%s/plots/paper1_revised/',mainpath);
datasetpath = sprintf('%s/datasets/',mainpath); 
sim_PSD     = sprintf('%s/datasets/model_output/model_PSD_new',mainpath);  

%% figure frame
p  =figure;
set(p,'position',[10 -200 1000 1000]);
subplotlabel = {' a ',' b ',' c ',' d ',' e ',' f  '};

% add tight subplot 
ha = tight_subplot(2,2,[.01 .01],[.07 .005],[.07 .01]);
% How to use tight_subplot:tight_subplot(x,y,[gap],[marg_h],[marg_w])
%     gap:    gaps between the axes in normalized units (0...1)
%                   or [gap_h gap_w] for different gaps in height and width 
%     marg_h: margins in height in normalized units (0...1)
%                   or [lower upper] for different lower and upper margins 
%     marg_w: margins in width in normalized units (0...1)
%                   or [left right] for different left and right margins 

%% program inputs and constants 
f_l  = 0.15;
CASES         = {'coarseD_kok11_new', 'coarseD_BFT_new'}; 
model_bin_edg = [0.1 1 2.5 5 10 14 20 28 40];
% calculate model bin spcing dlnD
for ii=1:(length(model_bin_edg)-1)
    model_bin_space_dlnD(ii) = log(model_bin_edg(ii+1)) - log(model_bin_edg(ii)); 
end
edge_integral =[0.1 20];    % size interval for normalization
YueConvert    = 1;
REF_NUMBER    = {[605 606],[609 611 612 613],[6652000 6654000],[6692000 6694000]}; 
% [605 606]  for cold pool Atlas 
% [609 611 612 613] for aged dust 
% For 6652000 6653000 6654000 6692000 6693000 6694000, have to plot seperately 

%% main
%0 get the ratio due to the change of parameters in the parameterization
    [ratio_new_old_function] = f_calc_ratio_mass_fraction_new_old(f_l);
    
for REFGroup =1:length(REF_NUMBER)
    
axes(ha(REFGroup));

nr=0;
for nref = REF_NUMBER{REFGroup}
    nr = nr+1;
    
    %1.read in measurements
    % -function: get the lat/lon info and observed dV/dlnD from flight averaged PSD from FENNEC 2011
    %[obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs,season_obs,ref_name]...
    %      = f_read_PSD_obs_Flights (datasetpath,nref,YueConvert);
    instrument = 'PCASPnCDP';
    [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs,season_obs,ref_name]...
          = f_read_PSD_obs_Flights_compare_conversion (datasetpath,nref,YueConvert,instrument);  
    %obs_dVdlnD_nref(:,nr)   = obs_dVdlnD;  
    
    % -reset ref-names 
    if nref >= 609 && nref <= 613
        ref_name_new  = ' B609 & B611-613';  
    elseif  nref >= 605 && nref < 609
        ref_name_new  = ' B605-606';
    else
    	ref_name_new  = ref_name; 
    end
    
    % -function: integral of observation using bin method
    %obs_dVdlnD_interal      = f_integral_obs_dV (datasetpath,nref,edge_integral,YueConvert) ;
    obs_dVdlnD_interal = f_integral_obs_dV_compare_conversion (datasetpath,nref,edge_integral,YueConvert,instrument); 
    obs_dVdlnD_norm_nref(:,nr)         = obs_dVdlnD/obs_dVdlnD_interal;
    
    
    
    %2.read in norm. model simulated PSD
    fname1 = sprintf('%s/PSD_dVdlnD_%s_ref%d.mat',sim_PSD,CASES{1},nref);
    fname2 = sprintf('%s/PSD_dVdlnD_%s_ref%d.mat',sim_PSD,CASES{2},nref);
    load(fname1);
    load(fname2);
    % prepare for calculate the average
    model1_loading_dVdlnD_nref(:,nr) = model1_loading_dVdlnD;
    model2_loading_dVdlnD_nref(:,nr) = model2_loading_dVdlnD.*ratio_new_old_function';  %BFT-coarse
   
    
    %3.read model ensemble from Yemi
    [model_ensemble_dVdlnD_norm,model_ensemble_dV,ensemble_bin_edg]=f_read_normalize_ensemble(datasetpath,edge_integral,nref);
    model_ensemble_norm_nref(:,nr) = model_ensemble_dVdlnD_norm; 
    model_ensemble_dV_nref(:,nr) = model_ensemble_dV; 
    
    %change nref name in order to align with the plot function
    if nref==613
        nref = 669; 
    elseif nref==606
        nref = 665;
    end
end
    model1_loading_dVdlnD_nref_avg = mean(model1_loading_dVdlnD_nref,2);
    model2_loading_dVdlnD_nref_avg = mean(model2_loading_dVdlnD_nref,2);
    
    obs_dVdlnD_norm_nref_avg            = mean(obs_dVdlnD_norm_nref,2);
    %obs_dVdlnD_nref_avg            = mean(obs_dVdlnD_nref,2);
    
    %Double check normalization 
    %[obs_dVdlnD_integral_doublecheck, bin_edge] = f_integral_obs_dVdlnD (obs_d,obs_dVdlnD_norm_nref_avg,edge_integral);
   
    model_ensemble_norm_nref_avg =   mean(model_ensemble_norm_nref,2);
    
    %3.5 normalize observation 
    %[obs_integral,obs_dlnD,obs_edge] = f_integral_obs_dV(obs_d,obs_dVdlnD_nref_avg,edge_integral);
    %obs_dVdlnD_norm     = obs_dVdlnD_nref_avg/obs_integral; 
    
    %4. normalize such that their integral over 0.1-20 um yields unity
    % function: integral of model output using bin method
    model1_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model1_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model2_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model2_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    %Normlization 
    model1_loading_dVdlnD_norm2_nref_avg = model1_loading_dVdlnD_nref_avg/model1_loading_dVdlnD_interal_norm2;
    model2_loading_dVdlnD_norm2_nref_avg = model2_loading_dVdlnD_nref_avg/model2_loading_dVdlnD_interal_norm2;
    
    %Double check normalization 
    model1_dVdlnD_interal_doublecheck = f_integral_model_dV(model1_loading_dVdlnD_norm2_nref_avg,model_bin_edg,edge_integral);
    model2_dVdlnD_interal_doublecheck = f_integral_model_dV(model2_loading_dVdlnD_norm2_nref_avg,model_bin_edg,edge_integral);
    
 %% split 0.1-10 bin into 0.2-0.5 and 0.5-1
    model1_dV = model1_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model2_dV = model2_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model_ensemble_dV = mean(model_ensemble_dV_nref,2);
    scheme_name1     = 'kok11';
    scheme_name      = 'kok_proposal_complex'; 
    model_bin_edge_new  = [0.2 0.5 1 2.5 5 10 14 20 28 40];   %9 bins
    model_ensemble_bin_edge_new = [0.2 0.5 1 2.5 5 10 14 20]; %7bins
    %function to split the first bin
    [model1_dVdlnD_norm_new]=f_split_first_bin(model1_dV, scheme_name1,f_l,edge_integral,model_bin_edge_new);
    [model2_dVdlnD_norm_new]=f_split_first_bin(model2_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    [model_ensemble_dVdlnD_norm_new]=f_split_first_bin(model_ensemble_dV, scheme_name1,f_l,edge_integral,model_ensemble_bin_edge_new);
 
%% plot the result 
    f_plot_fig3_wSubplots_4panel(obs_d, obs_dVdlnD_norm_nref_avg,...
                      model1_dVdlnD_norm_new,...
                      model2_dVdlnD_norm_new,...
                      model_ensemble_dVdlnD_norm_new,ensemble_bin_edg,...
                      ref_name_new,nref,...
                      model_bin_edg,model_bin_edge_new,REFGroup,subplotlabel,f_l,...
                      datasetpath); 
                
   
                  
end         

%% figure configurations 
   set(ha(1:2),'XTickLabel',''); 
   set(ha([2 4]),'YTickLabel','')


print(p,'-dpng','-r150',sprintf('%s/fig2_agedDust_wSubplots_4panel_lambda_%d',plotpath,f_l*100));
%print([figurepath,'Fig1_draft.png'],'-dpng');


