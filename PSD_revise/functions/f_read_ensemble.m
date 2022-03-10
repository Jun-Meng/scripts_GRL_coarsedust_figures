function     [dust_psd_ensem, bin_edge] = f_read_ensemble(inDir)

infile = sprintf('%s/Yemi/AllModels_CommonBin_3D_modelPSD_seas.nc', inDir); 

%[nmodel,nD,lon,lat,lev,season], [6 6 144 96 48 4]
% seasons = "DJF_MAM_JJA_SON";
% models  = "GISS_WRFChem_CESM_GEOSChem_CNRM_IMPACT";
% D       = [0.1 1 2.5 5 10 14 20]
dust_psd = double(ncread(infile,'/dust_mass_fraction')); %[nmodel,nD,lon,lat,lev,season]
lat = double(ncread(infile,'/lat'));
lon = double(ncread(infile,'/lon'));
lev = double(ncread(infile,'/lev'));
D_lower = double(ncread(infile,'/D_lower'));
D_upper = double(ncread(infile,'/D_upper'));

dust_psd_ensem = squeeze(nanmean(dust_psd,1));  %(nD,lon,lat,lev,season)
bin_edge = [0.1 1 2.5 5 10 14 20]; 

end 