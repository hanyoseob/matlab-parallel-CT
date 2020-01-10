% Please read the Ch.3 Image Reconstruction

% Implementation for projection operator based on Ch.3 Equation (3.5) & (3.6)
% Projection operator is implemented using ray-driven method
function pdY = projection(pdX, param, bfig)

if nargin < 3
    bfig = false;
end

if bfig
    figure('name', 'projection' ); colormap gray;
end

dSizeImgX   = param.nImgX*param.dImgX;
dSizeImgY   = param.nImgY*param.dImgY;

dDiameter   = sqrt(dSizeImgY*dSizeImgY + dSizeImgX*dSizeImgX);
dRadius     = 0.5*dDiameter;

dSample     = min(param.dImgY, param.dImgX);
nSample     = ceil(dDiameter/dSample);

pdY         = zeros(param.nDctX, param.nView, 'like', pdX);

% Ch.3 Equation (3.6)
% Projection operator
for iview = 0:param.nView-1
    
    % Rotation angle for geometry
    dBeta   = iview*param.dView;
    
    for idctx = 0:param.nDctX-1
        
        % Initial X-ray source position [mm, mm]
        dOriImgX       = id2pos(idctx + param.dOffsetDctX, param.dDctX, param.nDctX);
        dOriImgY       = -dRadius;
        
        dGamma      = 0;
        
        % Normal vector of incident X-ray [mm, mm] 
        dOriNorDirX	= dSample*sind(dGamma);
        dOriNorDirY = dSample*cosd(dGamma);
        
        % Ch.3 Equation (3.5)
        % Rotated X-ray source position [mm, mm]
        dPosImgX    = cosd(dBeta)*dOriImgX + sind(dBeta)*dOriImgY;
        dPosImgY    = -sind(dBeta)*dOriImgX + cosd(dBeta)*dOriImgY;
        
        % Ch.3 Equation (3.5)
        % Rotated normal vector of incident X-ray [mm, mm]
        dNorDirX	= cosd(dBeta)*dOriNorDirX + sind(dBeta)*dOriNorDirY;
        dNorDirY	= -sind(dBeta)*dOriNorDirX + cosd(dBeta)*dOriNorDirY;
        
        dCurY       = 0;
        
        
        % Ch.3 Equation (3.6)
        % Line Integration along the s-axis
        for ismp = 0:nSample-1
            
            % Sampleing position via X-ray penetrated along Object
            dCurIdImgX  = pos2id(dPosImgX + ismp*dNorDirX, param.dImgX, param.nImgX) - param.dOffsetImgX + 1;
            dCurIdImgY	= pos2id(dPosImgY + ismp*dNorDirY, param.dImgY, param.nImgY) - param.dOffsetImgY + 1;
            
            if (dCurIdImgX <= 1 || dCurIdImgY <= 1 || dCurIdImgX >= param.nImgX || dCurIdImgY >= param.nImgY)
                continue;
            end
            
            % 2D interpolation 
            dCurY_      = interpolation2d(pdX, dCurIdImgY, dCurIdImgX);
            dCurY       = dCurY + dCurY_;
        end
        
        pdY(idctx + 1, iview + 1) = dCurY;
        
    end
    
    if bfig
        imagesc(pdY);   title([num2str(iview + 1) ' / ' num2str(param.nView)]);
        axis image;
        xlabel('angle'); ylable('detector');
        drawnow();
    end
end

%%
pdY = dSample*pdY;

end
