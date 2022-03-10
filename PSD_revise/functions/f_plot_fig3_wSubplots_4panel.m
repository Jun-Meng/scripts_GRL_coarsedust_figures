function  f_plot_fig3_wSubplots_4panel(obs_d, obs_dVdlnD_norm,...
                  model1_loading_dVdlnD_norm,model2_loading_dVdlnD_norm,...
                  model_ensemble_dVdlnD_norm,ensemble_bin_edg,...
                  flight_name,nref,...
                  model_bin_edg,model_bin_edge_new,REFGroup,subplotlabel,f_l,datasetpath)
 %% this function is to plot the simulated dV/dlnD and observed dV/dlnD
 % this function is for separately plotting the 5 set simulations against refs: 
 % mean of [605 606]         for cold pool Atlas 
 % mean of [609 611 612 613] for aged dust 
 % 6652000 6692000     2000 m 
 % 6654000 6694000     4000 m 
    %%
    
    
    % function: get model bin center for plotting x axis 
    [model1_bin_center,     model_bin_space] = f_get_model_bincenter (model_bin_edg);
    [model_bin_center_new,     model_bin_space] = f_get_model_bincenter (model_bin_edge_new);
    [ensemble_bin_center,ensemble_bin_space] = f_get_model_bincenter (ensemble_bin_edg);
    x1       = model1_bin_center;   %[0.55 1.75 3.65 7.5 12 17 24 34]
    x2       = ensemble_bin_center; %[0.55 1.75 3.65 7.5 12 17] 
    x3       = model_bin_center_new;
    
    %% plot the modeled PSD
    p_cesm_origi = plot(x3(1:7),       model1_loading_dVdlnD_norm(1:7),...
           'k-*','linewidth',1.5); hold on %  sim1, for kok11: only show below 20 microns 
    p_cesm_coarse = plot(x3,       model2_loading_dVdlnD_norm,...
           'b->','linewidth',1.5); hold on %  sim2
   
    %% plot the model ensemble 
    p_ensemble = plot(x3(1:7), model_ensemble_dVdlnD_norm,...
                 '-s','color',[0.5,0.5,0.5],'linewidth',1.5); hold on
             
    %% plot observations PSD
    % ignore part of the submicron psd (d <0.5 um)
    obs_d           = obs_d(obs_d>0.3);
    obs_dVdlnD_norm = obs_dVdlnD_norm(length(obs_dVdlnD_norm)-length(obs_d)+1:end);
    p_obs = plot(obs_d, obs_dVdlnD_norm,...
           'm-o','linewidth',1.5); hold on %  obs from flight average obs
       
    % add error bar (SD) for obs
    if REFGroup==1
        errorfile = sprintf('%s/insitu/psd_Ryder/2013ACP/SD_runs/SD_age_atlas_low.csv',datasetpath);
    elseif REFGroup==2
        errorfile = sprintf('%s/insitu/psd_Ryder/2013ACP/SD_runs/SD_age_mauri_low.csv',datasetpath);
    elseif REFGroup==3
        errorfile = sprintf('%s/insitu/psd_Ryder/2013ACP/SD_runs/SD_age_atlas_high.csv',datasetpath);
    elseif REFGroup==4
        errorfile = sprintf('%s/insitu/psd_Ryder/2013ACP/SD_runs/SD_age_mauri_high.csv',datasetpath);
    end
    T         = readtable(errorfile,'PreserveVariableNames', true,'ReadVariableNames',0);
    obs_dVdlnD_norm_err     = T.Var1; %cellfun(@str2num,T.Var1); %pure numerical csv files, so no strings being read in
    obs_dVdlnD_norm_err = obs_dVdlnD_norm_err(13:54)


    for ii = 1:length(obs_d(:))
        tempx = [obs_d(ii), obs_d(ii)];
        tempy = [obs_dVdlnD_norm(ii), obs_dVdlnD_norm(ii)+obs_dVdlnD_norm_err(ii)];
        plot(tempx,tempy,'-','color','m','linewidth',0.8); hold on;
        %horizontal bar?
        %tempx_h = [obs_d(ii)-exp(obs_d(ii)*2), obs_d(ii)+exp(obs_d(ii)*2)];
        %tempy_h = [obs_dVdlnD_norm(ii)+obs_dVdlnD_norm_err(ii), obs_dVdlnD_norm(ii)+obs_dVdlnD_norm_err(ii)];
        %plot(tempx_h,tempy_h,'-','color','m','linewidth',0.8); hold on;
    end  

       
    %% add emission lines 
    % Calculate Kok (2011) - fragmentation theory
        Ds = linspace(0.1,20,1000);
        Ds_avge = 3.4;
        Sigma = 3.0;
        lam = 12;
        cv = 12.62;
        JK_dvdlnd = Ds/cv.*(1+erf(log(Ds/Ds_avge)/sqrt(2)/log(Sigma))).*exp(-(Ds/lam).^3);    
     % Calculate Jun Meng's new PSD results
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
        %ylim([1e-4,10]);
        xlim([0.2, 40]);
