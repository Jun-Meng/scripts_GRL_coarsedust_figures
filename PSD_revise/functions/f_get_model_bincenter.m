function [model_bin_center,model_bin_space_dlnD] = f_get_model_bincenter (model_bin_edg) 
% this function will calculate model bin center according to their bin edges 
% input:  model bin edges
% input:  model bin edge (model_bin_edg) (1 x bin_number)
% output: model bin center and bin spacing dlnD
% use geometric center c = sqrt(a*b)


    % calculate model bin spcing and center
    for ii=1:(length(model_bin_edg)-1)
        model_bin_space(ii) =  model_bin_edg(ii+1) - model_bin_edg(ii);
        %model_bin_center(ii)= model_bin_edg(ii) + model_bin_space(ii)/2;
        model_bin_center(ii)= sqrt(model_bin_edg(ii)*model_bin_edg(ii+1)); %geometric center
        model_bin_space_dlnD(ii) = log(model_bin_edg(ii+1)) - log(model_bin_edg(ii));
    end
    
end