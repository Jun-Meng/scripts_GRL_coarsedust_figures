function [model3_dVdlnD_norm_new,model3_dV] =f_plot_fig1b_psd_compare_FreshDust(f_l)
% This scripts plot simulated atmospheric PSD and observations from fresh
% emitted observations
% B600/601/602/610
% for fig 1 (b) in the manuscript 

%% paths 
mainpath    = '/Users/jun-work/Desktop/UCLA';
datasetpath = sprintf('%s/datasets/',mainpath); 
sim_PSD     = sprintf('%s/datasets/model_output/model_PSD_new',mainpath);  

%% program inputs and constants 
CASES         = {'coarseD_kok11_new', 'coarseD_BFT_new', 'coarseD_BFT_B600_new'};
model_bin_edg = [0.1 1 2.5 5 10 14 20 28 40];
% calculate model bin spcing dlnD
for ii=1:(length(model_bin_edg)-1)
    model_bin_space_dlnD(ii) = log(model_bin_edg(ii+1)) - log(model_bin_edg(ii)); 
end
edge_integral =[0.1 20];    % size interval for normalization
YueConvert    = 1;
REF_NUMBER    = [600 601 602 610]; 

%% main
    %0 get the ratio due to the change of parameters in the parameterization
    [ratio_new_old_function] = f_calc_ratio_mass_fraction_new_old(f_l);
    
nr=0;
for nref = REF_NUMBER
    nr = nr+1;
    
    %1.read in measurements
    % -function: get the lat/lon info and observed dV/dlnD from flight averaged PSD from FENNEC 2011
    % this function will use the uncorverted PCASP data
    %[obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs,season_obs,ref_name]...
    %      = f_read_PSD_obs_Flights (datasetpath,nref,YueConvert);
    instrument = 'PCASPnCDP';
    [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs,season_obs,ref_name]...
          = f_read_PSD_obs_Flights_compare_conversion (datasetpath,nref,YueConvert,instrument);
    obs_dVdlnD_nref(:,nr)   = obs_dVdlnD; 
    % -function: integral of observation using bin method/ 
    % NOTE: INTEGRAL after average 
    %obs_dVdlnD_interal      = f_integral_obs_dV (datasetpath,nref,edge_integral,YueConvert) ;
    %[obs_dVdlnD_interal,obs_dlnD,obs_bin_edge] = f_integral_obs_dV_check(datasetpath,nref,edge_integral,YueConvert,instrument); 
    %obs_dVdlnD_norm_nref(:,nr)         = obs_dVdlnD/obs_dVdlnD_interal;
    
    %2.read in norm. model simulated PSD
    fname1 = sprintf('%s/PSD_dVdlnD_%s_ref%d.mat',sim_PSD,CASES{1},nref);  %kok2011
    fname2 = sprintf('%s/PSD_dVdlnD_%s_ref%d.mat',sim_PSD,CASES{2},nref);
    fname3 = sprintf('%s/PSD_dVdlnD_%s_ref%d.mat',sim_PSD,CASES{3},nref);
    load(fname1);
    load(fname2);
    load(fname3);
    % prepare for calculate the average
    model1_loading_dVdlnD_nref(:,nr) = model1_loading_dVdlnD;   %kok2011
    model2_loading_dVdlnD_nref(:,nr) = model2_loading_dVdlnD.*ratio_new_old_function';
    model3_loading_dVdlnD_nref(:,nr) = model3_loading_dVdlnD.*ratio_new_old_function';
    
    %3.read model ensemble from Yemi
    [model_ensemble_dVdlnD_norm,model_ensemble_dV,ensemble_bin_edg]=f_read_normalize_ensemble(datasetpath,edge_integral,nref);
    model_ensemble_norm_nref(:,nr) = model_ensemble_dVdlnD_norm;
    model_ensemble_dV_nref(:,nr) = model_ensemble_dV;
