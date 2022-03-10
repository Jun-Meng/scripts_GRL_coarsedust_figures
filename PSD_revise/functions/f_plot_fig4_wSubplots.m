function  f_plot_fig4_wSubplots(obs_d, obs_dVdlnD_norm,...
                  model1_loading_dVdlnD_norm,model2_loading_dVdlnD_norm,...
                  model3_loading_dVdlnD_norm, model4_loading_dVdlnD_norm,...
                  model5_loading_dVdlnD_norm, model6_loading_dVdlnD_norm,... 
                  model_ensemble_dVdlnD_norm,ensemble_bin_edg,...
                  nref,...
                  model_bin_edg,model_bin_edge_new,REFGroup,subplotlabel,f_l)

 %% this function is to plot the simulated dV/dlnD and observed dV/dlnD
 % this function is for separately plotting the 5 set simulations against refs: 
 %         7/8 southern portugal 2300/3200m
 %         22/23 canary island  2000m/4000m
 %         16/17 CV/BD  2000m 
    
    
    % function: get model bin center for plotting x axis 
    [model1_bin_center,model_bin_space] = f_get_model_bincenter (model_bin_edg);
    [model_bin_center_new,     model_bin_space] = f_get_model_bincenter (model_bin_edge_new);
    [ensemble_bin_center,ensemble_bin_space] = f_get_model_bincenter (ensemble_bin_edg);
    x1       = model1_bin_center;   %[0.55 1.75 3.65 7.5 12 17 24 34]
    x2       = ensemble_bin_center; %[0.55 1.75 3.65 7.5 12 17] 
    x3       = model_bin_center_new; 
   
    
    %% plot the modeled PSD
    
    %plot(x1(1:6),       model1_loading_dVdlnD_norm(1:6),...
    %       'k-*','linewidth',1.5); hold on %  sim1: only show under 20um for kok11
    p_cesm_coarse = plot(x3,       model2_loading_dVdlnD_norm,...
           'b->','linewidth',1.5); hold on %  sim2
      % orange-like colors
