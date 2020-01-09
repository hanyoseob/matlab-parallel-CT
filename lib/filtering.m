function [pdFltY, pdFlt] = filtering(pdY, param)

pdFltY	= zeros(param.nDctX, param.nView);
pdFlt	= generate_filter(param.dDctX, param.nDctX);

switch param.compute_filtering
    case 'conv'
        %% CONVOLUTION ver.
        for iview = 0:param.nView-1
            pdFltY(:, iview+1) = convolution1d(pdY(:, iview+1), pdFlt, param.nDctX);
        end
        
    case 'fft'
        %% FFT ver.
        pdFltY_         = zeros(param.nDctX, 1);
        
        % nFlt            = max(64,2^nextpow2(2*length(pdFlt)));
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
pdFltY = pi/param.nView*param.dDctX*pdFltY;

end

