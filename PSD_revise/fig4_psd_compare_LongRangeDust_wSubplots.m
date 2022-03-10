% This scripts plot simulated atmospheric PSD and observations from long range transported dust 
% Notes: 1. plot subplots in one figure
%        2. observations are not converted so far. 
% 
% for fig4 in the manuscript 

clearvars;
clc;
close all;

%% paths 
mainpath    = '/Users/jun-work/Desktop/UCLA';
addpath('/Users/jun-work/Desktop/UCLA/code_plots_GRL_revise/PSD_revise/functions/'); % Add path for MATLAB addons
plotpath    = sprintf('%s/plots/paper1_revised',mainpath);
datasetpath = sprintf('%s/datasets/',mainpath); 
sim_PSD     = sprintf('%s/datasets/model_output/model_PSD_new',mainpath);  

%% figure frame
p  =figure;
set(p,'position',[10 10 1100 1000]);

subplotlabel = {' a ',' b ',' c ',' d ',' e ',' f  '};
% add tight subplot 
ha = tight_subplot(3,2,[.01 .01],[.07 .005],[.07 .01]);
%        gap     gaps between the axes in normalized units (0...1)
%                   or [gap_h gap_w] for different gaps in height and width 
%        marg_h  margins in height in normalized units (0...1)
%                   or [lower upper] for different lower and upper margins 
%        marg_w  margins in width in normalized units (0...1)
%                   or [left right] for different left and right margins 
%% program inputs and constants 
f_l    = 0.2;
CASES        = {'coarseD_kok11_new', 'coarseD_BFT_new', 'coarseD_BFT_rho1000_new', 'coarseD_BFT_rho500_new','coarseD_BFT_rho250_new','coarseD_BFT_rho125_new'}; 
model_bin_edg = [0.1 1 2.5 5 10 14 20 28 40];
% calculate model bin spcing dlnD
for ii=1:(length(model_bin_edg)-1)
    model_bin_space_dlnD(ii) = log(model_bin_edg(ii+1)) - log(model_bin_edg(ii)); 
end
edge_integral =[0.1 20];    % size interval for normalization
YueConvert    = 0;
REF_NUMBER    = {[22],[23],[7],[8],[16],[17]}; 

% 7/8 southern portugal 2300/3200m
% 22/23 canary island  2000m/4000m
% 16/17 CV/BD         2600m/2300m
%% main
%0 get the ratio due to the change of parameters in the parameterization
    [ratio_new_old_function] = f_calc_ratio_mass_fraction_new_old(f_l);
    
for REFGroup =1:length(REF_NUMBER)

axes(ha(REFGroup));

nr=0;
for nref = REF_NUMBER{REFGroup}
    nr = nr+1;
    
    %1.read in measurements
    % -function: get the lat/lon info and observed dV/dlnD from REF_NUMBER observations compiled by Yemi
    [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs, season_obs,ref_name]...
        = f_read_PSD_obs_Refs(datasetpath,nref);
    if nref==22 || nref==23
    % -function: get the lat/lon info and observed dV/dlnD from flight averaged PSD from FENNEC SAL 2011
    [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs,season_obs,ref_name]...
          = f_read_PSD_obs_Flights (datasetpath,nref,YueConvert);
    end
    % -function: integral of observation using bin method
    %obs_dVdlnD_interal      = f_integral_obs_dV (datasetpath,nref,edge_integral,YueConvert) ;
    obs_dVdlnD_interal = f_integral_obs_dV(obs_d,obs_dVdlnD,edge_integral);
    obs_dVdlnD_norm         = obs_dVdlnD/obs_dVdlnD_interal;

    ref_name_new = ref_name;
    
    %2.read in norm. model simulated PSD
    fname1 = sprintf('%s/PSD_dVdlnD_%s_ref%d.mat',sim_PSD,CASES{1},nref);
    fname2 = sprintf('%s/PSD_dVdlnD_%s_ref%d.mat',sim_PSD,CASES{2},nref);
    fname3 = sprintf('%s/PSD_dVdlnD_%s_ref%d.mat',sim_PSD,CASES{3},nref);
    fname4 = sprintf('%s/PSD_dVdlnD_%s_ref%d.mat',sim_PSD,CASES{4},nref);
    fname5 = sprintf('%s/PSD_dVdlnD_%s_ref%d.mat',sim_PSD,CASES{5},nref);
    fname6 = sprintf('%s/PSD_dVdlnD_%s_ref%d.mat',sim_PSD,CASES{6},nref);
    load(fname1);
    load(fname2);
    load(fname3);
    load(fname4);
    load(fname5);
    load(fname6);
    % prepare for calculate the average
    model1_loading_dVdlnD_nref(:,nr) = model1_loading_dVdlnD;
    model2_loading_dVdlnD_nref(:,nr) = model2_loading_dVdlnD.*ratio_new_old_function';
    model3_loading_dVdlnD_nref(:,nr) = model3_loading_dVdlnD.*ratio_new_old_function';
    model4_loading_dVdlnD_nref(:,nr) = model4_loading_dVdlnD.*ratio_new_old_function';
    model5_loading_dVdlnD_nref(:,nr) = model5_loading_dVdlnD.*ratio_new_old_function';
    model6_loading_dVdlnD_nref(:,nr) = model6_loading_dVdlnD.*ratio_new_old_function';
    
    %3.read model ensemble from Yemi
    [model_ensemble_dVdlnD_norm,model_ensemble_dV,ensemble_bin_edg]=f_read_normalize_ensemble(datasetpath,edge_integral,nref);
    model_ensemble_norm_nref(:,nr) = model_ensemble_dVdlnD_norm; 
    model_ensemble_dV_nref(:,nr) = model_ensemble_dV; 
