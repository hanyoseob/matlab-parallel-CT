% Please read the Ch.3 Image Reconstruction
%
% Implementation for projection operator based on Ch.3 Equation (3.5) & (3.6)
% Projection operator is implemented using ray-driven method
function pdOut = projection(pdIn, param, bfig)

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

pdOut       = zeros(param.nDctX, param.nView, 'like', pdIn);

% Ch.3 Equation (3.6)
% Projection operator
for iview = 0:param.nView-1
    
    % Rotation angle for geometry
    dBeta   = iview*param.dView;
    
    for idctx = 0:param.nDctX-1
        
        % Initial X-ray source position [mm, mm]
        dOriImgY       = -dRadius;
        dOriImgX       = id2pos(idctx + param.dOffsetDctX, param.dDctX, param.nDctX);
        
        dGamma      = 0;
        
        % Normal vector of incident X-ray [mm, mm]
        dOriNorDirY = dSample*cosd(dGamma);
        dOriNorDirX	= dSample*sind(dGamma);
        
        % Ch.3 Equation (3.5)
        % Rotated X-ray source position [mm, mm]
        dPosImgY    = -sind(dBeta)*dOriImgX + cosd(dBeta)*dOriImgY;
        dPosImgX    = cosd(dBeta)*dOriImgX + sind(dBeta)*dOriImgY;
        
        % Ch.3 Equation (3.5)
        % Rotated normal vector of incident X-ray [mm, mm]
        dNorDirY	= -sind(dBeta)*dOriNorDirX + cosd(dBeta)*dOriNorDirY;
        dNorDirX	= cosd(dBeta)*dOriNorDirX + sind(dBeta)*dOriNorDirY;
        
        pdOut_	= 0;
        
        % Ch.3 Equation (3.6)
        % Line Integration along the s-axis
        for ismp = 0:nSample-1
            
            % Sampleing position via X-ray penetrated along Object
            dCurIdImgY	= pos2id(dPosImgY + ismp*dNorDirY, param.dImgY, param.nImgY) - param.dOffsetImgY + 1;
            dCurIdImgX  = pos2id(dPosImgX + ismp*dNorDirX, param.dImgX, param.nImgX) - param.dOffsetImgX + 1;
            
            % 2D interpolation
            pdOut_	= pdOut_ + interpolation2d(pdIn, [dCurIdImgY, dCurIdImgX], [param.nImgY, param.nImgX]);
        end
        
        pdOut(idctx + 1, iview + 1) = dSample*pdOut_;
        
    end
    
    if bfig
        imagesc(pdOut);   title([num2str(iview + 1) ' / ' num2str(param.nView)]);
        axis image;
        xlabel('angle'); ylable('detector');
        drawnow();
    end
end

end
