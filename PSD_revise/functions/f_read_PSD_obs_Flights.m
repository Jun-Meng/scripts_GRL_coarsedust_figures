function [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_i,season_i,flight_name]...
          = f_read_PSD_obs_Flights (inDir,flight_number,YueConvert)
      
% this function returns the observed PSD and location info
% output: 
%    season_i = 1 2 3 4 -> (DJF_MAM_JJA_SON)

    if YueConvert
        % instrument could be 'CDP' or 'PCASPnCDP'
    	instrument= 'PCASPnCDP'   %note: these data were using the unconverted PCASP data, use the _compare_conversion version for the corect one
        file_obs  = sprintf('%s/insitu/psd_Ryder/psd_corrected/Fennec_b%d_%s_converted.csv', inDir, flight_number,instrument);
        
    else
        if flight_number==22 
            file_obs  = sprintf('%s/insitu/psd_Ryder/2013GRL/Fennec_SAL_2500.csv', inDir);
        elseif  flight_number==23
            file_obs  = sprintf('%s/insitu/psd_Ryder/2013GRL/Fennec_SAL_4000.csv', inDir);    
        else 
            instrument= 'PCASPnCDP' 
            file_obs  = sprintf('%s/insitu/psd_Ryder/Fennec_b%d_%s.csv', inDir, flight_number,instrument);
        end
    end

    %instrument= 'PCASPnCDP'     % could be CDP PCASP or PCASPnCDP
    %convertYue = 0;     % use yue's conversion method/ currently only support CDP if turned on conversion
   
    %if convertYue
    %    file_obs  = sprintf('%s/insitu/psd_Ryder/psd_corrected/Fennec_b%d_%s_converted.csv', inDir, flight_number,instrument);
    %else
    %    file_obs  = sprintf('%s/insitu/psd_Ryder/Fennec_b%d_%s.csv', inDir, flight_number,instrument);
    %end
   
    T         = readtable(file_obs,'PreserveVariableNames', true,'ReadVariableNames',0);
    obs_d     = T.Var1; %cellfun(@str2num,T.Var1); %pure numerical csv files, so no strings being read in
    obs_dVdlnD    = T.Var2; %cellfun(@str2num,T.Var2);
    
    %get flight info
    [lat_i, lon_i, height_i, date_i,season_i, flight_name]...
              = f_metinfo_PSD_obs_flight (flight_number);
          
    %get geopotential height      
    [lat_model,lon_model,GH_model] = read_cesm_metinfo_Z3(inDir);
    
    %get lev id according to measurement height
    ind_lat     = dsearchn(lat_model, lat_i);
    ind_lon     = dsearchn(lon_model, lon_i);
    ind_lev     = dsearchn(GH_model(ind_lon,ind_lat,:), height_i);

    
end

