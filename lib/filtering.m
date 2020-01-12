% Please read the Ch.3 Image Reconstruction

% Implementation for filtering operator based on Ch.3 Equation (3.21) & (3.29) & (3.30)
% Filtering operator is implemented by both convolution and FFT versions.
function [pdOut, pdFlt] = filtering(pdIn, param)

pdOut	= zeros(param.nDctX, param.nView, 'like', pdIn);

% Filter is generated based on Ch.3 Equation (3.29)
pdFlt	= generate_filter(param.dDctX, param.nDctX);

switch param.compute_filtering
    case 'conv'
        % Ch.3 Equation (3.30)
        % CONVOLUTION ver.
        for iview = 0:param.nView-1
%             pdOut(:, iview+1) = convolution1d(pdIn(:, iview+1), pdFlt, param.nDctX);
            pdOut(:, iview+1) = conv(pdIn(:, iview+1), pdFlt, 'same');
        end
        
    case 'fft'
        % Ch.3 Equation (3.21)
        % FFT ver.
        nFlt            = length(pdFlt);
        
        len            = 2^(ceil(log2(2*param.nDctX)));
        pdFlt(len)     = 0;
        pdFlt_          = fft(pdFlt);
        
        for iview = 0:param.nView-1
            
            pdIn_    	= pdIn(:, iview+1);
            pdIn_(len)	= 0;
            pdIn_     	= fft(pdIn_);
            
            pdOut_      = pdFlt_.*pdIn_;
            
            pdOut_              = ifft(pdOut_, 'symmetric');
%             pdOut(:, iview+1)	= pdOut_(nFlt - param.nDctX + 1: nFlt);
            pdOut(:, iview+1)	= pdOut_(param.nDctX:2*param.nDctX - 1);
        end
end

end