end
    model1_loading_dVdlnD_nref_avg = mean(model1_loading_dVdlnD_nref,2);
    model2_loading_dVdlnD_nref_avg = mean(model2_loading_dVdlnD_nref,2);
    model3_loading_dVdlnD_nref_avg = mean(model3_loading_dVdlnD_nref,2);
    model4_loading_dVdlnD_nref_avg = mean(model4_loading_dVdlnD_nref,2);
    model5_loading_dVdlnD_nref_avg = mean(model5_loading_dVdlnD_nref,2);
    model6_loading_dVdlnD_nref_avg = mean(model6_loading_dVdlnD_nref,2);
    %obs_dVdlnD_norm_nref_avg            = mean(obs_dVdlnD_norm_nref,2);
    model_ensemble_norm_nref_avg =   mean(model_ensemble_norm_nref,2);
    
    
    %4. normalize such that their integral over 0.1-20 um yields unity
    % function: integral of model output using bin method
    model1_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model1_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model2_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model2_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model3_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model3_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model4_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model4_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model5_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model5_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model6_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model6_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    
    %Normlization 
    model1_loading_dVdlnD_norm2_nref_avg = model1_loading_dVdlnD_nref_avg/model1_loading_dVdlnD_interal_norm2;
    model2_loading_dVdlnD_norm2_nref_avg = model2_loading_dVdlnD_nref_avg/model2_loading_dVdlnD_interal_norm2;
    model3_loading_dVdlnD_norm2_nref_avg = model3_loading_dVdlnD_nref_avg/model3_loading_dVdlnD_interal_norm2;
    model4_loading_dVdlnD_norm2_nref_avg = model4_loading_dVdlnD_nref_avg/model4_loading_dVdlnD_interal_norm2;
    model5_loading_dVdlnD_norm2_nref_avg = model5_loading_dVdlnD_nref_avg/model5_loading_dVdlnD_interal_norm2;
    model6_loading_dVdlnD_norm2_nref_avg = model6_loading_dVdlnD_nref_avg/model6_loading_dVdlnD_interal_norm2;
    
 %% split 0.1-10 bin into 0.2-0.5 and 0.5-1
    model1_dV = model1_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model2_dV = model2_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model3_dV = model3_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model4_dV = model4_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model5_dV = model5_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model6_dV = model6_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model_ensemble_dV = mean(model_ensemble_dV_nref,2);
    scheme_name1     = 'kok11';
    scheme_name      = 'kok_proposal_complex'; 
    model_bin_edge_new  = [0.2 0.5 1 2.5 5 10 14 20 28 40];   %9 bins
    model_ensemble_bin_edge_new = [0.2 0.5 1 2.5 5 10 14 20]; %7bins
    %function to split the first bin
    [model1_dVdlnD_norm_new]=f_split_first_bin(model1_dV, scheme_name1,f_l,edge_integral,model_bin_edge_new);
    [model2_dVdlnD_norm_new]=f_split_first_bin(model2_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    [model3_dVdlnD_norm_new]=f_split_first_bin(model3_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    [model4_dVdlnD_norm_new]=f_split_first_bin(model4_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    [model5_dVdlnD_norm_new]=f_split_first_bin(model5_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    [model6_dVdlnD_norm_new]=f_split_first_bin(model6_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    
    [model_ensemble_dVdlnD_norm_new]=f_split_first_bin(model_ensemble_dV, scheme_name1,f_l,edge_integral,model_ensemble_bin_edge_new);
%% plot the result 

   f_plot_fig4_wSubplots(obs_d, obs_dVdlnD_norm,...
                      model1_dVdlnD_norm_new,...
                      model2_dVdlnD_norm_new,...
                      model3_dVdlnD_norm_new,...
                      model4_dVdlnD_norm_new,...
                      model5_dVdlnD_norm_new,...
                      model6_dVdlnD_norm_new,...
                      model_ensemble_dVdlnD_norm_new,ensemble_bin_edg,...
                      nref,...
                      model_bin_edg,model_bin_edge_new,REFGroup,subplotlabel,f_l); 
end         

%% figure configurations 
   set(ha(1:4),'XTickLabel',''); 
   set(ha([2 4 6]),'YTickLabel','')


print(p,'-dpng','-r150',sprintf('%s/fig4_transportDust_wSubplots_lambda_%d',plotpath,f_l*100));
%print([figurepath,'Fig1_draft.png'],'-dpng');


