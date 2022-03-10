% This scripts plot the corrected emitted dust PSD from Jasper 
%           plus new coarse dust psd, plus Maximum likelihood fit
% For fig1 in the manuscript 

clearvars;
clc;
close all;

%% paths 
mainpath    = '/Users/jun-work/Desktop/UCLA';
addpath('/Users/jun-work/Desktop/UCLA/code_plots_GRL_revise/PSD_revise/functions/','-begin'); % Add path for MATLAB addons
plotpath    = sprintf('%s/plots/paper1_revised/',mainpath);

folderpath = '/Users/jun-work/Desktop/UCLA/datasets/Yue/OBS_emit_dust/';
jasperfolderpath = '/Users/jun-work/Desktop/UCLA/datasets/Jasper/CorrectedEmitDustPSD/';

%% figure frame
p  =figure;
set(p,'position',[300 200 1000 1000]);

%% plot Kok (2011) - fragmentation theory
Ds = linspace(0.1,20,1000);
Ds_avge = 3.4;
Sigma = 3.0;
lam = 12;
%per jasper's email on sept 24:
% "you need to shift the original BFT to be consistent with the normalized data: 
%    you need to set the normalization constant C_v to 6.8326 (from 12.62)"
cv = 6.8326;   
JK_dvdlnd = Ds/cv.*(1+erf(log(Ds/Ds_avge)/sqrt(2)/log(Sigma))).*exp(-(Ds/lam).^3);
JK2011 = plot(Ds,JK_dvdlnd,'k-','linewidth',1.5); hold on;

%% Plot Jun Meng's new PSD results
Ds_yue           = 1.1262; 
sigma_yue        = 1.9192;
scheme_name      = 'kok_proposal_complex'; 
sigma_agg        = 2.95;  % 2.824
D_agg_med        = 127;   % 140 um - median of the dry soil aggregates distribution, obtain this from OBS
f_l              = 0.1;   % ratio of DUST TO AGGGRE.This variable should also be a distribution
Lamda            = 12;    % 

%%
% test different fl values: 0.15/0.2/0.25
f_l2 = 0.15;
f_l3 = 0.2;
f_l4 = 0.25;

%%
% 1. f_clcu_mass_fraction_using_integral  (BFT expressions) 
%        - to get the normalization factor  "Cv_update" 
[dVdD_func, Cv_update]  =  ...
    f_get_BFT_coarseD (Ds_yue,D_agg_med,sigma_agg,sigma_yue,Lamda,f_l,scheme_name );   

[dVdD_func1, Cv_update1]  =  ...      %use log(sigma_agg in the pagg(Dagg))
    f_get_BFT_coarseD_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue,Lamda,f_l,scheme_name );  
% 2. f_clcu_BFT_dVdlnD_subbin_method   (for plot out the line) 
[D, dVdlnD]             =  ...
    f_get_BFT_dVdlnD_subbin (Ds_yue,D_agg_med,sigma_agg,sigma_yue, Lamda,Cv_update,f_l,scheme_name);

[D, dVdlnD1]             =  ...
    f_get_BFT_dVdlnD_subbin_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue, Lamda,Cv_update1,f_l,scheme_name);

 %test different f_l
 [dVdD_func2, Cv_update2]  =  ...      %use log(sigma_agg in the pagg(Dagg))
    f_get_BFT_coarseD_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue,Lamda,f_l2,scheme_name );  
 [dVdD_func3, Cv_update3]  =  ...      %use log(sigma_agg in the pagg(Dagg))
    f_get_BFT_coarseD_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue,Lamda,f_l3,scheme_name );  
 [dVdD_func4, Cv_update4]  =  ...      %use log(sigma_agg in the pagg(Dagg))
    f_get_BFT_coarseD_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue,Lamda,f_l4,scheme_name ); 


 [D, dVdlnD2]             =  ...
    f_get_BFT_dVdlnD_subbin_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue, Lamda,Cv_update2,f_l2,scheme_name);
 [D, dVdlnD3]             =  ...
    f_get_BFT_dVdlnD_subbin_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue, Lamda,Cv_update3,f_l3,scheme_name);
 [D, dVdlnD4]             =  ...
    f_get_BFT_dVdlnD_subbin_new (Ds_yue,D_agg_med,sigma_agg,sigma_yue, Lamda,Cv_update4,f_l4,scheme_name);

p_meng = plot(D, dVdlnD, 'b-.','linewidth',2); hold on; 
p_meng1 = plot(D, dVdlnD1, 'r-.','linewidth',2); hold on;
% different fl
p_meng2 = plot(D, dVdlnD2, 'Color',[0.9290 0.6940 0.1250],'linewidth',2); hold on; 
p_meng3 = plot(D, dVdlnD3, 'g-.','linewidth',2); hold on; 
p_meng4 = plot(D, dVdlnD4, 'c-.','linewidth',2); hold on; 

