function [obs_interal_w_edge] = f_integral_obs_dV_compare_conversion (inDir,nref,integral_edge,YueConvert,instrument) 
% this function integrals dV from measurements compilation. 
% input:  reference number (nref)   
% output: the value of the integral   (obs_interal) 

    % select which observation to compare with.
    if nref<20        % go with the read ref code
        % function: get the observed obs_d, obs_dVdlnD from REF_NUMBER observations
         [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs, ref_name]...
            = f_read_PSD_obs_Refs (inDir,nref);  
    elseif nref==22 || nref==23
         % using FENNEC SAL observation from Ryder 2013 GRL   
         [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs,season_obs,ref_name]...
          = f_read_PSD_obs_Flights (inDir,nref,YueConvert);
      
    elseif nref>100 && nref<200   % go with the obs compiled by Jun 
         [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs, ref_name]...
            = f_read_PSD_obs_Refs_JunCompile (inDir,nref);
         aa= 'nref = 114 testing jun compile'
    elseif nref>200 && nref<300  % go with the obs compiled by Jun and converted by Yue
         [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs, ref_name]...
            = f_read_PSD_obs_Refs_JunCompile (inDir,nref);
         aa= 'nref = 214 testing conversion'
    elseif nref>500   % go with the read flight code
 	     [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_obs,flight_name]...
            = f_read_PSD_obs_Flights_compare_conversion (inDir,nref,YueConvert,instrument);
    end
    % get bin edge 
    [bin_edge, dlnD] = f_clcu_binEdge_from_binCenter (obs_d);
    % perform the integral using bin method
    obs_interal = sum(obs_dVdlnD.*dlnD);
    % integral over customised  integral edge
    idx = find(obs_d>=integral_edge(1) & obs_d < integral_edge(end));
    obs_interal_w_edge = sum(obs_dVdlnD(idx).*dlnD(idx));
end