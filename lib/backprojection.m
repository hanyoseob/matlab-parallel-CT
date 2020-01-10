% Please read the Ch.3 Image Reconstruction

% Implementation for backprojection operator based on Ch.3 Equation (3.22)
% Backprojection operator is implemented using pixel-driven method
function pdX = backprojection(pdY, param, bfig)

if nargin < 3
    bfig = false;
end

if bfig
    figure('name', 'backprojection'); colormap gray;
end

pdX         = zeros(param.nImgY, param.nImgX, 'like', pdY);
dCurX       = zeros(param.nImgY, param.nImgX, 'like', pdY);

% Ch.3 Equation (3.22)
% Backprojection operator
for iview = 0:param.nView-1
    
    % Rotation angle for geometry
    dBeta       = -iview*param.dView;
    dCurX(:)	= 0;
    
    for iimgx = 0:param.nImgX-1
        
        % X position of object
        dPosImgX    = id2pos(iimgx + param.dOffsetImgX, param.dImgX, param.nImgX);
        
        for iimgy = 0:param.nImgY-1
            
            % Y position of object
            dPosImgY    = id2pos(iimgy + param.dOffsetImgY, param.dImgY, param.nImgY);
            
            % Calculate a detector position based on Figure 3.34
            dRadius     = sqrt(dPosImgY*dPosImgY + dPosImgX*dPosImgX);
            dPhi        = atan2d(dPosImgY, dPosImgX);
            
            % Detector position related with (X, Y) position of object
            dDistX      = dRadius*cosd(dBeta - dPhi);
            
            nCurIdDctX   = pos2id(dDistX, param.dDctX, param.nDctX) - param.dOffsetDctX + 1;
            
            if (nCurIdDctX < 1 || nCurIdDctX > param.nDctX)
                continue;
            end
            
            dCurX_      = interpolation1d(pdY(:, iview + 1), nCurIdDctX);
            
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

%%
pdX = pi/param.nView*pdX;

end
