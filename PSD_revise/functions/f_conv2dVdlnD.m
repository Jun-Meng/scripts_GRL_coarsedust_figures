function  [model_dVdlnD,dlnD] = f_conv2dVdlnD(model_dV,model_bin_edge)
% this function convert modelled dV to dV/dlnD
        for ii=1:(length(model_bin_edge)-1)
            dlnD(ii) = log(model_bin_edge(ii+1)) - log(model_bin_edge(ii));  % size: (1 bin_number)
        end
        model_dVdlnD = model_dV ./ dlnD';
end