function [lat_i, lon_i, height_i,date_i,season_i, flight_name]...
              = f_metinfo_PSD_obs_flight (flight_number)
  %this function provides the detail info of each flight 
  
          if flight_number == 22
              lat_i = 28; lon_i= 360-16; height_i= 2500;   season_i = 3;
              date_i = {'2011-06-17', '2011-06-18', '2011-06-19','2011-06-20','2011-06-21',...
                  '2011-06-22','2011-06-23','2011-06-24','2011-06-25','2011-06-26',...
                  '2011-06-27','2011-06-28'}; 
              ref_name = 'Ryder et al grl. (2013) 2500m';
              flight_name='Fennec_SAL';
         elseif flight_number == 23
              lat_i = 28; lon_i= 360-16; height_i= 4000;    season_i = 3;
              date_i = {'2011-06-17', '2011-06-18', '2011-06-19','2011-06-20','2011-06-21',...
                  '2011-06-22','2011-06-23','2011-06-24','2011-06-25','2011-06-26',...
                  '2011-06-27','2011-06-28'};
              ref_name = 'Ryder et al grl. (2013) 4000m';
              flight_name='Fennec_SAL';
          elseif flight_number == 600
              lat_i = 23.18; lon_i= 360-6.3; height_i= 994; season_i=3;
              date_i = {'2011-06-17'};flight_name='B600';
          elseif flight_number == 601
              lat_i = 23.07; lon_i= 360-6.6; height_i= 1007; season_i=3;
              date_i = {'2011-06-17'};flight_name='B601';
          elseif flight_number == 602
              lat_i = 23.73; lon_i= 360-7.2; height_i= 386; season_i=3;
              date_i = {'2011-06-18'};flight_name='B602';
          elseif flight_number == 610 
              lat_i = 24.35; lon_i= 360-7.0; height_i= 440; season_i=3;
              date_i = {'2011-06-25'};flight_name='B610';
          elseif flight_number == 604
              lat_i = 23.63; lon_i= 360-9.76; height_i= 350;season_i=3;
              date_i = {'2011-06-20'};flight_name='B604';
          elseif flight_number == 605
              lat_i = 23.29; lon_i= 360-9.25; height_i= 330;season_i=3;
              date_i = {'2011-06-21'};flight_name='B605';
          elseif flight_number == 606
              lat_i = 23.5; lon_i= 360-9.8; height_i= 340;season_i=3;
              date_i = {'2011-06-21'};flight_name='B606';
          elseif flight_number == 609
              lat_i = 25.15; lon_i= 360-8.0; height_i= 450;season_i=3;
              date_i = {'2011-06-24'};flight_name='B609';
          elseif flight_number == 611
              lat_i = 22.17; lon_i= 360-11.8; height_i= 450;season_i=3;
              date_i = {'2011-06-25'};flight_name='B611';
          elseif flight_number == 612
              lat_i = 24.0; lon_i= 360-10.5; height_i= 330;season_i=3;
              date_i = {'2011-06-26'};flight_name='B612';
          elseif flight_number == 613
              lat_i = 23.84; lon_i= 360-10.5; height_i= 400;season_i=3;
              date_i = {'2011-06-26'};flight_name='B613';
          elseif flight_number == 669   %average of 609 611 612 613: Aged 
              lat_i = 23.79; lon_i= 360-10.2; height_i= 400;season_i=3;
              date_i = {'2011-06-24', '2011-06-25','2011-06-26'};flight_name='609-613 Aged MAU';
          elseif flight_number == 665  %average of 605 and 606:Aged cold pool Atlas
              lat_i = 23.4; lon_i= 360-9.54; height_i= 400;season_i=3;
              date_i = {'2011-06-21'};flight_name='605-606 Aged Atlas';
          elseif flight_number == 6652000  %average of 605 and 606:Aged cold pool Atlas
              lat_i = 23.5; lon_i= 360-9.79; height_i= 2000;season_i=3;
              date_i = {'2011-06-21'};flight_name=' B605-606';
          elseif flight_number == 6653000  %average of 605 and 606:Aged cold pool Atlas
              lat_i = 23.5; lon_i= 360-9.52; height_i= 3000;season_i=3;
              date_i = {'2011-06-21'};flight_name=' B605-606';
          elseif flight_number == 6654000  %average of 605 and 606:Aged cold pool Atlas
              lat_i = 23.5; lon_i= 360-9.79; height_i= 4000;season_i=3;
              date_i = {'2011-06-21'};flight_name=' B605-606';
          elseif flight_number == 6692000  %average of 609-613
              lat_i = 23.79; lon_i= 360-10.3; height_i= 2000;season_i=3;
              date_i = {'2011-06-24','2011-06-25','2011-06-26'};flight_name=' B609&611-613';
          elseif flight_number == 6693000  %average of 609-613
              lat_i = 25.03; lon_i= 360-8.3; height_i= 3000;season_i=3;
              date_i = {'2011-06-24','2011-06-25','2011-06-26'};flight_name=' B609&611-613';
          elseif flight_number == 6694000  %average of 609-613
              lat_i = 22.9; lon_i= 360-11.5; height_i= 4000;season_i=3;
              date_i = {'2011-06-24','2011-06-25','2011-06-26'};flight_name=' B609&611-613';
          end
end


function [lat,lon,GH] = read_cesm_metinfo_Z3(inDir)
% this function read the geopotential height from CESM output
        
        infile = sprintf('%s/CESM_metinfo_wZ3.nc',inDir);
        lat=double(ncread(infile,'/lat'));
        lon=double(ncread(infile,'/lon'));
        %lev=double(ncread(infile,'/lev')); %hpa
        GH = double(ncread(infile,'/Z3')); %m   geopotential height    
 end