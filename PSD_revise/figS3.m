%%  This scripts plot (a) the simulated dust PSD for fresh dust, compare gridbox emission
%                     (b) the simulated dust PSD for fresh dust, compare different temporal match samples
% For figS3 in the manuscript 
% Jun Meng, Oct. 18th 2021


clearvars;
clc;
%close all;

%% paths 
mainpath    = '/Users/jun-work/Desktop/UCLA';
addpath('/Users/jun-work/Desktop/UCLA/code_plots_GRL_revise/PSD_revise/functions/'); % Add path for MATLAB addons
plotpath    = sprintf('%s/plots/paper1_revised/',mainpath);
datasetpath = sprintf('%s/datasets/',mainpath); 
sim_PSD     = sprintf('%s/datasets/model_output/model_PSD_new',mainpath);  

%% figure frame
p  = figure;
set(p,'position',[300 200 1400 600]);
subplotlabel = {' a ',' b '};
% add tight subplot 
ha = tight_subplot(1,2,[.01 .07],[.1 .01],[.05 .01]);
%        gap     gaps between the axes in normalized units (0...1)
%                   or [gap_h gap_w] for different gaps in height and width 
%        marg_h  margins in height in normalized units (0...1)
%                   or [lower upper] for different lower and upper margins 
%        marg_w  margins in width in normalized units (0...1)
%                   or [left right] for different left and right margins 

%% subplot (a)  compare gridbox 
axes(ha(1));

%% program inputs and constants 
    CASES         = {'coarseD_BFT_new'};
    model_bin_edg = [0.1 1 2.5 5 10 14 20 28 40];
    % calculate model bin spcing dlnD
    for ii=1:(length(model_bin_edg)-1)
        model_bin_space_dlnD(ii) = log(model_bin_edg(ii+1)) - log(model_bin_edg(ii)); 
    end
    edge_integral =[0.1 20];    % size interval for normalization
    YueConvert    = 1;
    REF_NUMBER    = [600 601 602 610]; 
    f_l           = 0.15;    %modified during revision period from 0.1 to 0.15
