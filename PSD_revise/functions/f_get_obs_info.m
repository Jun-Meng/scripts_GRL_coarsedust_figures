function [ind_lat, ind_lon, ind_lev, date_i,season_i]...
          = f_get_obs_info (datasetpath, ref_number)
      
% this function returns information of the observation, lat. lon, lev etc.
% output: 
%    season_i = 1 2 3 4 -> (DJF_MAM_JJA_SON)

    %get obs info (change lon and lev to match ensemble style, e.g. (-177.5 to 177.5))
    [lat_i, lon_i, lev_i, height_i, date_i,season_i]...
              = f_metinfo_PSD_obs(ref_number);
          
    %get ensemble info     
   [lat_ensemble,lon_ensemble,lev_ensemble] = read_ensemble_metinfo(datasetpath);
    
    %get lev id according to measurement height
    ind_lat     = dsearchn(lat_ensemble, lat_i);
    ind_lon     = dsearchn(lon_ensemble, lon_i);
    ind_lev     = lev_i; 
    %ind_lev     = dsearchn(GH_model(ind_lon,ind_lat,:), height_i);

    
end

function [lat_i, lon_i, lev_i, height_i,date_i,season_i]...
              = f_metinfo_PSD_obs (ref_number)
  %this function provides the detail info of each flight 
  % here lev will be match Yemi's ensemble data 
  
  % this function will output the met info for the observations, e.g. lat, lon, height
  % note here height need to convert to pressure in the future
  
  %ref info
    if ref_number == 1
        lat_i = 17.2; lon_i= 5.8;      height_i= 0; lev_i = 56;    season_i = 1;
        ref_name = 'Chou et al. (2008) B160N3';
    elseif ref_number == 2
        lat_i = 14; lon_i= 2;      height_i= 150; lev_i = 46:56; season_i = 1;
        ref_name = 'Chou et al. (2008) B165N7'; 
    elseif ref_number == 3
        % between feb 1979 and feb 1982
        lat_i = 14; lon_i= 2;      height_i= 0; lev_i = 46:56; season_i = 1;
        ref_name = 'dAlmeida (1987)';
        %date_i = {};
    elseif ref_number == 4    %SAMUM2
        % A large field experiment of the Saharan Mineral Dust Experiment (SAMUM) was performed in Praia, Cape Verde, in January and February 2008.
        lat_i = 18; lon_i= 360-23; height_i= 110; lev_i = 56;    season_i = 1;
        ref_name = 'Kandler et al. (2011)';
        date_i = {'2008-01-17', '2008-01-18','2008-01-19','2008-01-20',...
                  '2008-01-24','2008-01-25','2008-01-26',...
                  '2008-01-28','2008-01-29','2008-01-30','2008-01-31','2008-02-01'};
    elseif ref_number == 5
        lat_i = 31; lon_i= 360-7 ; height_i= 4853; lev_i = 36;    season_i = '05';
        ref_name = 'Weinzierl et al. (2009) L02';
        date_i = {'2006-05-19'};
        % date_i = {'2006-05-20'};
    elseif ref_number == 6
        lat_i = 31; lon_i= 360-7 ; height_i= 3703; lev_i = 38;    season_i = 3;
        ref_name = 'Weinzierl et al. (2009) L07';
        date_i = {'2006-06-04'};
    elseif ref_number == 7  %*
        lat_i = 38; lon_i= -7.9 ; height_i= 2300; lev_i = 14; season_i = 2;
        ref_name = 'Wagner et al. (2009) 2300m';
        date_i = {'2006-05-27'};   %real: 2006
    elseif ref_number == 8  %*
        lat_i = 38; lon_i= -7.9 ; height_i= 3245; lev_i = 18; season_i = 2;
        ref_name = 'Wagner et al. (2009) 3245m';
        date_i = {'2006-05-27'};   %real 2006
    elseif ref_number == 9
        lat_i = 35; lon_i= 140   ; height_i= 250; lev_i = 55;  season_i = 2;
        ref_name = 'Clarke et al. (2004) 250m';
    elseif ref_number == 10
        lat_i = 34; lon_i= 140   ; height_i= 700; lev_i = 52;  season_i = 2;
        ref_name = 'Clarke et al. (2004) 700m';
    elseif ref_number == 11
        lat_i = 29; lon_i= 360-5 ; height_i= 688; lev_i = 56;    season_i = '05';
        date_i = {'2006-05-23','2006-05-24','2006-05-25','2006-05-26'}
        ref_name = 'Kandler et al. (2009)';
    elseif ref_number == 12
        lat_i = 12; lon_i= 360-60; height_i= 0; lev_i = 40;    season_i = 2;
        ref_name = 'Jung et al. (2013) Day1';
    elseif ref_number == 13
        lat_i = 12; lon_i= 360-60; height_i= 0; lev_i = 47;    season_i = 2;
        ref_name = 'Jung et al. (2013) Day2';
    elseif ref_number == 14     %Ryder 2013b  40:56?
        lat_i = 24; lon_i= 360-4 ; height_i= 1000; lev_i = 40:56; season_i = 3;
        date_i = {'2011-06-17','2011-06-18','2011-06-20','2011-06-21','2011-06-24',...
                 '2011-06-25','2011-06-26'};
        ref_name = 'Ryder et al. (2013b)';
    elseif ref_number == 15 
    %B238 run 4.1 at 1km land regions in northern Mauritania/ 
    %sample heavy dust loadings over land in Mauritania forecast by dust models and visible in
        lat_i = 19; lon_i= 360-12; height_i= 1000; lev_i = 49; season_i = 'JJA';
        date_i = {'2006-08-23'};
        ref_name = 'McConnell et al. (2008)';
    elseif ref_number == 16 %*
        % The air mass studied in the Cabo Verde region (blue symbols) on 17 Jun 2013
        % 17 June 2013
        lat_i = 15; lon_i= -23; height_i= 2600; lev_i = 16; season_i = 3;
        date_i = {'2011-06-17'};   %real : 2013
        ref_name = 'Weinzierl et al (2017) CV';
    elseif ref_number == 17  %*
        % 22 June 2013
        lat_i = 12; lon_i= -60; height_i= 2300; lev_i = 15; season_i = 3;
        date_i = {'2011-06-22'};   %real: 2013
        ref_name = 'Weinzierl et al (2017) BD';
    elseif ref_number == 18
        lat_i = 27; lon_i= 360-15; height_i= 2700; lev_i = 40;    season_i = 'JJA';
        ref_name = 'Otto et al. (2007) 2700m';
    elseif ref_number == 19
        lat_i = 27; lon_i= 360-15; height_i= 4000; lev_i = 36;    season_i = 'JJA';
        ref_name = 'Otto et al. (2007) 4000m';
    elseif ref_number == 20
        lat_i = 27; lon_i= 360-15; height_i= 5500; lev_i = 33;    season_i = 'JJA';
        ref_name = 'Otto et al. (2007) 5500m';
    elseif ref_number == 21
        lat_i = 27; lon_i= 360-15; height_i= 7000; lev_i = 31;    season_i = 'JJA';
        ref_name = 'Otto et al. (2007) 7000m';
    elseif ref_number == 22  %*
        lat_i = 28; lon_i= -16; height_i= 2500; lev_i = 16;    season_i = 3;
        date_i = {'2011-06-17', '2011-06-18', '2011-06-19','2011-06-20','2011-06-21',...
                  '2011-06-22','2011-06-23','2011-06-24','2011-06-25','2011-06-26',...
                  '2011-06-27','2011-06-28'}; 
        ref_name = 'Ryder et al. (2013) 2500m';
    elseif ref_number == 23   % *
        lat_i = 28; lon_i= -16; height_i= 4000; lev_i = 20;    season_i = 3;
        ref_name = 'Ryder et al. (2013) 4000m';
        date_i = {'2011-06-17', '2011-06-18', '2011-06-19','2011-06-20','2011-06-21',...
                  '2011-06-22','2011-06-23','2011-06-24','2011-06-25','2011-06-26',...
                  '2011-06-27','2011-06-28'};
    elseif ref_number == 24
        lat_i = 28; lon_i= 360-16; height_i= 5500; lev_i = 33;    season_i = 'JJA';
        date_i = {'2011-06-17', '2011-06-18', '2011-06-19','2011-06-20','2011-06-21',...
                  '2011-06-22','2011-06-23','2011-06-24','2011-06-25','2011-06-26',...
                  '2011-06-27','2011-06-28'};
        ref_name = 'Ryder et al. (2013) 5500m';
 
    elseif ref_number == 25
        lat_i = 28; lon_i= 360-16; height_i= 6000; lev_i = 32;    season_i = 'JJA';
        date_i = {'2011-06-17', '2011-06-18', '2011-06-19','2011-06-20','2011-06-21',...
                  '2011-06-22','2011-06-23','2011-06-24','2011-06-25','2011-06-26',...
                  '2011-06-27','2011-06-28'};
        ref_name = 'Ryder et al. (2013) 6000m';
    elseif ref_number == 26
        lat_i = 18; lon_i= 360-20; height_i= 2500; lev_i = 41;     season_i = 'JJA';
        ref_name = 'Ryder et al. (2018) 2500m';
        date_i = {'2015-08-07','2015-08-12','2015-08-16',...
                  '2015-08-20','2015-08-25'};
    elseif ref_number == 27
        lat_i = 18; lon_i= 360-20; height_i= 4000; lev_i = 36;     season_i = 'JJA';
        ref_name = 'Ryder et al. (2013) 4000m';
        date_i = {'2015-08-07','2015-08-12','2015-08-16',...
                  '2015-08-20','2015-08-25'};
    elseif ref_number == 28
        lat_i = 18; lon_i= 360-20; height_i= 5500; lev_i = 33;     season_i = 'JJA';
        ref_name = 'Ryder et al. (2013) 5500m';
        date_i = {'2015-08-07','2015-08-12','2015-08-16',...
                  '2015-08-20','2015-08-25'};
    elseif ref_number == 29
        lat_i = 18; lon_i= 360-20; height_i= 6000; lev_i = 32;     season_i = 'JJA';
        ref_name = 'Ryder et al. (2013) 6000m';
        date_i = {'2015-08-07','2015-08-12','2015-08-16',...
                  '2015-08-20','2015-08-25'};
              
   
    % flight info 
          elseif ref_number == 600
              lat_i = 23.18; lon_i= -6.3; height_i= 994; lev_i = 8; season_i=3;
              date_i = {'2011-06-17'};flight_name='B600';
          elseif ref_number == 601
              lat_i = 23.07; lon_i= -6.6; height_i= 1007; lev_i = 8; season_i=3;
              date_i = {'2011-06-17'};flight_name='B601';
          elseif ref_number == 602
              lat_i = 23.73; lon_i= -7.2; height_i= 386; lev_i = 6; season_i=3;
              date_i = {'2011-06-18'};flight_name='B602';
          elseif ref_number == 610 
              lat_i = 24.35; lon_i= -7.0; height_i= 440;  lev_i = 6; season_i=3;
              date_i = {'2011-06-25'};flight_name='B610';
          elseif ref_number == 604
              lat_i = 23.63; lon_i= -9.76; height_i= 350;lev_i = 6;season_i=3;
              date_i = {'2011-06-20'};flight_name='B604';
          elseif ref_number == 605
              lat_i = 23.29; lon_i= -9.25; height_i= 330;lev_i = 6;season_i=3;
              date_i = {'2011-06-21'};flight_name='B605';
          elseif ref_number == 606
              lat_i = 23.5; lon_i= -9.8; height_i= 340;lev_i = 6;season_i=3;
              date_i = {'2011-06-21'};flight_name='B606';
          elseif ref_number == 609
              lat_i = 25.15; lon_i= -8.0; height_i= 450;lev_i = 6;season_i=3;
              date_i = {'2011-06-24'};flight_name='B609';
          elseif ref_number == 611
              lat_i = 22.17; lon_i= -11.8; height_i= 450;lev_i = 6;season_i=3;
              date_i = {'2011-06-25'};flight_name='B611';
          elseif ref_number == 612
              lat_i = 24.0; lon_i= -10.5; height_i= 330;lev_i = 6;season_i=3;
              date_i = {'2011-06-26'};flight_name='B612';
          elseif ref_number== 613
              lat_i = 23.84; lon_i= -10.5; height_i= 400;lev_i = 6;season_i=3;
              date_i = {'2011-06-26'};flight_name='B613';
          elseif ref_number == 669   %average of 609 611 612 613: Aged 
              lat_i = 23.79; lon_i= -10.2; height_i= 400;lev_i = 6;season_i=3;
              date_i = {'2011-06-24', '2011-06-25','2011-06-26'};flight_name='609-613 Aged MAU';
          elseif ref_number == 665  %average of 605 and 606:Aged cold pool Atlas
              lat_i = 23.4; lon_i= -9.54; height_i= 400;lev_i = 6;season_i=3;
              date_i = {'2011-06-21'};flight_name='605-606 Aged Atlas';
          elseif ref_number == 6652000  %average of 605 and 606:Aged cold pool Atlas
              lat_i = 23.5; lon_i= -9.79; height_i= 2000;lev_i = 16;season_i=3;
              date_i = {'2011-06-21'};flight_name=' B605-606';
          elseif ref_number == 6653000  %average of 605 and 606:Aged cold pool Atlas
              lat_i = 23.5; lon_i= -9.52; height_i= 3000;lev_i = 18;season_i=3;
              date_i = {'2011-06-21'};flight_name=' B605-606';
          elseif ref_number == 6654000  %average of 605 and 606:Aged cold pool Atlas
              lat_i = 23.5; lon_i= -9.79; height_i= 4000;lev_i = 20;season_i=3;
              date_i = {'2011-06-21'};flight_name=' B605-606';
          elseif ref_number == 6692000  %average of 609-613
              lat_i = 23.79; lon_i= -10.3; height_i= 2000;lev_i = 16;season_i=3;
              date_i = {'2011-06-24','2011-06-25','2011-06-26'};flight_name=' B609&611-613';
          elseif ref_number == 6693000  %average of 609-613
              lat_i = 25.03; lon_i= -8.3; height_i= 3000;lev_i = 18;season_i=3;
              date_i = {'2011-06-24','2011-06-25','2011-06-26'};flight_name=' B609&611-613';
          elseif ref_number == 6694000  %average of 609-613
              lat_i = 22.9; lon_i= -11.5; height_i= 4000;lev_i = 20;season_i=3;
              date_i = {'2011-06-24','2011-06-25','2011-06-26'};flight_name=' B609&611-613';
          end
