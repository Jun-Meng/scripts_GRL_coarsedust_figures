function [obs_d, obs_dVdlnD, ind_lat, ind_lon, ind_lev, date_i, season_i, ref_name] = f_read_PSD_obs_Refs (inDir, ref_number)
%  this function will read the observed atmospheric dust PSD from a compilation dataset by YEMI
%  output: 
%    season_i = 1 2 3 4 -> (DJF_MAM_JJA_SON)

% notes on the refs:
    % Ref1: Chou et al.     (2008) B160N3; Ref2: Chou et al.     (2008) B165N7;
    % Ref3: d'Almeida       (1987);        Ref4: Kandler et al.  (2011);        
    % Ref5: Weinzierl et al.(2009) L02;    Ref6: Weinzierl et al.(2009) L07; 
    % Ref7: Wagner et al    (2009) 2300m;  Ref8: Wagner et al    (2009) 3245m;
    % Ref9: Clarke et al    (2004) 250m;   Ref10:Clarke et al    (2004) 700m;  
    % Ref11:Kandler et al.  (2009);        Ref12:Jung et al      (2013) Day1;
    % Ref13:Jung et al      (2013) Day2;   Ref14:Ryder et al     (2013b);
    % Ref15:McConnell et al.(2008);        Ref16:Weinzierl et al (2017) CV;
    % Ref17:Weinzierl et al (2017) BD;     Ref18:Otto et al      (2007)2700m
    % Ref19:Otto et al      (2007)4000m;   Ref20:Otto et al      (2007)5500m;
    % Ref21:Otto et al      (2007)7000m;   Ref22:Ryder et al     (2013)2500m;
    % Ref23:Ryder et al     (2013)4000m;   Ref24:Ryder et al     (2013)5500m;
    % Ref25:Ryder et al     (2013)6000m;   Ref26:Ryder et al     (2018)2500m;
    % Ref27:Ryder et al     (2018)4000m;   Ref28:Ryder et al     (2018)5500m; 
    % Ref29:Ryder et al     (2018)6000m; 

    %read in YEMI's PSD measurements compilation
    file_obs  = sprintf('%s/insitu/psd_measurements_origi_From_yemi.csv', inDir);
    %matlab2019
    %T = readtable(file_obs,'PreserveVariableNames', true,'ReadVariableNames',0);
    %matlab2020
    T = readtable(file_obs,'Format','auto','PreserveVariableNames', true,'ReadVariableNames',0);
    Index_ref = find(contains(T.Var1,'Reference'));       % find the index of lines with "Reference"
    
    % this loop calculate the number of observations in each reference
    for i=1:(length(Index_ref)-1)
        n_eachObs(i)  =  Index_ref(i+1)-Index_ref(i)-2;      % 2 represents the two heading lines
    end
        n_eachObs(29) = length(T.Var1) - Index_ref(end) -1;  % 1 represents the Reference line
    idx_ref = (Index_ref(ref_number)+2):(Index_ref(ref_number) + n_eachObs(ref_number)+1); % this is the indexes of the obs in each reference
   
    obs_d   = cellfun(@str2num,T.Var1(idx_ref));
    obs_dVdlnD  = cellfun(@str2num,T.Var2(idx_ref));
    [lat_i, lon_i, height_i, date_i, season_i, ref_name] = metinfo_PSD_obs (ref_number);
     
    %get geopotential height      
    [lat_model,lon_model,GH_model] = read_cesm_metinfo_Z3(inDir);
   
    %get lev id according to measurement height
    ind_lat     = dsearchn(lat_model, lat_i);
    ind_lon     = dsearchn(lon_model, lon_i);
    ind_lev     = dsearchn(GH_model(ind_lon,ind_lat,:), height_i);
end

