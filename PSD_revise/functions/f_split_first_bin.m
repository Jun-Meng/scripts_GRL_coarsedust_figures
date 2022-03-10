function [model3_dVdlnD_norm_new]=f_split_first_bin(model3_dV, scheme_name,f_l,edge_integral,model_bin_edge_new)

%%split 0.1-10 bin into 0.2-0.5 and 0.5-1
    %scheme_name      = 'kok_proposal_complex'; 
    %model_bin_edge_new  = [0.2 0.5 1 2.5 5 10 14 20 28 40]; %9 bins
    
    for ii=1:(length(model_bin_edge_new)-1)
    model_bin_space_dlnD_new(ii) = log(model_bin_edge_new(ii+1)) - log(model_bin_edge_new(ii)); 
    end
    [mass_fraction] = f_calc_mass_fraction(scheme_name,model_bin_edge_new,f_l);
    for bin=1:2
    model3_dV_new(bin) = model3_dV(1)*mass_fraction(bin)/(sum(mass_fraction(1:2)));
    end
    model3_dV_new(3:(length(model3_dV)+1)) = model3_dV(2:end);
    model3_dV_new = model3_dV_new';
    model3_dVdlnD_new = model3_dV_new./model_bin_space_dlnD_new';
    model3_dVdlnD_interal_new = f_integral_model_dV(model3_dVdlnD_new,model_bin_edge_new,edge_integral);
    model3_dVdlnD_norm_new    = model3_dVdlnD_new/model3_dVdlnD_interal_new;
end