%% plot Maximum likelihood fit to measurements for Jun's parameterization
load(strcat(jasperfolderpath,'PSD_MLE_with_error.mat'));
% MLE fit of BFT-coarse to measurements for Jun
% MLE2 = plot(D_plot, PSD_emit_median_norm,'k-.','linewidth',1.5); hold on;
% plot 95% confidence interval
plot(D_plot, PSD_emit_neg_2sigma_norm, '-','color',[0,0,1],'LineStyle','none'); hold on;
plot(D_plot, PSD_emit_pos_2sigma_norm, '-','color',[0,0,1],'LineStyle','none'); hold on;
x2 = [D_plot, fliplr(D_plot)];
inBetween = [PSD_emit_neg_2sigma_norm, fliplr(PSD_emit_pos_2sigma_norm)];
h = fill(x2, inBetween, [0,0,1],'LineStyle','none');
set(h,'facealpha',.2);

%% load the corrected emitted dust PSD
load(strcat(jasperfolderpath,'PSD_datasets_corrected.mat'));

%% plot the corrected observation psd and errors 
markers = {'<','<','<','<','<','^','o','d','s','v'}; 
markerfacecolors  = {'none','none','none','none','none',[0.8,0.4,0],'m','r','b',[0.2,0.8,0]};
markeredgecolors = {[0.6,0.4,0.2],[0,0.6,0.2],'b',[1,0.4,0],[0.8,0,1],'k','k','k','k','k'};
errorbarcolors   = {[0.6,0.4,0.2],[0,0.6,0.2],'b',[1,0.4,0],[0.8,0,1],'k','k','k','k','k'};

for i=1:length(PSD_dataset_name)
% plot PSD
    if i<=5
        p_psd(i) = plot(PSD_D(i,:),PSD_dVdlnD(i,:),markers{i}, ...
                  'markerfacecolor',markerfacecolors{i},...
                  'markeredgecolor',markeredgecolors{i},'linewidth',1.2); hold on;
    else
        p_psd(i) = plot(PSD_D(i,:),PSD_dVdlnD(i,:),markers{i}, ...
                  'markerfacecolor',markerfacecolors{i},...
                  'markeredgecolor',markeredgecolors{i},'linewidth',0.3); hold on;
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
%ylim([5*10^(-4),3]);
ylim([1*10^(-3),3]);
set(gca,'xtick',[0.2,1,10,20,40]);
set(gca,'xticklabel',{'0.2','1','10','20','40'},'fontsize',17);
% set(gca,'ytick',[5*10^(-4),10^(-3),10^(-2),10^(-1),10^(0),2]);
% set(gca,'yticklabel',{'5E-4','10^{-3}','10^{-2}','10^{-1}','10^{0}','2'},'fontsize',17);
set(gca,'ytick',[10^(-3),10^(-2),10^(-1),10^(0),2]);
set(gca,'yticklabel',{'10^{-3}','10^{-2}','10^{-1}','10^{0}','2'},'fontsize',17);
%set(gca,'box','off');
xlabel('Dust geometric diameter \itD, \rm\bf\mum','FontSize',22,'FontWeight','bold');
ylabel('Normalized emitted size distribution,  d{\itV}/dln\itD','FontSize',22,'FontWeight','bold');


the=legend([p_psd JK2011 p_meng p_meng1 p_meng2 p_meng3 p_meng4 ],...
    {'Gillette et al. (1972)','Gillette et al. (1974)',...
    'Gillette (1974) - Soil 1','Gillette (1974) - Soil 2','Gillette (1974) - Soil 3',... 
    'Fratini et al. (2007)','Sow et al. (2009)',...
    'Shao et al. (2011)','Rosenberg et al. (2014)',...
    'Khalfallah et al. (2020)',...
    'BFT-original (Kok, 2011)',...
    'BFT-coarse (this study)',...
    'BFT-coarse (this study)-revised fl0.1',...
    'BFT-coarse (this study)-revised fl0.15',...
    'BFT-coarse (this study)-revised fl0.2',...
    'BFT-coarse (this study)-revised fl0.25',...
    });
set(the,'location','southeast','FontSize',17,'FontWeight','bold');
set(the,'color','none');
%location of the subplot label
%        SW3 = [min(xlim) min(ylim)]+[0.8*diff(xlim) 500*diff(ylim)]*0.001;
%        text(SW3(1), SW3(2),subplotlabel{1},'EdgeColor','k','VerticalAlignment','bottom', ...
%                    'HorizontalAlignment','left','FontSize',20,'FontWeight','bold')  



print(p,'-dpng','-r150',sprintf('%s/fig1_PSD_only_test_fl',plotpath));



