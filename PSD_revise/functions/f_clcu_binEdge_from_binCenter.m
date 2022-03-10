function [binE,dlnD] = f_clcu_binEdge_from_binCenter (binC) 
% this function calculates bin edges from the value of bin centers. 
% input:  bin centers (binC)  should be in 1 column 
% output: bin edges   (binE) and bin log space (dlnD) 
% NOTE: THERE IS A BUG IF USING THIS TO CALCULATE MODEL BIN EDGES, AVOID IT
% 
    binS = zeros((length(binC)-1),1); % bin spacing, 1 column
    binE = zeros((length(binC)+1),1); % 1 column
    dlnD = zeros(length(binC),1);     % bin log space
    for ii = 1:(length(binC)-1)
        binS(ii) = binC(ii+1) - binC(ii);
        binE(ii+1) = binC(ii) + binS(ii)/2;  %bin edge from the second to the last second
    end
    % this if statement excludes the possibility of calculated binE(1) <= 0
    if (binS(1)/2) >= binC(1)
        binE(1) = 1e-9; %arbitrarily set the lower edge to be a extremely small number
    else
        binE(1) = binC(1) - binS(1)/2;
    end
    binE(end) = binC(end) + binS(end)/2;
    for iii=1:length(binC)
        dlnD(iii)=log(binE(iii+1)) - log(binE(iii));
    end
end