function [lat_i, lon_i, height_i, date_i, season_i, ref_name] = metinfo_PSD_obs (ref_number)
 % this function will output the met info for the observations, e.g. lat, lon, height
  %note here height need to convert to pressure in the future
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
    elseif ref_number == 7
        lat_i = 38; lon_i= 360-7.9 ; height_i= 2300; lev_i = 40; season_i = 2;
        ref_name = 'Wagner et al. (2009) 2300m';
        date_i = {'2006-05-27'};   %real: 2006
    elseif ref_number == 8
        lat_i = 38; lon_i= 360-7.9 ; height_i= 3245; lev_i = 36; season_i = 2;
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
        %date_i = {'2006-05-13','2006-05-14','2006-05-15','2006-05-16','2006-05-17','2006-05-18','2006-05-19','2006-05-20','2006-05-21',...
        %          '2006-05-22','2006-05-23','2006-05-24','2006-05-25','2006-05-26','2006-05-27','2006-05-28','2006-05-28','2006-05-29',...
        %           '2006-05-30','2006-05-31','2006-06-01','2006-06-02','2006-06-03','2006-06-04'};
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
       % date_i = {'2011-06-17'}
       % date_i = {'2011-06-01','2011-06-02','2011-06-03','2011-06-04','2011-06-05',...
        %          '2011-06-06','2011-06-07', '2011-06-08','2011-06-09','2011-06-10',...
         %         '2011-06-11','2011-06-12','2011-06-13','2011-06-14','2011-06-15',...
         %         '2011-06-16','2011-06-17','2011-06-18','2011-06-19','2011-06-20',...
         %         '2011-06-21','2011-06-22','2011-06-23','2011-06-24','2011-06-25',...
         %         '2011-06-26','2011-06-27','2011-06-28','2011-06-29','2011-06-30'}
        ref_name = 'Ryder et al. (2013b)';
    elseif ref_number == 15 
    %B238 run 4.1 at 1km land regions in northern Mauritania/ 
    %sample heavy dust loadings over land in Mauritania forecast by dust models and visible in
        lat_i = 19; lon_i= 360-12; height_i= 1000; lev_i = 49; season_i = 'JJA';
        date_i = {'2006-08-23'};
        ref_name = 'McConnell et al. (2008)';
    elseif ref_number == 16
        % The air mass studied in the Cabo Verde region (blue symbols) on 17 Jun 2013
        % 17 June 2013
        lat_i = 15; lon_i= 360-23; height_i= 2600; lev_i = 40:41; season_i = 3;
        date_i = {'2011-06-17'};   %real : 2013
        ref_name = 'Weinzierl et al (2017) CV';
    elseif ref_number == 17
        % 22 June 2013
        lat_i = 12; lon_i= 360-60; height_i= 2300; lev_i = 41:42; season_i = 3;
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
    elseif ref_number == 22
        lat_i = 28; lon_i= 360-16; height_i= 2500; lev_i = 41;    season_i = 3;
        date_i = {'2011-06-17', '2011-06-18', '2011-06-19','2011-06-20','2011-06-21',...
                  '2011-06-22','2011-06-23','2011-06-24','2011-06-25','2011-06-26',...
                  '2011-06-27','2011-06-28'}; 
        ref_name = 'Ryder et al. (2013) 2500m';
    elseif ref_number == 23
        lat_i = 28; lon_i= 360-16; height_i= 4000; lev_i = 36;    season_i = 3;
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
    else
        disp('ref_number should be between 1 and 29 currently')
    end
end

function [lat,lon,GH] = read_cesm_metinfo_Z3(inDir)
% this function read the geopotential height from CESM output
        
        infile = sprintf('%s/CESM_metinfo_wZ3.nc',inDir);
          lat=double(ncread(infile,'/lat'));
        lon=double(ncread(infile,'/lon'));
        %lev=double(ncread(infile,'/lev')); %hpa   56 layer from 1.86 to 992 hpa
        GH = double(ncread(infile,'/Z3')); %m   geopotential height  from  
        
       
end
 