end
    model1_loading_dVdlnD_nref_avg = mean(model1_loading_dVdlnD_nref,2);
    model2_loading_dVdlnD_nref_avg = mean(model2_loading_dVdlnD_nref,2);
    model3_loading_dVdlnD_nref_avg = mean(model3_loading_dVdlnD_nref,2);
    %obs_dVdlnD_norm_nref_avg            = mean(obs_dVdlnD_norm_nref,2);
    obs_dVdlnD_nref_avg            = mean(obs_dVdlnD_nref,2);
    model_ensemble_norm_nref_avg =   mean(model_ensemble_norm_nref,2); %should do average first, then norma
    
    %3.5 normalize observation 
    [obs_integral,obs_dlnD,obs_edge] = f_integral_obs_dV(obs_d,obs_dVdlnD_nref_avg,edge_integral);
    obs_dVdlnD_norm     = obs_dVdlnD_nref_avg/obs_integral; 
    
    %4. normalize such that their integral over 0.1-20 um yields unity
    % function: integral of model output using bin method
    model1_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model1_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model2_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model2_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    model3_loading_dVdlnD_interal_norm2 = f_integral_model_dV(model3_loading_dVdlnD_nref_avg,model_bin_edg,edge_integral);
    %Normlization 
    model1_loading_dVdlnD_norm2_nref_avg = model1_loading_dVdlnD_nref_avg/model1_loading_dVdlnD_interal_norm2;
    model2_loading_dVdlnD_norm2_nref_avg = model2_loading_dVdlnD_nref_avg/model2_loading_dVdlnD_interal_norm2;
    model3_loading_dVdlnD_norm2_nref_avg = model3_loading_dVdlnD_nref_avg/model3_loading_dVdlnD_interal_norm2;
    
    %% split 0.1-10 bin into 0.2-0.5 and 0.5-1
    model1_dV = model1_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model3_dV = model3_loading_dVdlnD_nref_avg.*model_bin_space_dlnD';
    model_ensemble_dV = mean(model_ensemble_dV_nref,2);
    scheme_name1     = 'kok11';
    scheme_name      = 'kok_proposal_complex'; 
    model_bin_edge_new  = [0.2 0.5 1 2.5 5 10 14 20 28 40];   %9 bins
    model_ensemble_bin_edge_new = [0.2 0.5 1 2.5 5 10 14 20]; %7bins
    %function to split the first bin
    [model1_dVdlnD_norm_new]=f_split_first_bin(model1_dV, scheme_name1,f_l,edge_integral,model_bin_edge_new);
    [model3_dVdlnD_norm_new]=f_split_first_bin(model3_dV, scheme_name,f_l,edge_integral,model_bin_edge_new);
    [model_ensemble_dVdlnD_norm_new]=f_split_first_bin(model_ensemble_dV, scheme_name1,f_l,edge_integral,model_ensemble_bin_edge_new);

%% plot the result 
    
    % function: get model bin center for plotting x axis 
    [model1_bin_center,model_bin_space] = f_get_model_bincenter (model_bin_edg);
    [ensemble_bin_center,ensemble_bin_space] = f_get_model_bincenter (ensemble_bin_edg);
    [model_bin_center_new,model_bin_space] = f_get_model_bincenter (model_bin_edge_new);
    x1       = model1_bin_center;   %[0.55 1.75 3.65 7.5 12 17 24 34]
    x2       = ensemble_bin_center; %[0.55 1.75 3.65 7.5 12 17] 
    x3       = model_bin_center_new;
    
    %plot the modeled PSD
    p_cesm_origi = plot(x3(1:7),       model1_dVdlnD_norm_new(1:7),...
           'k-*','linewidth',2,'MarkerSize',8); hold on %  sim1, for kok11: only show below 20 microns 
    p_cesm_coarse = plot(x3,       model3_dVdlnD_norm_new,...
           'b->','linewidth',2.5,'MarkerSize',8); hold on %  sim3: with one-grid emission
   
    %plot the model ensemble 
    p_ensemble = plot(x3(1:7), model_ensemble_dVdlnD_norm_new,...
                 '-s','color',[0.5,0.5,0.5],'linewidth',1.5,'MarkerSize',8); hold on
  
    % plot observations PSD
    % ignore part of the submicron psd (d <0.5 um)
    obs_d           = obs_d(obs_d>0.3);  %(13:54)
    obs_dVdlnD_norm = obs_dVdlnD_norm(length(obs_dVdlnD_norm)-length(obs_d)+1:end) %(13:54)
    p_obs =plot(obs_d, obs_dVdlnD_norm,...
           'm-o','linewidth',2,'MarkerSize',8); hold on %  obs from flight average obs
       
    % add error bar (SD) for obs
    errorfile = sprintf('%s/insitu/psd_Ryder/2013ACP/SD_runs/SD_fresh.csv',datasetpath); 
    T         = readtable(errorfile,'PreserveVariableNames', true,'ReadVariableNames',0);
    obs_dVdlnD_norm_err     = T.Var1; %cellfun(@str2num,T.Var1); %pure numerical csv files, so no strings being read in
    obs_dVdlnD_norm_err = obs_dVdlnD_norm_err(13:54)
    
    
        for ii = 1:length(obs_d(:))
            tempx = [obs_d(ii), obs_d(ii)];
            tempy = [obs_dVdlnD_norm(ii), obs_dVdlnD_norm(ii)+obs_dVdlnD_norm_err(ii)];
            plot(tempx,tempy,'-','color','m','linewidth',0.8); hold on;
            %horizontal bar
            %tempx_h = [obs_d(ii)-exp(obs_d(ii)*2), obs_d(ii)+exp(obs_d(ii)*2)];
            %tempy_h = [obs_dVdlnD_norm(ii)+obs_dVdlnD_norm_err(ii), obs_dVdlnD_norm(ii)+obs_dVdlnD_norm_err(ii)];
            %plot(tempx_h,tempy_h,'-','color','m','linewidth',0.8); hold on;
        end   
    
    %add emission lines 
    %   Calculate Kok (2011) - fragmentation theory
        Ds = linspace(0.1,20,1000);
        Ds_avge = 3.4;
        Sigma = 3.0;
        lam = 12;
        cv = 12.62;
        JK_dvdlnd = Ds/cv.*(1+erf(log(Ds/Ds_avge)/sqrt(2)/log(Sigma))).*exp(-(Ds/lam).^3);    
    %   Calculate Jun Meng's new PSD results
        Ds_yue    = 1.1262; 
        sigma_yue = 1.9192;
        scheme_name      = 'kok_proposal_complex'; 
        sigma_agg = 2.95;  %2.824  / new  2.95
        D_agg_med = 127;   %140 um  / new 127 - median of the dry soil aggregates distribution, obtain this from OBS 127
        %f_l       = 0.1;   % ratio of DUST TO AGGGRE.This variable should also be a distribution
        Lamda     = 12;    % 

        % 1. f_clcu_mass_fraction_using_integral  (BFT expressions) 
        % - to get the normalization factor  "Cv_update" 
        [dVdD_func, Cv_update]  =  ...
        f_get_BFT_coarseD_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue,Lamda,f_l,scheme_name );   

        % 2. f_clcu_BFT_dVdlnD_subbin_method   (for plot out the line) 
        [D, dVdlnD]             =  ...
        f_get_BFT_dVdlnD_subbin_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue, Lamda,Cv_update,f_l,scheme_name);
        
        %plot the two emission lines 
        Ds = Ds(Ds<=20);
        %JK2011 = plot(Ds,JK_dvdlnd,'k-.','linewidth',1.5); hold on;  %Kok 2011 BFT emission line
        p_meng = plot(D, dVdlnD, 'b-.','linewidth',1.5); hold on; 



