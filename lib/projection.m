function pdY = projection(pdX, param, bfig)

if nargin < 3
    bfig = false;
end

if bfig
    figure('name', 'projection' ); colormap gray;
end

dSizeImgX   = param.nImgX*param.dImgX;
dSizeImgY   = param.nImgY*param.dImgY;

dDiameter   = sqrt(dSizeImgX*dSizeImgX + dSizeImgY*dSizeImgY);
dRadius     = 0.5*dDiameter;

dSample     = min(param.dImgX, param.dImgY);
nSample     = ceil(dDiameter/dSample);

pdY         = zeros(param.nDctX, param.nView, 'like', pdX);

for iview = 0:param.nView-1
    
    dBeta   = -iview*param.dView;
    
    for idctx = 0:param.nDctX-1
        
        dOriImgX       = id2pos(idctx + param.dOffsetDctX, param.dDctX, param.nDctX);
        dOriImgY       = -dRadius;
        
        dGamma      = 0;
        
        dOriNorDirY = dSample*cosd(dGamma);
        dOriNorDirX	= dSample*sind(dGamma);
        
        dNorDirX	= cosd(dBeta)*dOriNorDirX - sind(dBeta)*dOriNorDirY;
        dNorDirY	= sind(dBeta)*dOriNorDirX + cosd(dBeta)*dOriNorDirY;
        
        dPosImgX    = cosd(dBeta)*dOriImgX - sind(dBeta)*dOriImgY;
        dPosImgY    = sind(dBeta)*dOriImgX + cosd(dBeta)*dOriImgY;
        
        dCurY       = 0;
        
        for ismp = 0:nSample-1
            
            nCurIdImgX  = pos2id(dPosImgX + ismp*dNorDirX, param.dImgX, param.nImgX) - param.dOffsetImgX + 1;
            nCurIdImgY	= pos2id(dPosImgY + ismp*dNorDirY, param.dImgY, param.nImgY) - param.dOffsetImgY + 1;
            
            if (nCurIdImgX <= 1 || nCurIdImgY <= 1 || nCurIdImgX >= param.nImgX || nCurIdImgY >= param.nImgY)
                continue;
            end
            
            nPreIdImgX 	= floor(nCurIdImgX);
            nPostIdImgX	= nPreIdImgX + 1;
            
            nPreIdImgY	= floor(nCurIdImgY);
            nPostIdImgY	= nPreIdImgY + 1;
            
            dCurY_      = interpolation2d(pdX, nCurIdImgY, nPreIdImgY, nPostIdImgY, nCurIdImgX, nPreIdImgX, nPostIdImgX);
            dCurY       = dCurY + dCurY_;
        end
        
        pdY(idctx + 1, iview + 1) = dSample*dCurY;
        
    end
    
    if bfig
        imagesc(pdY);   title([num2str(iview + 1) ' / ' num2str(param.nView)]);
        xlabel('angle'); ylable('detector');
        drawnow();
    end
end

end
