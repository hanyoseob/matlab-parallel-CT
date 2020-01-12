% Please read the Ch.3 Image Reconstruction

% Implementation for backprojection operator based on Ch.3 Equation (3.22)
% Backprojection operator is implemented using pixel-driven method
function pdOut = backprojection(pdIn, param, bfig)

if nargin < 3
    bfig = false;
end

if bfig
    figure('name', 'backprojection'); colormap gray;
end

pdOut   = zeros(param.nImgY, param.nImgX, 'like', pdIn);
pdOut_	= zeros(param.nImgY, param.nImgX, 'like', pdIn);

% Ch.3 Equation (3.22)
% Backprojection operator
for iview = 0:param.nView-1
    
    % Rotation angle for geometry
    dBeta       = -iview*param.dView;
    pdOut_(:)	= 0;
    
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
            
            pdOut_(iimgy + 1, iimgx + 1)	= interpolation1d(pdIn(:, iview + 1), nCurIdDctX, param.nDctX);
            
        end
    end
    
    pdOut	= pdOut + pi/param.nView*pdOut_;
    
    if bfig
        imagesc(pdOut);   title([num2str(iview + 1) ' / ' num2str(param.nView)]);
        axis image;
        xlabel('x-axis'); ylable('y-axis');
        drawnow();
    end
end

end