%% figure settings      
        set(gca,'xscale','log');
        set(gca,'yscale','log');
        xlim([0.2, 40]);
        ylim([10^(-3),3]);
        set(gca,'xtick',[0.2,1,10,20,40]);
        set(gca,'xticklabel',{'0.2','1','10','20','40'},'FontSize',16);
        set(gca,'ytick',[10^(-3),10^(-2),10^(-1),10^(0),2]);
        set(gca,'yticklabel',{'10^{-3}','10^{-2}','10^{-1}','10^{0}','2'},'FontSize',16);
        %set(gca,'box','off');

        xlabel('Dust geometric diameter \itD (\rm\bf\mum)','FontSize',20,'FontWeight','bold');
        ylabel('Normalized volume size distribution, d{\itV}/dln\itD','FontSize',20,'FontWeight','bold');
    
    
        the=legend([p_obs, p_cesm_origi,p_cesm_coarse,p_ensemble, p_meng],...
             'In situ measurements',...
             'CESM (BFT-original)',...
             'CESM (BFT-supercoarse)',...
             'Model ensemble',...
             'BFT-supercoarse emitted dust PSD');
         set(the,'location','southeast','FontSize',18,'FontWeight','bold');
         set(the,'color','none');

%% print measurements' information in the plot 
       date_t = 'June 17-25, 2011'; height_t = 'Below 1000m above sea level'; Catg = 'Freshly uplifted dust in Mali and Mauritania'; 
       SW0 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 350*diff(ylim)]*0.001;
       text(SW0(1), SW0(2),Catg,'VerticalAlignment','bottom', 'HorizontalAlignment','left','FontSize',20,'color','m','FontWeight','bold') 
       SW = [min(xlim) min(ylim)]+[0.8*diff(xlim) 200*diff(ylim)]*0.001;
       text(SW(1), SW(2),date_t,'VerticalAlignment','bottom', 'HorizontalAlignment','left','FontSize',16,'FontWeight','bold')
       SW2 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 140*diff(ylim)]*0.001;
       text(SW2(1), SW2(2),height_t,'VerticalAlignment','bottom', 'HorizontalAlignment','left','FontSize',16,'FontWeight','bold')

end                




