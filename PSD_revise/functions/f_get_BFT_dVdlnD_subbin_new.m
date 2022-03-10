function [Dd, dVdlnD] = f_get_BFT_dVdlnD_subbin_new (Ds,D_agg_med,sigma_agg,sigma, Lamda, Cv_update,f_l,study_name) 
% this function calc the dV/dlnD from default BFT theory (kok11) or kok proposal using bin method 
% input:  constant parameters and model_bin_edge (for calc the mass fraction using bin method)
% output: dVdlnD

%update on feb 19 2022: using log(sigma_agg) in Pagg(Dagg)

   % using bin method to plot dV/dlnD
    n_bin              = 600;                             %subbin numbers
    Dd_min             = 0.1; 
    Dd_max             = 100.1; 
    Dd                 = linspace(Dd_min,Dd_max,n_bin);   %subbin center
    %subbin_range       = (Dd_max-Dd_min)/n_bin; %if dV/dlnD, then here should be log range 
    
    if (strcmp(study_name,'kok11'))
        % below is the BFT from Kok (2011)
        a                  = 1+erf((log(Dd/Ds)/(sqrt(2)*log(sigma))));
        lambda_term        = exp(-(Dd/Lamda).^3);
        c                  = Dd.*a;
        dVdlnD            = c.*lambda_term/Cv_update;

            
    elseif (strcmp(study_name,'kok_proposal_complex'))
        
        % using bin method to plot dV/dlnD
        n=0;
        for dd = Dd 
            n  =n+1;
            lambda_term  =@(D_agg)   exp(-(((f_l*D_agg)).^(-3))*(dd^3)).* ...
                                     (1./(D_agg*log(sigma_agg)*sqrt(2*pi))) .* ...                %P_agg term1
                                     exp(-(log(D_agg)-log(D_agg_med)).^2/(2*((log(sigma_agg))^2))); %P_agg term2
            lambda_term_update(n) = integral(lambda_term,1, 1000);   %every Dd has a corresponding value

        end
            % Maple integral gives me a value of 0.917 for this term. 
            % And the calculation here gives me the same value:  lambda_term2_integral = 0.917
            % lambda_term2 =@(D_agg) (1./(D_agg*sigma_agg*sqrt(2*pi))).* ...
            %                        exp(-(log(D_agg)-log(D_agg_med)).^2/(2*(sigma_agg^2)));
            % lambda_term2_integral = integral(lambda_term2,1, 1000); 

        % below is the complex paramaterization of BFT from Kok's proposal 
        a             = 1+erf((log(Dd/Ds)/(sqrt(2)*log(sigma))));
        b             = lambda_term_update; 
        c             = Dd.*a;
        dVdlnD        = c.*b/Cv_update;
        

    elseif (strcmp(study_name,'kok_proposal_simple'))
        % using bin method to plot dV/dlnD
    
        % below is the simple paramaterization of BFT from Kok's proposal 
        a             = 1+erf((log(Dd/Ds)/(sqrt(2)*log(sigma))));
        %b             = lambda_term_update; %this term might 
        c             = Dd.*a;
        dVdlnD        = c/Cv_update;
        
    end

end





function [binE,dlnD] = f_clcu_binEdge_from_binCenter (binC) 
% this function calculates bin edges from the value of bin centers. 
% input:  bin centers (binC)  should be in 1 column 
% output: bin edges   (binE) and bin log space (dlnD) 
    binS = zeros((length(binC)-1),1); % bin spacing, 1 column
    binE = zeros((length(binC)+1),1); % 1 column
    dlnD = zeros(length(binC),1);     % bin log space
    for ii = 1:(length(binC)-1)
        binS(ii) = binC(ii+1) - binC(ii);
        binE(ii+1) = binC(ii) + binS(ii)/2;  %bin edge from the second to the last second
    end
    % this if statement excludes the possibility of calculated binE(1) <= 0
    if (binS(1)/2) >= binC(1)
        binE(1) = 1e-9; %arbitrarily set the lower edge to be a extremely small number
    else
        binE(1) = binC(1) - binS(1)/2;
    end
    binE(end) = binC(end) + binS(end)/2;
    for iii=1:length(binC)
        dlnD(iii)=log(binE(iii+1)) - log(binE(iii));
    end
end