%         ylim([10^(-4),3]);
        ylim([10^(-3),3]);
        
        if REFGroup==3
            set(gca,'xtick',[0.2,1,10,20,30]);
            set(gca,'xticklabel',{'0.2','1','10','20','30'},'FontSize',14);
        else
            set(gca,'xtick',[0.2,1,10,20,40]);
            set(gca,'xticklabel',{'0.2','1','10','20','40'},'FontSize',14);
        end
        %set(gca,'ytick',[10^(-4),10^(-3),10^(-2),10^(-1),10^(0),2]);
        %set(gca,'yticklabel',{'10^{-4}','10^{-3}','10^{-2}','10^{-1}','10^{0}','2'},'FontSize',13);
        set(gca,'ytick',[10^(-3),10^(-2),10^(-1),10^(0),2]);
        set(gca,'yticklabel',{'10^{-3}','10^{-2}','10^{-1}','10^{0}','2'},'FontSize',13);
        
        %set(gca,'box','off');
        
        if REFGroup==3 || REFGroup==4
            xlabel('Dust geometric diameter \itD (\rm\bf\mum)','FontSize',16,'FontWeight','bold');
        end
        if REFGroup==1 || REFGroup==3 %|| REFGroup==5
            ylabel('Norm. vol. size distr., d{\itV}/dln\itD','FontSize',16,'FontWeight','bold');
        end
        if REFGroup==1
            the=legend([p_obs, p_cesm_origi,p_cesm_coarse,p_ensemble, p_meng],...
             'In situ measurements',...
             'CESM (BFT-original)',...
             'CESM (BFT-supercoarse)',...
             'Model ensemble',...
             'BFT-supercoarse emitted dust PSD');
         set(the,'location','southeast','FontSize',16,'FontWeight','bold');
         set(the,'color','none');
        end
         
    %% print measurements' information in the plot
        if nref == 6652000 
            date_t = 'June 21, 2011'; height_t = '~ 2000m above sea level';  Catg = 'Aged  dust (cold pool Atlas) ';
        elseif nref == 6653000
            date_t = 'June 21, 2011'; height_t = '~ 3000m above sea level';  Catg = 'Aged  dust (cold pool Atlas) ';
        elseif nref == 6654000
            date_t = 'June 21, 2011'; height_t = '~ 2000-4000m above sea level';  Catg = 'Aged  dust (cold pool Atlas) ';
        elseif nref == 6692000
            date_t = 'June 24-26, 2011'; height_t = '~ 2000m above sea level';  Catg = 'Aged  dust (Mauritania) ';
        elseif nref == 6693000
            date_t = 'June 24-26, 2011'; height_t = '~ 3000m above sea level';  Catg = 'Aged  dust (Mauritania) ';
        elseif nref == 6694000
            date_t = 'June 24-26, 2011'; height_t = '~ 2000-4000m above sea level';  Catg = 'Aged  dust (Mauritania) ';
        elseif nref == 665   %group [605 606]
            date_t = 'June 21, 2011'; height_t = 'Below 500m above sea level';  Catg = 'Aged  dust (cold pool Atlas) ';
        elseif nref == 669   %group [609 611 612 613] 
            date_t = 'June 24-26, 2011'; height_t = 'Below 500m above sea level';  Catg = 'Aged  dust (Mauritania) ';	
        end 

   
    
       SW0 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 400*diff(ylim)]*0.001;
       text(SW0(1), SW0(2),Catg,'VerticalAlignment','bottom', 'HorizontalAlignment','left','color','m','FontSize',14,'FontWeight','bold')    
       SW = [min(xlim) min(ylim)]+[0.8*diff(xlim) 200*diff(ylim)]*0.001;
       text(SW(1), SW(2),date_t,'VerticalAlignment','bottom', 'HorizontalAlignment','left','FontSize',12,'FontWeight','bold')
       SW2 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 120*diff(ylim)]*0.001;
       text(SW2(1), SW2(2),height_t,'VerticalAlignment','bottom', 'HorizontalAlignment','left','FontSize',12,'FontWeight','bold')
       %location of the subplot label
       SW3 = [min(xlim) min(ylim)]+[600*diff(xlim) 400*diff(ylim)]*0.001;
       text(SW3(1), SW3(2),subplotlabel{REFGroup},'EdgeColor','k','VerticalAlignment','bottom', ...
                   'HorizontalAlignment','left','FontSize',24,'FontWeight','bold') 
               
       %location of the lambda (temporary showing)
%        if REFGroup==6
%        SW4 = [min(xlim) min(ylim)]+[8*diff(xlim) 0.05*diff(ylim)]*0.001;
%        text_lanbda = sprintf('Lambda = %0.2f',f_l);
%        text(SW4(1), SW4(2),text_lanbda,'VerticalAlignment','bottom', ...
%                        'HorizontalAlignment','left','FontSize',24,'FontWeight','bold') 
%        end
end