%% main
   
    %0 get the ratio due to the change of parameters in the parameterization
    [ratio_new_old_function] = f_calc_ratio_mass_fraction_new_old(f_l);
    
    nr=0;
    for nref = REF_NUMBER
        nr = nr+1;

        %1.read in measurements
        % -function: get the lat/lon info and observed dV/dlnD from flight averaged PSD from FENNEC 2011
        %[obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs,season_obs,ref_name]...
        %     = f_read_PSD_obs_Flights (datasetpath,nref,YueConvert);
          
        instrument = 'PCASPnCDP';
        [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs,season_obs,ref_name]...
          = f_read_PSD_obs_Flights_compare_conversion (datasetpath,nref,YueConvert,instrument);
        obs_dVdlnD_nref(:,nr)   = obs_dVdlnD; 
        % -function: integral of observation using bin method
        %obs_dVdlnD_interal      = f_integral_obs_dV (datasetpath,nref,edge_integral,YueConvert) ;
        %obs_dVdlnD_interal = f_integral_obs_dV_compare_conversion (datasetpath,nref,edge_integral,YueConvert,instrument); 
        %obs_dVdlnD_norm_nref(:,nr)         = obs_dVdlnD/obs_dVdlnD_interal;
        ref_name_new = ' B600-602 & B610';

        %2.read in norm. model simulated PSD
        fname1 = sprintf('%s/PSD_dVdlnD_%s_ref%d_daytime.mat',sim_PSD,CASES{1},nref);
        fname2 = sprintf('%s/PSD_dVdlnD_%s_ref%d_day24h.mat',sim_PSD,CASES{1},nref);
        fname3 = sprintf('%s/PSD_dVdlnD_%s_ref%d_month.mat',sim_PSD,CASES{1},nref);
        fname4 = sprintf('%s/PSD_dVdlnD_%s_ref%d_season.mat',sim_PSD,CASES{1},nref);
        load(fname1);
        load(fname2);
        load(fname3);
        load(fname4);
        % prepare for calculate the average
        model1_loading_dVdlnD_nref(:,nr) = model1_loading_dVdlnD.*ratio_new_old_function';
        model2_loading_dVdlnD_nref(:,nr) = model2_loading_dVdlnD.*ratio_new_old_function';
        model3_loading_dVdlnD_nref(:,nr) = model3_loading_dVdlnD.*ratio_new_old_function';
        model4_loading_dVdlnD_nref(:,nr) = model4_loading_dVdlnD.*ratio_new_old_function';
    end
    model1_loading_dVdlnD_nref_avg = mean(model1_loading_dVdlnD_nref,2);
    model2_loading_dVdlnD_nref_avg = mean(model2_loading_dVdlnD_nref,2);
    model3_loading_dVdlnD_nref_avg = mean(model3_loading_dVdlnD_nref,2);
    model4_loading_dVdlnD_nref_avg = mean(model4_loading_dVdlnD_nref,2);
    %obs_dVdlnD_norm_nref_avg            = mean(obs_dVdlnD_norm_nref,2);
    obs_dVdlnD_nref_avg            = mean(obs_dVdlnD_nref,2);
    %3.5 normalize observation 
    [obs_integral,obs_dlnD,obs_edge] = f_integral_obs_dV(obs_d,obs_dVdlnD_nref_avg,edge_integral);
    obs_dVdlnD_norm     = obs_dVdlnD_nref_avg/obs_integral; 

    %4. normalize such that their integral over 0.1-20 um yields unity
    % function: integral of model output using bin method
    model1_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model1_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model2_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model2_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model3_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model3_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model4_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model4_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    
    %Normlization 
    model1_loading_dVdlnD_norm2_nref_avg = model1_loading_dVdlnD_nref_avg/model1_loading_dVdlnD_interal_norm2;
    model2_loading_dVdlnD_norm2_nref_avg = model2_loading_dVdlnD_nref_avg/model2_loading_dVdlnD_interal_norm2;
    model3_loading_dVdlnD_norm2_nref_avg = model3_loading_dVdlnD_nref_avg/model3_loading_dVdlnD_interal_norm2;
    model4_loading_dVdlnD_norm2_nref_avg = model4_loading_dVdlnD_nref_avg/model4_loading_dVdlnD_interal_norm2;

 %% split 0.1-10 bin into 0.2-0.5 and 0.5-1
    model1_dV = model1_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model2_dV = model2_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model3_dV = model3_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model4_dV = model4_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    scheme_name1     = 'kok11';
    scheme_name      = 'kok_proposal_complex'; 
    model_bin_edge_new  = [0.2 0.5 1 2.5 5 10 14 20 28 40];   %9 bins
    %function to split the first bin
    [model1_dVdlnD_norm_new]=f_split_first_bin(model1_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    [model2_dVdlnD_norm_new]=f_split_first_bin(model2_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    [model3_dVdlnD_norm_new]=f_split_first_bin(model3_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    [model4_dVdlnD_norm_new]=f_split_first_bin(model4_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);

%% plot the result (b)
    f_plot_fig2Sb(obs_d, obs_dVdlnD_norm,...
                      model1_dVdlnD_norm_new,...
                      model2_dVdlnD_norm_new,...
                      model3_dVdlnD_norm_new,...
                      model4_dVdlnD_norm_new,...
                      plotpath,ref_name_new,...
                      model_bin_edg,model_bin_edge_new,YueConvert); 

    %location of the subplot label
    SW3 = [min(xlim) min(ylim)]+[0.2*diff(xlim) 0.2*diff(ylim)]*0.001;
    text(SW3(1), SW3(2),subplotlabel{1},'EdgeColor','k','VerticalAlignment','bottom', ...
           'HorizontalAlignment','left','FontSize',40,'FontWeight','bold')  
     %location of the subplot label
    SW4 = [min(xlim) min(ylim)]+[13*diff(xlim) 4*diff(ylim)]*0.001;
    text(SW4(1), SW4(2),'simulation with dust emission from all grid boxes','VerticalAlignment','bottom', ...
                       'HorizontalAlignment','left','FontSize',19,'FontWeight','bold')  

                   
                   
                   
%% subplot (b) compare diffMatch sampling 
axes(ha(2));

%% program inputs and constants 
    CASES         = {'coarseD_BFT_B600_new'};
    model_bin_edg = [0.1 1 2.5 5 10 14 20 28 40];
    edge_integral =[0.1 20];    % size interval for normalization
    YueConvert    = 1;
    REF_NUMBER    = [600 601 602 610]; 

%% main
    
    nr=0;
    for nref = REF_NUMBER
        nr = nr+1;

        %1.read in measurements
        % -function: get the lat/lon info and observed dV/dlnD from flight averaged PSD from FENNEC 2011
        %[obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs,season_obs,ref_name]...
        %     = f_read_PSD_obs_Flights (datasetpath,nref,YueConvert);
          
        instrument = 'PCASPnCDP';
        [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs,season_obs,ref_name]...
          = f_read_PSD_obs_Flights_compare_conversion (datasetpath,nref,YueConvert,instrument);
        obs_dVdlnD_nref(:,nr)   = obs_dVdlnD; 
        % -function: integral of observation using bin method
        %obs_dVdlnD_interal      = f_integral_obs_dV (datasetpath,nref,edge_integral,YueConvert) ;
        %obs_dVdlnD_interal = f_integral_obs_dV_compare_conversion (datasetpath,nref,edge_integral,YueConvert,instrument); 
        %obs_dVdlnD_norm_nref(:,nr)         = obs_dVdlnD/obs_dVdlnD_interal;
        ref_name_new = ' B600-602 & B610';

        %2.read in norm. model simulated PSD
        fname1 = sprintf('%s/PSD_dVdlnD_%s_ref%d_daytime.mat',sim_PSD,CASES{1},nref);
        fname2 = sprintf('%s/PSD_dVdlnD_%s_ref%d_day24h.mat',sim_PSD,CASES{1},nref);
        fname3 = sprintf('%s/PSD_dVdlnD_%s_ref%d_month.mat',sim_PSD,CASES{1},nref);
        fname4 = sprintf('%s/PSD_dVdlnD_%s_ref%d_season.mat',sim_PSD,CASES{1},nref);
        load(fname1);
        load(fname2);
        load(fname3);
        load(fname4);
        % prepare for calculate the average
        model1_loading_dVdlnD_nref(:,nr) = model1_loading_dVdlnD.*ratio_new_old_function';
        model2_loading_dVdlnD_nref(:,nr) = model2_loading_dVdlnD.*ratio_new_old_function';
        model3_loading_dVdlnD_nref(:,nr) = model3_loading_dVdlnD.*ratio_new_old_function';
        model4_loading_dVdlnD_nref(:,nr) = model4_loading_dVdlnD.*ratio_new_old_function';
    end
    model1_loading_dVdlnD_nref_avg = mean(model1_loading_dVdlnD_nref,2);
    model2_loading_dVdlnD_nref_avg = mean(model2_loading_dVdlnD_nref,2);
    model3_loading_dVdlnD_nref_avg = mean(model3_loading_dVdlnD_nref,2);
    model4_loading_dVdlnD_nref_avg = mean(model4_loading_dVdlnD_nref,2);
    %obs_dVdlnD_norm_nref_avg            = mean(obs_dVdlnD_norm_nref,2);
    obs_dVdlnD_nref_avg            = mean(obs_dVdlnD_nref,2);
    %3.5 normalize observation 
    [obs_integral,obs_dlnD,obs_edge] = f_integral_obs_dV(obs_d,obs_dVdlnD_nref_avg,edge_integral);
    obs_dVdlnD_norm     = obs_dVdlnD_nref_avg/obs_integral; 

    %4. normalize such that their integral over 0.1-20 um yields unity
    % function: integral of model output using bin method
    model1_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model1_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model2_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model2_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model3_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model3_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model4_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model4_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    
    %Normlization 
    model1_loading_dVdlnD_norm2_nref_avg = model1_loading_dVdlnD_nref_avg/model1_loading_dVdlnD_interal_norm2;
    model2_loading_dVdlnD_norm2_nref_avg = model2_loading_dVdlnD_nref_avg/model2_loading_dVdlnD_interal_norm2;
    model3_loading_dVdlnD_norm2_nref_avg = model3_loading_dVdlnD_nref_avg/model3_loading_dVdlnD_interal_norm2;
    model4_loading_dVdlnD_norm2_nref_avg = model4_loading_dVdlnD_nref_avg/model4_loading_dVdlnD_interal_norm2;

 %% split 0.1-10 bin into 0.2-0.5 and 0.5-1
    model1_dV = model1_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model2_dV = model2_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model3_dV = model3_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model4_dV = model4_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    scheme_name1     = 'kok11';
    scheme_name      = 'kok_proposal_complex'; 
    model_bin_edge_new  = [0.2 0.5 1 2.5 5 10 14 20 28 40];   %9 bins
    %function to split the first bin
    [model1_dVdlnD_norm_new]=f_split_first_bin(model1_dV, scheme_name,f_l,edge_integral,model_bin_edge_new)
    [model2_dVdlnD_norm_new]=f_split_first_bin(model2_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    [model3_dVdlnD_norm_new]=f_split_first_bin(model3_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    [model4_dVdlnD_norm_new]=f_split_first_bin(model4_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);

%% plot the result (b)
    f_plot_fig2Sb(obs_d, obs_dVdlnD_norm,...
                      model1_dVdlnD_norm_new,...
                      model2_dVdlnD_norm_new,...
                      model3_dVdlnD_norm_new,...
                      model4_dVdlnD_norm_new,...
                      plotpath,ref_name_new,...
                      model_bin_edg,model_bin_edge_new,YueConvert); 

    %location of the subplot label
    SW3 = [min(xlim) min(ylim)]+[0.2*diff(xlim) 0.2*diff(ylim)]*0.001;
    text(SW3(1), SW3(2),subplotlabel{2},'EdgeColor','k','VerticalAlignment','bottom', ...
                       'HorizontalAlignment','left','FontSize',40,'FontWeight','bold')                   
    %location of the subplot label
    SW4 = [min(xlim) min(ylim)]+[40*diff(xlim) 4*diff(ylim)]*0.001;
    text(SW4(1), SW4(2),'dust emission from only local grid box','VerticalAlignment','bottom', ...
                       'HorizontalAlignment','left','FontSize',19,'FontWeight','bold')               
print(p,'-dpng','-r150',sprintf('%s/figS3_freshDust_allDust_diffMatch',plotpath));
%print([figurepath,'Fig1_draft.png'],'-dpng');


