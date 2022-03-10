function [mass_fraction_bin,Cv_update] = f_clcu_mass_fraction_using_integral (Ds,D_agg_med,sigma,sigma_agg, Lamda,f_l,model_bin_edge,study_name) 
% This function is using integrel method to calculate the bin mass fraction and return dVdD 
% Note: dV/dlnD = D*(dV/dD); so dV/dD = (dV/dlnD)/D 
    
    integral_edge = [0.1 20]; %determine the normalization factor
    
    if (strcmp(study_name,'kok11'))
       Cv        = 12.62; % normalization constant from kok11
       Cv_update = Cv;
       dVdD = @(Dd) (1+erf((log(Dd/Ds)/(sqrt(2)*log(sigma)))))...
                  .*exp(-(Dd/Lamda).^3)/Cv;
       %conclusion: dVdD is around 1 when integrel from 
       %            0 to at least  20 microns, beyond 20 microns,
       %            contributions is very small
       dVdD_integral = integral(dVdD, integral_edge(1), integral_edge(2))      %0-40:1.0018
       %calculate bin fraction used in CESM published in kok11
       %calc mass fractions
        for nbin = 1:length(model_bin_edge)-1
            bin_mass(nbin) = integral(dVdD, model_bin_edge(nbin), model_bin_edge(nbin+1));
        end
        
        tot_mass = sum(bin_mass)  
        mass_fraction_bin = bin_mass/tot_mass;
       

       
    elseif (strcmp(study_name,'kok11_update'))
       Cv        = 12.62*6.1098*0.4965; % normalization constant from kok11 update
       Cv_update = Cv;
       dVdD = @(Dd) (1+erf((log(Dd/Ds)/(sqrt(2)*log(sigma)))))...
                  .*exp(-(Dd/Lamda).^3)/Cv;
       %conclusion: dVdD is around 1 when integrel from 
       %            0 to at least  20 microns, beyond 20 microns,
       %            contributions is very small
       dVdD_integral = integral(dVdD, integral_edge(1), integral_edge(2)) 
       %calculate bin fraction used in CESM published in kok11
       bin1  = integral(dVdD, model_bin_edge(1), model_bin_edge(2));
       bin2  = integral(dVdD, model_bin_edge(2), model_bin_edge(3));
       bin3  = integral(dVdD, model_bin_edge(3), model_bin_edge(4));
       bin4  = integral(dVdD, model_bin_edge(4), model_bin_edge(5));
       bin5  = integral(dVdD, model_bin_edge(5), model_bin_edge(6));
       bin6  = integral(dVdD, model_bin_edge(6), model_bin_edge(7));
       bin7  = integral(dVdD, model_bin_edge(7), model_bin_edge(8));
       bin8  = integral(dVdD, model_bin_edge(8), model_bin_edge(9));
      
       %bin5  = integral(y_kok11_2, 10, 20)  % fraction from 10 to 20 microns: 27%
       tot   = bin1 + bin2 +  bin3 + bin4 ...
               + bin5 + bin6 +  bin7 + bin8 ;  % first 4 bins tot equals to 0.7296 (73%)
       f_bin1= bin1/tot;                     % Conclusion: f_bin equals to those used in CESM
       f_bin2= bin2/tot;                    %             [0.011 0.087 0.277 0.625]
       f_bin3= bin3/tot;
       f_bin4= bin4/tot;
       f_bin5= bin5/tot;
       f_bin6= bin6/tot;
       f_bin7= bin7/tot;
       f_bin8= bin8/tot;
       mass_fraction_bin(1) = f_bin1; 
       mass_fraction_bin(2) = f_bin2; 
       mass_fraction_bin(3) = f_bin3; 
       mass_fraction_bin(4) = f_bin4;  
       mass_fraction_bin(5) = f_bin5; 
       mass_fraction_bin(6) = f_bin6; 
       mass_fraction_bin(7) = f_bin7; 
       mass_fraction_bin(8) = f_bin8; 
    elseif (strcmp(study_name,'kok_proposal_complex_old')) 
        f_l = 0.1;
        if sigma_agg==2.824
            %Cv_update = 260.4971*0.078401060921227*0.6374; %integral from 0 to 40
            Cv_update = 260.4971*0.078401060921227*0.6374*0.6121;
        elseif sigma_agg==0.5
            %Cv_update = 260.4971*0.078401060921227*0.9189;%integral from 0 to 40
            Cv_update = 260.4971*0.078401060921227*0.9189*0.8372;
        end
        % this(260.4971*0.078401060921227) is when MD OF 150 and GSD OF 0.5 to make integral dV =1
        % using integrel to calculate Cv_update and mass fraction in each bin
        dVdD =@(Dd,D_agg)     (1+erf((log(Dd/Ds)/(sqrt(2)*log(sigma))))).*...
                              (exp(-(((f_l*D_agg)).^(-3)).*(Dd.^3)).* ... % lambda term 1
                              (1./(D_agg*sigma_agg*sqrt(2*pi))).* ...     % P_agg term1
                              exp(-(log(D_agg)-log(D_agg_med)).^2/(2*(sigma_agg^2)))) ... % P_agg term2
                              /Cv_update;
        %integrel limits: Dd (0 to 40 microns); D_agg  (1 to 1000 microns)
        dVdD_integral = integral2(dVdD, integral_edge(1), integral_edge(2), 1, 1000)
        % Conclude: dVdD_integral is very close to 1 when integral from 0 to 40 microns, Cv_update = 20.4232
        %           Another purpose is to calculate Cv_update when other
        %           input parameters change 
        %calc mass fractions
        for nbin = 1:length(model_bin_edge)-1
            bin_mass(nbin) = integral2(dVdD, model_bin_edge(nbin), model_bin_edge(nbin+1), 1, 1000);
        end
        tot_mass = sum(bin_mass);  
        mass_fraction_bin = bin_mass/tot_mass;   
       
    elseif (strcmp(study_name,'kok_proposal_complex'))  
        if sigma_agg==2.824
            %Cv_update = 260.4971*0.078401060921227*0.6374; %integral from 0 to 40
            Cv_update = 260.4971*0.078401060921227*0.6374*0.6121;
            
        elseif sigma_agg==2.95 && f_l==0.1
            Cv_update = 260.4971*0.078401060921227*0.6374*0.6121*0.9547*1.3668*1.8387;
        elseif sigma_agg==2.95 && f_l==0.15
            Cv_update = 260.4971*0.078401060921227*0.6374*0.6121*0.9547*1.3668*1.8387*1.2292;  %using Ds and sigma in Yue 2021 
        elseif sigma_agg==2.95 && f_l==0.2
            Cv_update = 260.4971*0.078401060921227*0.6374*0.6121*0.9547*1.3668*1.8387*1.3777;   
        elseif sigma_agg==0.5
            %Cv_update = 260.4971*0.078401060921227*0.9189;%integral from 0 to 40
            Cv_update = 260.4971*0.078401060921227*0.9189*0.8372;
        end
        % this(260.4971*0.078401060921227) is when MD OF 150 and GSD OF 0.5 to make integral dV =1
        % using integrel to calculate Cv_update and mass fraction in each bin
        dVdD =@(Dd,D_agg)     (1+erf((log(Dd/Ds)/(sqrt(2)*log(sigma))))).*...
                              (exp(-(((f_l*D_agg)).^(-3)).*(Dd.^3)).* ... % lambda term 1
                              (1./(D_agg*log(sigma_agg)*sqrt(2*pi))).* ...     % P_agg term1
                              exp(-(log(D_agg)-log(D_agg_med)).^2/(2*((log(sigma_agg))^2)))) ... % P_agg term2
                              /Cv_update;
        %integrel limits: Dd (0 to 40 microns); D_agg  (1 to 1000 microns)
        dVdD_integral = integral2(dVdD, integral_edge(1), integral_edge(2), 1, 1000)
        % Conclude: dVdD_integral is very close to 1 when integral from 0 to 40 microns, Cv_update = 20.4232
        %           Another purpose is to calculate Cv_update when other
        %           input parameters change 
        %calc mass fractions
        for nbin = 1:length(model_bin_edge)-1
            bin_mass(nbin) = integral2(dVdD, model_bin_edge(nbin), model_bin_edge(nbin+1), 1, 1000);
        end
        tot_mass = sum(bin_mass);  
        mass_fraction_bin = bin_mass/tot_mass;

   
    end   
       
end