%     p_cesm_coarse1000 =plot(x1,       model3_loading_dVdlnD_norm,...
%            '-*','color',[217/255,95/255,14/255],'linewidth',1.5); hold on %  sim3
%     p_cesm_coarse500 = plot(x1,       model4_loading_dVdlnD_norm,...
%            '-*','color',[254/255,160/255,70/255],'linewidth',1.5); hold on %  sim4
%     p_cesm_coarse250 = plot(x1,       model5_loading_dVdlnD_norm,...
%            '-*','color',[255/255,230/255,140/255],'linewidth',1.5); hold on %  sim5
      % color with different grayness- increase read bility 
    p_cesm_coarse1000 =plot(x3,       model3_loading_dVdlnD_norm,...
           '-*','color',[113/255,80/255,0/255],'linewidth',1.5); hold on %  sim3
    p_cesm_coarse500 = plot(x3,       model4_loading_dVdlnD_norm,...
           '-*','color',[195/255,120/255,26/255],'linewidth',1.5); hold on %  sim4
    p_cesm_coarse250 = plot(x3,       model5_loading_dVdlnD_norm,...
           '-*','color',[255/255,189/255,104/255],'linewidth',1.5); hold on %  sim5  rho = 250
    p_cesm_coarse125 = plot(x3,       model6_loading_dVdlnD_norm,...
           '-*','color',[255/255,230/255,150/255],'linewidth',1.5); hold on %  sim6   rho = 125
       
    %% plot the model ensemble 
    p_ensemble = plot(x3(1:7), model_ensemble_dVdlnD_norm,...
                 '-s','color',[0.5,0.5,0.5],'linewidth',1.5); hold on   
    %% plot observations PSD
    % ignore part of the submicron psd (d <0.5 um)
    obs_d           = obs_d(obs_d>0.3);
    obs_dVdlnD_norm = obs_dVdlnD_norm(length(obs_dVdlnD_norm)-length(obs_d)+1:end);
    p_obs = plot(obs_d, obs_dVdlnD_norm,...
        'm-o','linewidth',1.5); hold on %  obs from flight average obs
   
  
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
        %p_meng = plot(D, dVdlnD, 'b-.','linewidth',1.5); hold on; 
        
     %% figure settings
        set(gca,'xscale','log');
        set(gca,'yscale','log');
        %ylim([1e-4,10]);
        xlim([0.2, 40]);
        ylim([10^(-4),3]);
        if REFGroup==5
            set(gca,'xtick',[0.2,1,10,20,30]);
            set(gca,'xticklabel',{'0.2','1','10','20','30'},'FontSize',14);
        else
            set(gca,'xtick',[0.2,1,10,20,40]);
            set(gca,'xticklabel',{'0.2','1','10','20','40'},'FontSize',14);
        end
        set(gca,'ytick',[10^(-4),10^(-3),10^(-2),10^(-1),10^(0),2]);
        set(gca,'yticklabel',{'10^{-4}','10^{-3}','10^{-2}','10^{-1}','10^{0}','2'},'FontSize',13);
        %set(gca,'box','off');
 
        if REFGroup==5 || REFGroup==6
            xlabel('Dust geometric diameter \itD (\rm\bf\mum)','FontSize',16,'FontWeight','bold');
        end
        if REFGroup==1 || REFGroup==3 || REFGroup==5
            ylabel('Norm. vol. size distr., d{\itV}/dln\itD','FontSize',13,'FontWeight','bold');
        end
        
    
        if REFGroup==1
             the=legend([p_obs, p_cesm_coarse, p_cesm_coarse1000,p_cesm_coarse500,p_cesm_coarse250,p_cesm_coarse125, p_ensemble],...
             'In situ measurements',...
             'CESM (BFT-supercoarse)',...
             'CESM (BFT-supercoarse) with \rho = 1000 kg/m^3',...
             'CESM (BFT-supercoarse) with \rho = 500 kg/m^3',...
             'CESM (BFT-supercoarse) with \rho = 250 kg/m^3',...
             'CESM (BFT-supercoarse) with \rho = 125 kg/m^3',...
             'Model ensemble');
         
       
         set(the,'location','south','FontSize',11,'FontWeight','bold');
         set(the,'color','none');
         end
         
   
    
    
 
     %% print out measurement info
        if nref == 5 
        date_t = '2006-05/19'; height_t = '4853m';
        elseif nref == 105
            date_t = '2006-05/19'; height_t = '4853m';
        elseif nref ==6
            date_t = '2006-06-04'; height_t = '3703m';
        elseif nref ==106
            date_t = '2006-06/04'; height_t = '3703m';
        elseif nref ==7
            date_t = 'May 27, 2006'; height_t = '2300m above sea level'; Catg = 'Southern Portugal (Wagner et al., 2009)';
        elseif nref ==8
            date_t = 'May 27, 2006'; height_t = '3245m above sea level'; Catg = 'Southern Portugal (Wagner et al., 2009)';
        elseif nref ==11
            date_t = '2006-05/23-26';height_t = '688m';
        elseif nref ==111
            date_t = '2006-05/23-26';height_t = '688m';
        elseif nref ==14
            date_t = '2011-06/17-26';height_t = '~1000m';
        elseif nref ==114
            date_t = '2011-06/17-26';height_t = '~1000m';
        elseif nref ==15
            date_t = '2006-08/23';height_t = '1000m';
        elseif nref ==16
            date_t = 'June 17, 2013';height_t = '2600m above sea level'; Catg = 'Cape Verde (Weinzierl et al., 2017)';
        elseif nref ==17
            date_t = 'June 22, 2013';height_t = '2300m above sea level'; Catg = 'Barbados (Weinzierl et al., 2017)';
        elseif nref ==22
            date_t = 'June 17-28, 2011';height_t = '2500m above sea level'; Catg = 'Canary Islands (Ryder, Highwood, Lai, et al., 2013)';
        elseif nref ==23
            date_t = 'June 17-28, 2011';height_t = '4000m above sea level'; Catg = 'Canary Islands (Ryder, Highwood, Lai, et al., 2013)';
        elseif nref ==24
            date_t = '2011-06/17-28';height_t = '5500m';
        elseif nref ==25
            date_t = '2011-06/17-28';height_t = '6000m';
        elseif nref ==26
            date_t = '2015-08/7-25';height_t = '2500m';
        elseif nref ==27
            date_t = '2015-08/7-25';height_t = '4000m';
        elseif nref ==28
            date_t = '2015-08/7-25';height_t = '5500m';
        elseif nref ==29
            date_t = '2015-08/7-25';height_t = '6000m';
        end
        
       SW0 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 250*diff(ylim)]*0.001;
       text(SW0(1), SW0(2),Catg,'VerticalAlignment','bottom', 'HorizontalAlignment','left','color','m','FontSize',14,'FontWeight','bold')
       SW = [min(xlim) min(ylim)]+[0.8*diff(xlim) 100*diff(ylim)]*0.001;
       text(SW(1), SW(2),date_t,'VerticalAlignment','bottom', 'HorizontalAlignment','left','FontSize',12,'FontWeight','bold')
       SW2 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 50*diff(ylim)]*0.001;
       text(SW2(1), SW2(2),height_t,'VerticalAlignment','bottom', 'HorizontalAlignment','left','FontSize',12,'FontWeight','bold')

       %location of the subplot label
       SW3 = [min(xlim) min(ylim)]+[0.5*diff(xlim) 0.05*diff(ylim)]*0.001;
       text(SW3(1), SW3(2),subplotlabel{REFGroup},'EdgeColor','k','VerticalAlignment','bottom', ...
                   'HorizontalAlignment','left','FontSize',20,'FontWeight','bold')  
      
%                %location of the lambda (temporary showing)
%        if REFGroup==6
%        SW4 = [min(xlim) min(ylim)]+[8*diff(xlim) 0.05*diff(ylim)]*0.001;
%        text_lanbda = sprintf('Lambda = %0.2f',f_l);
%        text(SW4(1), SW4(2),text_lanbda,'VerticalAlignment','bottom', ...
%                        'HorizontalAlignment','left','FontSize',20,'FontWeight','bold') 
%        end        
               
       
   
end