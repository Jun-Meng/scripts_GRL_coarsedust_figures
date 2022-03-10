function [mass_fraction]=f_calc_mass_fraction(scheme_name,model_bin_edge,f_l)
%% this function is to calculate mass fraction in each bin
% f_l is highly uncertain. the old PSD used 0.1
% testing f_l to be 0.15 and 0.2
%%
    %addpath('/Users/jun-work/Desktop/UCLA/codes/functions/'); % Add path of the functions 
    
  
    %% Emitted DUST PSD Parameterization Parameters
    % for kok proposal - BFT_coarseD 
    %scheme_name      = {'kok_proposal_complex_old','kok_proposal_complex'};     %'kok11' or 'kok_proposal_complex' or 'kok_proposal_old'

  
    if (strcmp(scheme_name,'kok11'))
        sigma     = 3.0; %parameter in Kok 2011
        Ds        = 3.4; %parameter in Kok 2011
        sigma_agg = 999;  %not used
        D_agg_med = 999;   % not used
    elseif (strcmp(scheme_name,'kok_proposal_complex_old'))
        sigma     = 3.0; %parameter in Kok 2011
        Ds        = 3.4; %parameter in Kok 2011 
        sigma_agg = 2.824;  %2.824
        D_agg_med = 140;   %140 um - median of the dry soil aggregates distribution, obtain this from OBS
        %f_l       = 0.1;   %f_l was 0.1
    elseif (strcmp(scheme_name,'kok_proposal_complex'))
        sigma     = 1.9192; %Yue's results
        Ds        = 1.1262; %Yue's results
        sigma_agg = 2.95;  %2.824
        D_agg_med = 127;   %140 um - median of the dry soil aggregates distribution, obtain this from OBS
    end

    %f_l       = 0.1; % ratio of DUST TO AGGGRE.This variable should also be a distribution
    Lamda     = 12;    % not used if not plot kok11 
    
  

    %% main program 
    % 1. f_clcu_mass_fraction_using_integral
    [mass_fraction_bin,Cv_update] = f_clcu_mass_fraction_using_integral...
        (Ds,D_agg_med,sigma,sigma_agg,Lamda,f_l,model_bin_edge,scheme_name); 

   
    mass_fraction = mass_fraction_bin;
    
   
end
