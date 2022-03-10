%%Code Info
% This code is to calculate the mass fraction in each bin from BFT-coarse dust emission parameterization 
% Author:        Jun Meng
% Last Modified: Oct. 22 2021
% 
% Conclusion: 
% 1. Test smaller dry soil aggr medians: 150 microns works perfectly, need to
%    talk with danny to verify the sigma value (geometric standard deviation) for the soil aggregates.
%       - Feb24 2021: Danny emailed to use dry soil median diameter of 140 microns ...
%                                        and geometric standard deviation of 2.824
%       - Aug31 2021: Danny recalculate the dry soil median diameter of 127 microns ...
%                                        and geometric standard deviation
%                                        of 2.95
%       - Sept 1, 2021: Jasper: "For that curve, you should also use sigma_s = 1.9192 and D_s = 1.1262, 
%                                           based on Yue's results in her 2021 paper."
%       - Oct 1, 2021: 
%       - Oct 8, 2021: add the ability to calculate for Kok2011 scheme
%       - Oct 22, 2021: add smaller bin space (0.01 um) for 0.1 - 1 um 
%       - March 10, 2022: use correct equation for Pagg(Dagg) amd f_l=0.15
%
% 2. f_l has large uncertainty: it is in the order of 0.1 (How to reduce the uncertainty of this factor??)


clc
clear

%% paths 
addpath('/Users/jun-work/Desktop/UCLA/code_plots_GRL_revise/PSD_revise/functions/'); % Add path of the functions 
mainpath    = '/Users/jun-work/Desktop/UCLA';
outdir = sprintf('%s/datasets/EmittedPSDCurve',mainpath);
saveout = 1;

%% Emitted DUST PSD Parameterization Parameters
% for kok proposal - BFT_coarseD 
scheme_name      = 'kok_proposal_complex';     %'kok11' or 'kok_proposal_complex' or 'kok_proposal_simple'

if (strcmp(scheme_name,'kok11'))
    sigma     = 3.0; %parameter in Kok 2011
    Ds        = 3.4; %parameter in Kok 2011
elseif (strcmp(scheme_name,'kok_proposal_complex'))
    sigma     = 1.9192; %Yue's results
    Ds        = 1.1262; %Yue's results
end
sigma_agg = 2.95;  %2.824
D_agg_med = 127;   %140 um - median of the dry soil aggregates distribution, obtain this from OBS
f_l       = 0.15; % ratio of DUST TO AGGGRE.This variable should also be a distribution
Lamda     = 12;    % not used if not plot kok11 

%% define your own bin edges
model_bin_below1 = linspace(0.1,1,91); %bin space 0.01 um
%model_bin_above1 = linspace(1,40,391); %bin space 0.1 um   %0.1 to 40 um  
model_bin_above1 = linspace(1,100,991); %bin space 0.1 um    %0.1 to 100 um   
model_bin_edge=[model_bin_below1 model_bin_above1(2:end)];
%model_bin_edge  = linspace(0.1,40,400); %[0.1 1 2.5 5 10 14 20 28 40] for my simulation in the study

%model_bin_edge  = [0.1 1 2.5 5 10 14 20 28 40];
%model_bin_edge  = [0.1 1 2.5 5 10 20 35 62.5 100];  %review paper
%% main program 
% 1. f_clcu_mass_fraction_using_integral
[mass_fraction_bin,Cv_update] = f_clcu_mass_fraction_using_integral...
    (Ds,D_agg_med,sigma,sigma_agg,Lamda,f_l,model_bin_edge,scheme_name); 

tot = sum(mass_fraction_bin);
%% save out bin mass fractions for future usage
if saveout   
    output = [model_bin_edge(1:end-1)' model_bin_edge(2:end)' mass_fraction_bin']; % edge_left edge_right fraction
    %savefname = sprintf('%s/Dust_mass_fractions_CustomizedBinEdges.csv',outdir);
    savefname = sprintf('%s/Dust_mass_fractions_CustomizedBinEdges_BFT_supercoarse_100um.csv',outdir);
    %savefname = sprintf('%s/Dust_mass_fractions_8bins.csv',outdir);
    %savefname = sprintf('%s/Dust_mass_fractions_8bins_BFT-Coarse.csv',outdir);
    % one way: if only save out numbers, no headings 
    %csvwrite(savefname,output);
    
    
    %another way: with headings
    cHeader = {'Bin lower boundary' 'Bin upper boundary' 'mass fraction'}; 
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    %write header to file
    fid = fopen(savefname,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    dlmwrite(savefname,output,'-append');
end
    
