
function [dPosX, dPosY, dDirX, dDirY, nSample] = generate_boundingbox (dPosSrcX, dPosSrcY, ...
                                                                        dPosDctX, dPosDctY, ...
                                                                        dPosImgBY, dPosImgTY, dPosImgLX, dPosImgRX, ...
                                                                        dSample)

dPosImgBX   = (dPosDctX*(dPosImgBY - dPosSrcY) + dPosSrcX*(dPosDctY - dPosImgBY))/((dPosImgBY - dPosSrcY) + (dPosDctY - dPosImgBY));
dPosImgTX   = (dPosDctX*(dPosImgTY - dPosSrcY) + dPosSrcX*(dPosDctY - dPosImgTY))/((dPosImgTY - dPosSrcY) + (dPosDctY - dPosImgTY));

dPosImgLY   = (dPosDctY*(dPosImgLX - dPosSrcX) + dPosSrcY*(dPosDctX - dPosImgLX))/((dPosImgLX - dPosSrcX) + (dPosDctX - dPosImgLX));
dPosImgRY   = (dPosDctY*(dPosImgRX - dPosSrcX) + dPosSrcY*(dPosDctX - dPosImgRX))/((dPosImgRX - dPosSrcX) + (dPosDctX - dPosImgRX));

DBO         = sqrt(dPosImgBX*dPosImgBX + dPosImgBY*dPosImgBY);
DTO         = sqrt(dPosImgTX*dPosImgTX + dPosImgTY*dPosImgTY);
DLO         = sqrt(dPosImgLX*dPosImgLX + dPosImgLY*dPosImgLY);
DRO         = sqrt(dPosImgRX*dPosImgRX + dPosImgRY*dPosImgRY);

pdlst     	= [DBO, DTO, DLO, DRO]; % B T L R

dminval   	= inf;
nminid1     = -1;

for ilst = 1:4
    if ( dminval > pdlst(ilst) )
        dminval = pdlst(ilst);
        nminid1 = ilst;
    end
end

dminval      = inf;
nminid2      = -1;

for ilst = 1:4
    if (ilst == nminid1)
        continue;
    end
    if ( dminval > pdlst(ilst) )
        dminval = pdlst(ilst);
        nminid2 = ilst;
    end
end

switch (nminid1)
    case 1
        %                 strid1 = 'Bottom';
        dPosMin1X	= dPosImgBX;
        dPosMin1Y	= dPosImgBY;
    case 2
        %                 strid1 = 'Top';
        dPosMin1X	= dPosImgTX;
        dPosMin1Y	= dPosImgTY;
    case 3
        %                 strid1 = 'Left';
        dPosMin1X	= dPosImgLX;
        dPosMin1Y	= dPosImgLY;
    case 4
        %                 strid1 = 'Right';
        dPosMin1X	= dPosImgRX;
        dPosMin1Y	= dPosImgRY;
end
dDSIX	= dPosSrcX - dPosMin1X;
dDSIY	= dPosSrcY - dPosMin1Y;

DSM1    = sqrt(dDSIX*dDSIX + dDSIY*dDSIY);

switch (nminid2)
    case 1
        %                 strid2 = 'Bottom';
        dPosMin2X	= dPosImgBX;
        dPosMin2Y	= dPosImgBY;
    case 2
        %                 strid2 = 'Top';
        dPosMin2X	= dPosImgTX;
        dPosMin2Y	= dPosImgTY;
    case 3
        %                 strid2 = 'Left';
        dPosMin2X	= dPosImgLX;
        dPosMin2Y	= dPosImgLY;
    case 4
        %                 strid2 = 'Right';
        dPosMin2X	= dPosImgRX;
        dPosMin2Y	= dPosImgRY;
end
dDSIX	= dPosSrcX - dPosMin2X;
dDSIY	= dPosSrcY - dPosMin2Y;

DSM2    = sqrt(dDSIX*dDSIX + dDSIY*dDSIY);

if (DSM1 < DSM2)
    dPosX   = dPosMin1X;
    dPosY   = dPosMin1Y;
    
    dDirX	= dPosMin2X - dPosMin1X;
    dDirY	= dPosMin2Y - dPosMin1Y;
else
    dPosX   = dPosMin2X;
    dPosY   = dPosMin2Y;
    
    dDirX	= dPosMin1X - dPosMin2X;
    dDirY	= dPosMin1Y - dPosMin2Y;
end

if (dPosMin1X < dPosImgLX && dPosMin2X < dPosImgLX || ...       %% Out of the left
        dPosMin1X > dPosImgRX && dPosMin2X > dPosImgRX || ...   %% Out of the right
        dPosMin1Y < dPosImgBY && dPosMin2Y < dPosImgBY || ...   %% Out of the bottom
        dPosMin1Y > dPosImgTY && dPosMin2Y > dPosImgTY)         %% Out of the top
    
    nSample     = 0;
else
    dDistMinX   = dPosMin1X - dPosMin2X;
    dDistMinY   = dPosMin1Y - dPosMin2Y;
    
    dDiameter   = sqrt(dDistMinX*dDistMinX + dDistMinY*dDistMinY);
    nSample     = ceil(dDiameter/dSample);
end;

end