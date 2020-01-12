% Please read the Ch.3 Image Reconstruction

% Implementation for filtering operator based on Ch.3 Equation (3.21) & (3.29) & (3.30)
% Filtering operator is implemented by both convolution and FFT versions.
function [pdOut, pdFlt] = filtering(pdIn, param)

pdOut	= zeros(param.nDctX, param.nView);

% Filter is generated based on Ch.3 Equation (3.29)
pdFlt	= generate_filter(param.dDctX, param.nDctX);

switch param.compute_filtering
    case 'conv'
        % Ch.3 Equation (3.30)
        % CONVOLUTION ver.
        for iview = 0:param.nView-1
%             pdFltY(:, iview+1) = convolution1d(pdY(:, iview+1), pdFlt, param.nDctX);
            pdOut(:, iview+1) = conv(pdIn(:, iview+1), pdFlt, 'same');
        end
        
    case 'fft'
        % Ch.3 Equation (3.21)
        % FFT ver.
        pdOut_          = zeros(param.nDctX, 1);
        
        nFlt            = length(pdFlt);
        pdFlt_          = pdFlt;
        pdFlt_(nFlt)    = 0;
        pdFlt_          = fft(pdFlt_);
        
        for iview = 0:param.nView-1
            pdOut_(:)  = 0;
            
            pdIn_    	= pdIn(:, iview+1);
            pdIn_(nFlt)	= 0;
            pdIn_     	= fft(pdIn_);
            
            for iflt = 0:nFlt-1
                pdOut_(iflt+1)	= pdFlt_(iflt+1)*pdIn_(iflt+1);
            end
            
            pdOut_              = ifft(pdOut_, 'symmetric');
            pdOut(:, iview+1)	= pdOut_(nFlt - param.nDctX + 1: nFlt);
        end
end

end

