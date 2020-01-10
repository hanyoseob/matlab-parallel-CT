% Please read the Ch. 3 Image Reconstruction

% Implementation for filtering operator based on Ch. 3 Equation (3.29) & (3.30)
% Filtering operator is implemented by both convolution and FFT versions.
function [pdFltY, pdFlt] = filtering(pdY, param)

pdFltY	= zeros(param.nDctX, param.nView);

% Filter is generated based on Ch.3 Equation (3.29)
pdFlt	= generate_filter(param.dDctX, param.nDctX);

switch param.compute_filtering
    case 'conv'
        % Ch.3 Equation (3.30)
        % CONVOLUTION ver.
        for iview = 0:param.nView-1
            pdFltY(:, iview+1) = convolution1d(pdY(:, iview+1), pdFlt, param.nDctX);
        end
        
    case 'fft'
        % Ch.3 Equation (3.28)
        % FFT ver.
        pdFltY_         = zeros(param.nDctX, 1);
        
        nFlt            = length(pdFlt);
        pdFlt_          = pdFlt;
        pdFlt_(nFlt)    = 0;
        pdFlt_          = fft(pdFlt_);
        
        for iview = 0:param.nView-1
            pdFltY_(:)  = 0;
            
            pdY_    	= pdY(:, iview+1);
            pdY_(nFlt)	= 0;
            pdY_     	= fft(pdY_);
            
            for iflt = 0:nFlt-1
                pdFltY_(iflt+1)	= pdFlt_(iflt+1)*pdY_(iflt+1);
            end
            
            pdFltY_             = ifft(pdFltY_, 'symmetric');
            pdFltY(:, iview+1)  = pdFltY_(nFlt - param.nDctX + 1: nFlt);
        end
end

%%
pdFltY = param.dDctX*pdFltY;

end

