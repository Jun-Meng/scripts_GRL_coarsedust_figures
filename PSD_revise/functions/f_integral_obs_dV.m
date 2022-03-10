function [ obs_interal_w_edge,dlnD,bin_edge] = f_integral_obs_dV (obs_d, obs_dVdlnD,integral_edge) 
% this function integrals dV from measurements compilation. 
% input:  obs,    obs_dVdlnD
% output: the value of the integral   (obs_interal) 

  
    % get bin edge 
    [bin_edge, dlnD] = f_clcu_binEdge_from_binCenter (obs_d);
    % perform the integral using bin method
    obs_interal = sum(obs_dVdlnD.*dlnD);
    %% integral over customised  integral edge
    idx = find(obs_d>=integral_edge(1) & obs_d < integral_edge(end))
    %obs_interal_w_edge = sum(obs_dVdlnD(idx).*dlnD(idx));
    if idx(end)==length(obs_d)    %in case all measurements are smaller than 20 um
        obs_interal_w_edge = sum(obs_dVdlnD(idx).*dlnD(idx));
    else
        obs_interal_w_edge = sum(obs_dVdlnD(idx).*dlnD(idx))+0.5*(obs_dVdlnD(idx(end)+1)*dlnD(idx(end)+1));
    end
end