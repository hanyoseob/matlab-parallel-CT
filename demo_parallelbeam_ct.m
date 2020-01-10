clear ;
close all;

%%
restoredefaultpath();
addpath('./lib');

%% X-ray CT System parameter
% dAngle: Measure from 0 until the angle [degree]
% nView	: # of the views [unit]
% dView	: Gap between view_(k) - view_(k-1) [degree]
% DSO   : Distance from the Source to the Object    [mm]
% DSD 	: Distance from the Source to the Detector  [mm]
param.dAngle        = 360;  % degree
param.nView         = 180; 	% # of unit
param.dView         = param.dAngle/param.nView;  % degree
param.pdView        = linspace(0, param.dAngle - param.dAngle/param.nView, param.nView);
param.DSO           = 400 ; % mm
param.DSD           = 800;  % mm

%% X-ray detector parameter
% dDctX             : Detector pitch [mm]
% nDctX             : Number of detector [element (int)]
% dOffsetDctX       : Index of shifted detector [element (float)]
% compute_filtering	: Filtering method, choise=['conv', 'fft']
param.dDctX         = 0.7;  % mm

param.nDctX         = 400;  % # of elements

param.dOffsetDctX   = 50; 	% # of elements

param.compute_filtering = 'fft';   % method for computing the filtering function : 'conv', 'fft'

%% Object parameter
% dImgY             : Pixel resolution [mm]
% dImgX             : Pixel resolution [mm]
% nImgY             : Matrix size of image [element (int)]
% nImgX             : Matrix size of image [element (int)]
% dOffsetImgY       : Index of shifted image [element (float)]
% dOffsetImgX       : Index of shifted image [element (float)]
param.dImgY         = 1;    % mm
param.dImgX         = 1;    % mm

param.nImgY         = 256;  % # of elements
param.nImgX         = 256;  % # of elements

param.dOffsetImgY	= 0;    % # of elements
param.dOffsetImgX   = 0;    % # of elements

%% Load image
load('XCAT512.mat');
input                 = imresize(XCAT512, [param.nImgY, param.nImgX]);

%% Run implemented function
disp ('implementation ver.')

disp ('projection - implementation of Ch.3 Equation (3.5) & (3.6)');
tic;
prj         = projection(input, param);
toc;

disp ('filtering - implementation of Ch.3 Equation (3.29) & (3.30)');
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