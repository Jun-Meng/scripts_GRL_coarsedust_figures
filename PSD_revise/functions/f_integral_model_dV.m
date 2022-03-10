function [model_interal_w_edge] = f_integral_model_dV (model_dVdlnD,model_bin_edg,integral_edge) 
% this function integrals dV from model outputs 
% input:  simulated dV/dlnD  (model_dVdlnD) (bin_number x 1) calculated from function f_read_cesm_seasonal and observation indexing 
% input:  model bin edge (model_bin_edg) (1 x bin_number)
% output: the value of the integral      (model_interal) 
%         or the value of the integral with customized (edgesmodel_interal_w_edge)
 
    
    [model_bin_center,dlnD] = f_get_model_bincenter (model_bin_edg);
    %[bin_edge, dlnD] = f_clcu_binEdge_from_binCenter (model_bin_center)  %
    dlnD =dlnD'; %COLUMN
     % perform the integral over customized integral_edge
     % (note: maybe large errors since less bins usually. consider fit the model bin with curve and then do integral)
    idx = find(model_bin_center>=integral_edge(1) & model_bin_center <= integral_edge(end));
    model_interal_w_edge = sum(model_dVdlnD(idx).*dlnD(idx));
    
end