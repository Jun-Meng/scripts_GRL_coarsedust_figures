%% Script for Fig 1 in the manuscript  
% This scripts plot (a) the emitted dust PSD and
%                   (b) comparsion of PSD with fresh dust obs
% 
% Jun Meng, Oct. 13th 2021
% 
% Note: need to update the PSD curve uncertainty (Wait for Jasper)
clearvars;
clc;
%close all;

%% paths 
mainpath    = '/Users/jun-work/Desktop/UCLA';
addpath('/Users/jun-work/Desktop/UCLA/code_plots_GRL_revise/PSD_revise/functions/','-begin'); % Add path for MATLAB addons
plotpath    = sprintf('%s/plots/paper1_revised/',mainpath);


folderpath = '/Users/jun-work/Desktop/UCLA/datasets/Yue/OBS_emit_dust/';
jasperfolderpath = '/Users/jun-work/Desktop/UCLA/datasets/Jasper/CorrectedEmitDustPSD/';

%% figure frame
p  = figure(100);
set(p,'position',[300 200 1400 600]);
subplotlabel = {' a ',' b '};
% add tight subplot 
ha = tight_subplot(1,2,[.01 .07],[.1 .01],[.05 .01]);
% How to use tight_subplot:tight_subplot(x,y,[gap],[marg_h],[marg_w])
%     gap:    gaps between the axes in normalized units (0...1)
%                   or [gap_h gap_w] for different gaps in height and width 
%     marg_h: margins in height in normalized units (0...1)
%                   or [lower upper] for different lower and upper margins 
%     marg_w: margins in width in normalized units (0...1)
%                   or [left right] for different left and right margins 