end


function [lat,lon,lev] = read_ensemble_metinfo(inDir)
% this function read the geopotential height from CESM output
        
%         infile = sprintf('%s/CESM_metinfo_wZ3.nc',inDir);
%         lat=double(ncread(infile,'/lat'));
%         lon=double(ncread(infile,'/lon'));
%         %lev=double(ncread(infile,'/lev'));  %hpa   56 layer from 1.86 to 992 hpa
%         GH = double(ncread(infile,'/Z3')); %m   geopotential height  
        
        
        infile2 = sprintf('%s/Yemi/AllModels_CommonBin_3D_modelPSD_seas.nc', inDir); 
        %ncdisp(infile);
        %[nmodel,nD,lon,lat,lev,season], [6 6 144 96 48 4]
        % seasons = "DJF_MAM_JJA_SON";
        % models  = "GISS_WRFChem_CESM_GEOSChem_CNRM_IMPACT";
        % D       = [0.1 1 2.5 5 10 14 20]
        %dust_psd = double(ncread(infile,'/dust_mass_fraction')); %[nmodel,nD,lon,lat,lev,season]
        lat = double(ncread(infile2,'/lat'));
        lon = double(ncread(infile2,'/lon'));
        lev = double(ncread(infile2,'/lev'));  %pressure 48 layer from 992 hpa to 10hpa
 end