function  f_plot_fig2Sb(obs_d, obs_dVdlnD_norm,...
                  model1_loading_dVdlnD_norm,model2_loading_dVdlnD_norm,...
                  model3_loading_dVdlnD_norm,...
                  model4_loading_dVdlnD_norm,...
                  Dir_saveplots,flight_name,...
                  model_bin_edg,model_bin_edg_new,YueConvert)
              
 % this script is for the fresh uplifted dust / function for fig2

 % this function is to plot the simulated dV/dlnD and observed dV/dlnD

   
    % function: get model bin center for plotting x axis 
    [model1_bin_center,model_bin_space] = f_get_model_bincenter (model_bin_edg);
    [model1_bin_center_new,model_bin_space] = f_get_model_bincenter (model_bin_edg_new);
    %[ensemble_bin_center,ensemble_bin_space] = f_get_model_bincenter (ensemble_bin_edg);
    x1       = model1_bin_center;   %[0.55 1.75 3.65 7.5 12 17 24 34]
    % x2       = ensemble_bin_center; %[0.55 1.75 3.65 7.5 12 17] 
    x3       = model1_bin_center_new; 
    %% plot the modeled PSD
    plot(x3,       model1_loading_dVdlnD_norm,...
           '->','color',[0,0,1],'linewidth',2.5,'MarkerSize',8); hold on %  sim1, 
    plot(x3,       model2_loading_dVdlnD_norm,...
           'c-d','linewidth',1.5,'MarkerSize',8); hold on %  sim2:
    plot(x3,       model3_loading_dVdlnD_norm,...
           '-*','color',[0.5,0.5,1],'linewidth',1.5,'MarkerSize',8); hold on %  sim3: monthly
    plot(x3,       model4_loading_dVdlnD_norm,...
           'k-s','color',[0.5,0.5,0.5],'linewidth',1.5,'MarkerSize',8); hold on %  sim4: seasonally
   
    %% plot the model ensemble 
    %plot(x2, model_ensemble_dVdlnD_norm,...
    %             '-*','color',[0.5,0.5,0.5],'linewidth',1.5); hold on
  
    %% plot observations PSD
    % ignore part of the submicron psd (d <0.5 um)
    obs_d           = obs_d(obs_d>0.3);
    obs_dVdlnD_norm = obs_dVdlnD_norm(length(obs_dVdlnD_norm)-length(obs_d)+1:end);
    plot(obs_d, obs_dVdlnD_norm,...
           'm-o','linewidth',1.5,'MarkerSize',8); hold on %  obs from flight average obs
    
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
        f_l       = 0.15;   % ratio of DUST TO AGGGRE.This variable should also be a distribution
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
        ylim([10^(-3),3]);
        set(gca,'xtick',[0.2,1,10,20,40]);
        set(gca,'xticklabel',{'0.2','1','10','20','40'},'FontSize',16);
        set(gca,'ytick',[10^(-3),10^(-2),10^(-1),10^(0),2]);
        set(gca,'yticklabel',{'10^{-3}','10^{-2}','10^{-1}','10^{0}','2'},'FontSize',16);
        %set(gca,'box','off');

        xlabel('Dust geometric diameter \itD (\rm\bf\mum)','FontSize',20,'FontWeight','bold');
        ylabel('Normalized volume size distribution, d{\itV}/dln\itD','FontSize',20,'FontWeight','bold');
    
    
        the=legend('CESM (BFT-supercoarse); daytime avg.',...
                   'CESM (BFT-supercoarse); 24h avg.',...
                   'CESM (BFT-supercoarse); monthly avg.',...
                   'CESM (BFT-supercoarse); seasonal avg.',...
             ...%strcat('Observation PSD:  ',flight_name),...
             'In situ measurements',...
             'BFT-supercoarse emitted dust PSD');
         set(the,'location','southeast','FontSize',21,'FontWeight','bold');
         set(the,'color','none');

  
    
    %% print measurements' information in the plot 
       date_t = 'June 17-25, 2011'; height_t = 'Below 1000m ASL'; Catg = 'Freshly uplifted dust (FENNEC 2011)'; 
       SW0 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 400*diff(ylim)]*0.001;
       text(SW0(1), SW0(2),Catg,'VerticalAlignment','bottom', 'HorizontalAlignment','left','FontSize',28,'color','m','FontWeight','bold') 
       SW = [min(xlim) min(ylim)]+[0.8*diff(xlim) 200*diff(ylim)]*0.001;
       text(SW(1), SW(2),date_t,'VerticalAlignment','bottom', 'HorizontalAlignment','left','FontSize',18,'FontWeight','bold')
       SW2 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 130*diff(ylim)]*0.001;
       text(SW2(1), SW2(2),height_t,'VerticalAlignment','bottom', 'HorizontalAlignment','left','FontSize',18,'FontWeight','bold')
   

   
end