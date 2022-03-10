function [dVdD,Cv_update] = f_get_BFT_coarseD_new (Ds,D_agg_med,sigma_agg, sigma, Lamda,f_l,study_name) 
% This function is using integrel method to calculate dust size distribution dVdD 
% Note: dV/dlnD = D*(dV/dD); so dV/dD = (dV/dlnD)/D 
% Output:    dVdD is a function handle
% update: Feb 19 2022/ use log(sigma_agg) in the parameterization of Pagg(Dagg)

    % should i integral from 0 to 40 instead? 
    integral_edge = [0 20];  %determine the normalization factor
    
    if (strcmp(study_name,'kok11'))
       Cv        = 12.62; % normalization constant from kok11
       Cv_update = Cv;
       dVdD = @(Dd) (1+erf((log(Dd/Ds)/(sqrt(2)*log(sigma)))))...
                  .*exp(-(Dd/Lamda).^3)/Cv;
              
       %conclusion: dVdD is around 1 when integrel from 
       %            0 to at least  20 microns, beyond 20 microns,contributions is very small
       dVdD_integral = integral(dVdD, integral_edge(1), integral_edge(2));   % if 0-40:1.0018
         
       
    elseif (strcmp(study_name,'kok_proposal_complex'))  
        if     sigma_agg==2.824
            %Cv_update = 260.4971*0.078401060921227*0.6374; %integral from 0 to 40
            Cv_update = 260.4971*0.078401060921227*0.6374*0.6121;
        elseif sigma_agg==2.95 && f_l==0.1
            %Cv_update = 260.4971*0.078401060921227*0.6374; %integral from 0 to 40
            Cv_update = 260.4971*0.078401060921227*0.6374*0.6121*0.9547*1.3668*1.8387;  %using log(sigma_agg)
        elseif sigma_agg==2.95 && f_l==0.15
            Cv_update = 260.4971*0.078401060921227*0.6374*0.6121*0.9547*1.3668*1.8387*1.2292; 
        elseif sigma_agg==2.95 && f_l==0.2
            Cv_update = 260.4971*0.078401060921227*0.6374*0.6121*0.9547*1.3668*1.8387*1.3777; 
        elseif sigma_agg==2.95 && f_l==0.25
            Cv_update = 260.4971*0.078401060921227*0.6374*0.6121*0.9547*1.3668*1.8387*1.4804;     
        elseif sigma_agg==0.5
            %Cv_update = 260.4971*0.078401060921227*0.9189;%integral from 0 to 40
            Cv_update = 260.4971*0.078401060921227*0.9189*0.8372;
        end
        % this (260.4971*0.078401060921227) is when MD OF 150 and GSD OF 0.5 to make integral dV =1
        % using integrel to calculate Cv_update and mass fraction in each bin
        dVdD =@(Dd,D_agg)     (1+erf((log(Dd/Ds)/(sqrt(2)*log(sigma))))).*...
                              (exp(-(((f_l*D_agg)).^(-3)).*(Dd.^3)).* ... % lambda term 1
                              (1./(D_agg*log(sigma_agg)*sqrt(2*pi))).* ...     % P_agg term1
                              exp(-(log(D_agg)-log(D_agg_med)).^2/(2*((log(sigma_agg))^2)))) ... % P_agg term2
                              /Cv_update;
        
        %integrel limits: Dd (0 to 40 microns); D_agg  (1 to 1000 microns)
        disp("This is calculating BFT_coarseD emisison para...")
        dVdD_integral = integral2(dVdD, integral_edge(1), integral_edge(2), 1, 1000)
        % Conclude: dVdD_integral is very close to 1 when integral from 0 to 40 microns
        %           Another purpose is to calculate Cv_update when other
        %           input parameters change 
        
    elseif (strcmp(study_name,'kok_proposal_simple'))  
        % using integrel to calculate Cv_update and mass fraction in each bin
        %Cv_update = 260.4971*0.078401060921227*3.3364; %  20.4232 to make integral dV =1 from 0 to 40
        Cv_update = 260.4971*0.078401060921227*3.3364*0.4286;  %integral from 0 to 20
        dVdD =@(Dd)     (1+erf((log(Dd/Ds)/(sqrt(2)*log(sigma)))))/Cv_update;
                              
                              
        %integrel limits: Dd (0 to 40 microns); D_agg  (1 to 1000 microns)
        dVdD_integral = integral(dVdD, integral_edge(1), integral_edge(2))
        
    end   
       
end