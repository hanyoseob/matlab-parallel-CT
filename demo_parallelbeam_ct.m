clear ;
close all;

%%
restoredefaultpath();
addpath('./lib');
addpath('./util');

%% X-ray CT System parameter
% dAngle: Measure from 0 until the angle [degree (float)]
% nView	: # of the views [element (uint)]
% dView	: Gap between view_(k) - view_(k-1) [degree (float)]
% DSO   : Distance from the Source to the Object    [mm (float)]
% DSD 	: Distance from the Source to the Detector  [mm (float)]
param.dAngle        = 360;  % degree
param.nView         = 360; 	% # of unit
param.dView         = param.dAngle/param.nView;  % degree
param.DSO           = 400 ; % mm
param.DSD           = 800;  % mm

%% X-ray detector parameter
% dDctX             : Detector pitch [mm (float)]
% nDctX             : Number of detector [element (uint)]
% dOffsetDctX       : Index of shifted detector [element (float; +, -)]
% compute_filtering	: Filtering method, choise=['conv', 'fft' (string)]
param.dDctX         = 0.7;  % mm

param.nDctX         = 400;  % # of elements

param.dOffsetDctX   = 30; 	% # of elements

param.compute_filtering = 'fft';   % method for computing the filtering function : 'conv', 'fft'

%% Object parameter
% dImgY             : Pixel resolution [mm (float)]
% dImgX             : Pixel resolution [mm (float)]
% nImgY             : Matrix size of image [element (uint)]
% nImgX             : Matrix size of image [element (uint)]
% dOffsetImgY       : Index of shifted image [element (float; +, -)]
% dOffsetImgX       : Index of shifted image [element (float; +, -)]
param.dImgY         = 1;    % mm
param.dImgX         = 1;    % mm

param.nImgY         = 256;  % # of elements
param.nImgX         = 256;  % # of elements

param.dOffsetImgY	= 0;    % # of elements
param.dOffsetImgX   = 0;    % # of elements

param.datatype      = 'float';

%% Load image
fid                 = fopen('input512.raw', 'rb');
input               = imresize(single(fread(fid, [512, 512], 'single')), [param.nImgY, param.nImgX]);
fclose(fid);

%% Run implemented function
disp ('implementation ver.')

disp ('projection - implementation of Ch.3 Equation (3.5) & (3.6)');
tic;
prj         = projection(input, param);
toc;

disp ('filtering - implementation of Ch.3 Equation (3.21) & (3.29) & (3.30)');
tic;
prj_flt  	= filtering(prj, param);
toc;

disp ('backprojection - implementation of Ch.3 Equation (3.22)');
tic;
output   	= backprojection(prj_flt, param);
toc;

%% Display reconstruction images
wndImg      = [0, max(input(:))];

figure('name', 'parallel-beam CT'); colormap gray;
subplot(2,3,1);     imagesc(input, wndImg);     	
                axis image;     xlabel('X-axis'); 	ylabel('Y-axis');	title('ground truth');
subplot(2,3,2);     imagesc(output, wndImg);
                axis image;     xlabel('X-axis'); 	ylabel('Y-axis');	title(['reconstruction_{implementation, # of view = ' num2str(param.nView) '}']);
subplot(2,3,3);     imagesc(input - output);
                axis image;     xlabel('X-axis'); 	ylabel('Y-axis');	title({'difference', 'ground truch - reconstruction'});
subplot(2,3,[4,6]); imagesc(prj);  
                    xlabel(['Angle ( \Delta\theta : ' num2str(param.dView) ' \circ )']);	ylabel('Detector');	title(['sinogram_{implementation, # of view = ' num2str(param.nView) '}']);
                    ax              = gca;
                    ax.XTick        = linspace(0, param.nView, 10);
                    ax.XTickLabel	= linspace(0, param.dAngle, 10);