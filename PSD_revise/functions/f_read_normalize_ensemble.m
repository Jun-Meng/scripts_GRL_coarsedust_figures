function [model_ensemble_dVdlnD_norm,model_ensemble_dV,ensemble_bin_edg]=f_read_normalize_ensemble(datasetpath,edge_integral, nref)
    
% -function: read the model ensemble file, return
    % %(nD,lon,lat,lev,season)        and    seasons = "DJF_MAM_JJA_SON";
    [dust_massfrac_ensem, ensemble_bin_edg] = f_read_ensemble(datasetpath);
    
% -function: get obs info
    [ind_lat, ind_lon, ind_lev, date_i,season_obs] = f_get_obs_info (datasetpath,nref);
    % Sample the location with info from obs
    model_ensemble_dV = squeeze(dust_massfrac_ensem(:,ind_lon,ind_lat,ind_lev,season_obs));
    
% -function: convert dV to dV/dlnD for model output
    [model_ensemble_dVdlnD,dD_ensemble]      = f_conv2dVdlnD(model_ensemble_dV,ensemble_bin_edg);
    
% -function: integral of model output using bin method
    model_emsemble_dVdlnD_interal = f_integral_model_dV(model_ensemble_dVdlnD,ensemble_bin_edg,edge_integral);
    %Normlization 
    model_ensemble_dVdlnD_norm = model_ensemble_dVdlnD/model_emsemble_dVdlnD_interal;
end