%% Subplot 1a  [EMITTED PSD Curve]
axes(ha(1));

    %% plot Kok (2011) - fragmentation theory
    Ds = linspace(0.1,20,1000);
    Ds_avge = 3.4;
    Sigma = 3.0;
    lam = 12;
    %per jasper's email on sept 24 2021:
    %   "you need to shift the original BFT to be consistent with the normalized data: 
    %    you need to set the normalization constant C_v to 6.8326 (from 12.62)"
    cv = 6.8326;   
    JK_dvdlnd = Ds/cv.*(1+erf(log(Ds/Ds_avge)/sqrt(2)/log(Sigma))).*exp(-(Ds/lam).^3);
    JK2011 = plot(Ds,JK_dvdlnd,'k-','linewidth',1.5); hold on;

    %% Plot Jun Meng's new PSD results
    Ds_yue           = 1.1262; 
    sigma_yue        = 1.9192;
    scheme_name      = 'kok_proposal_complex'; 
    sigma_agg        = 2.95;  % it was 2.824/140 using in the model bins 
    D_agg_med        = 127;   %  median of the dry soil aggregates distribution, obtain this from OBS
    f_l              = 0.15;   % ratio of DUST TO AGGGRE.This variable should also be a distribution
    Lamda            = 12;    %   
    
    % 1. f_clcu_mass_fraction_using_integral  (BFT expressions) 
    %        - to get the normalization factor  "Cv_update" 
    [dVdD_func, Cv_update]  =  ...
        f_get_BFT_coarseD_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue,Lamda,f_l,scheme_name );   

    % 2. f_clcu_BFT_dVdlnD_subbin_method   (for plot out the line) 
    [D, dVdlnD]             =  ...
        f_get_BFT_dVdlnD_subbin_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue, Lamda,Cv_update,f_l,scheme_name);
    
    p_meng2 = plot(D, dVdlnD, 'b-.','linewidth',2.5); hold on; 
  

    %% plot Maximum likelihood fit to measurements for Jun's parameterization
    load(strcat(jasperfolderpath,'PSD_MLE_with_error.mat'));
    % MLE fit of BFT-coarse to measurements for Jun
    % plot 95% confidence interval
    plot(D_plot, PSD_emit_neg_2sigma_norm, '-','color',[0,0,1],'LineStyle','none'); hold on;
    plot(D_plot, PSD_emit_pos_2sigma_norm, '-','color',[0,0,1],'LineStyle','none'); hold on;
    x2 = [D_plot, fliplr(D_plot)];
    inBetween = [PSD_emit_neg_2sigma_norm, fliplr(PSD_emit_pos_2sigma_norm)];
    h = fill(x2, inBetween, [0,0,1],'LineStyle','none');
    set(h,'facealpha',.2);

    %% load the corrected emitted dust PSD obs and errors and then plot 
    load(strcat(jasperfolderpath,'PSD_datasets_corrected_kok11.mat'));

    % plot the corrected observation psd and errors 
    markers = {'<','<','<','<','<','^','o','d','s','v'}; 
    markerfacecolors  = {'none','none','none','none','none',[0.8,0.4,0],'m','r','b',[0.2,0.8,0]};
    markeredgecolors = {[0.6,0.4,0.2],[0,0.6,0.2],'b',[1,0.4,0],[0.8,0,1],'k','k','k','k','k'};
    errorbarcolors   = {[0.6,0.4,0.2],[0,0.6,0.2],'b',[1,0.4,0],[0.8,0,1],'k','k','k','k','k'};

    for i=1:length(PSD_dataset_name)
       % plot PSD
        if i<=5
            p_psd(i) = plot(PSD_D(i,:),PSD_dVdlnD(i,:),markers{i}, ...
                      'markerfacecolor',markerfacecolors{i},...
                      'markeredgecolor',markeredgecolors{i},'linewidth',1.2,'MarkerSize',10); hold on;
        else
            p_psd(i) = plot(PSD_D(i,:),PSD_dVdlnD(i,:),markers{i}, ...
                      'markerfacecolor',markerfacecolors{i},...
                      'markeredgecolor',markeredgecolors{i},'linewidth',0.3,'MarkerSize',10); hold on;
        end
        % add error bar
        for ii = 1:length(PSD_D(i,:))
            tempx = [PSD_D(i,ii), PSD_D(i,ii)];
            tempy = [PSD_dVdlnD(i,ii)-PSD_dVdlnD_err(i,ii), PSD_dVdlnD(i,ii)+PSD_dVdlnD_err(i,ii)];
            plot(tempx,tempy,'-','color',errorbarcolors{i},'linewidth',0.8); hold on;
        end
    end 

    %% Figure setting
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    xlim([0.2, 40]);
    ylim([1*10^(-3),3]);
    set(gca,'xtick',[0.2,1,10,20,40]);
    set(gca,'xticklabel',{'0.2','1','10','20','40'},'fontsize',16);
    set(gca,'ytick',[10^(-3),10^(-2),10^(-1),10^(0),2]);
    set(gca,'yticklabel',{'10^{-3}','10^{-2}','10^{-1}','10^{0}','2'},'fontsize',16);
    %set(gca,'box','off');
    xlabel('Dust geometric diameter \itD (\rm\bf\mum)','FontSize',20,'FontWeight','bold');
    ylabel('Normalized emitted size distribution,  d{\itV}/dln\itD','FontSize',20,'FontWeight','bold');

    the=legend([p_psd JK2011 p_meng2],...
        {'Gillette et al. (1972)','Gillette et al. (1974)',...
        'Gillette (1974) - Soil 1','Gillette (1974) - Soil 2','Gillette (1974) - Soil 3',... 
        'Fratini et al. (2007)','Sow et al. (2009)',...
        'Shao et al. (2011)','Rosenberg et al. (2014)',...
        'Khalfallah et al. (2020)',...
        'BFT-original (Kok, 2011)',...
        'BFT-supercoarse (this study)'});
    set(the,'location','southeast','FontSize',15,'FontWeight','bold');
    set(the,'color','none');

    % printinformation in the plot 
    Catg = 'Emitted dust PSD parameterization'; 
    SW0 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 350*diff(ylim)]*0.001;
    text(SW0(1), SW0(2),Catg,'VerticalAlignment','bottom', 'HorizontalAlignment','left','FontSize',20,'color','b','FontWeight','bold')
    
    %location of the subplot label
    SW3 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 550*diff(ylim)]*0.001;
    text(SW3(1), SW3(2),subplotlabel{1},'EdgeColor','k','VerticalAlignment','bottom', ...
               'HorizontalAlignment','left','FontSize',28,'FontWeight','bold')  

%% Subplot 1b [Comparison of simulated PSD with fresh dust obs]
axes(ha(2));

    %function to plot the fig1b
    [B600_output,dV]= f_plot_fig1b_psd_compare_FreshDust(f_l);

    %location of the subplot label
    SW3 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 550*diff(ylim)]*0.001;
    text(SW3(1), SW3(2),subplotlabel{2},'EdgeColor','k','VerticalAlignment','bottom', ...
                       'HorizontalAlignment','left','FontSize',28,'FontWeight','bold')  
           
    print(p,'-dpng','-r150',sprintf('%s/fig1_a_b_wSubplots_psd_revise_lambda_%d',plotpath,f_l*100));
    %print([figurepath,'Fig1_draft.png'],'-dpng');


