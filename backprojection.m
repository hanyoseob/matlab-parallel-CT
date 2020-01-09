function pdX = backprojection(pdY, param, bfig)

if nargin < 3
    bfig = false;
end

if bfig
    figure('name', 'backprojection'); colormap gray;
end

pdX         = zeros(param.nImgY, param.nImgX, 'like', pdY);
dCurX       = zeros(param.nImgY, param.nImgX, 'like', pdY);

for iview = 0:param.nView-1
    
    dBeta       = -iview*param.dView;
    dCurX(:)	= 0;
    
    
    for iimgx = 0:param.nImgX-1
        dPosImgX    = id2pos(iimgx + param.dOffsetImgX, param.dImgX, param.nImgX);
        
        for iimgy = 0:param.nImgY-1
            dPosImgY    = id2pos(iimgy + param.dOffsetImgY, param.dImgY, param.nImgY);
            
            
            dRadius     = sqrt(dPosImgY*dPosImgY + dPosImgX*dPosImgX);
            dPhi        = atan2d(dPosImgY, dPosImgX);
            
            dDistY      = dRadius*cosd(dBeta - dPhi);
            
            nCurIdDctX    = pos2id(dDistY, param.dDctX, param.nDctX) - param.dOffsetDctX + 1;
            
            if (nCurIdDctX <= 1 || nCurIdDctX >= param.nDctX)
                continue;
            end
            
            nPreIdDctX	= floor(nCurIdDctX);
            nPostIdDctX	= nPreIdDctX + 1;
            
            dCurX_      = interpolation1d(pdY(:, iview + 1), nCurIdDctX, nPreIdDctX, nPostIdDctX);
            
            dCurX(iimgy + 1, iimgx + 1) = dCurX_;
        end
    end
    
    pdX	= pdX + dCurX;
    
    if bfig
        imagesc(pdX);   title([num2str(iview + 1) ' / ' num2str(param.nView)]);
        xlabel('x-axis'); ylable('y-axis');
        drawnow();
    end
end

end
