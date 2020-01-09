clear ;
close all;

%%
restoredefaultpath();
addpath('./lib');

%% Setting the CT System parameters
% dAngle: Measure from 0 until the angle
% nView	: # of the views [unit]
% dView	: Gap between view_(k) - view_(k-1) [degree]
param.dAngle        = 180;              
param.nView         = 90;              % # of elements
param.dView         = param.dAngle/param.nView;  % degree
param.pdView        = linspace(0, param.dAngle, param.nView + 1);
param.pdView(end)   = [];

% X-ray source
% DSO   : Distance from the Source to the Object    [mm]
% DSD 	: Distance from the Source to the Detector  [mm]
param.DSO           = 400 ; % mm
param.DSD           = 800;  % mm

% X-ray detector
param.dDctX         = 1;    % mm

param.nDctX         = 185;  % # of elements

param.dOffsetDctX   = 0; 	% # of elements

param.compute_filtering = 'fft';   % method for computing the filtering function : 'conv', 'fft'

% Object size
param.dImgY         = 1;    % mm
param.dImgX         = 1;    % mm

param.nImgY         = 128;  % # of elements
param.nImgX         = 128;  % # of elements

param.dOffsetImgX   = 25;    % # of elements
param.dOffsetImgY	= 25;    % # of elements

%%
load('XCAT512.mat');
src                 = imresize(XCAT512, [param.nImgY, param.nImgX]);

%%
disp ('built-in ver.');

disp ('projection - built-in');
tic;
prj_matlab        	= radon(src, param.pdView);
toc;

disp ('filtering - built-in');
tic;
prj_matlab_flt     	= filterProjections(prj_matlab, 'ram-lak', 1);
toc;

disp ('backprojection - built-in');
tic;
dst_matlab         	= iradon(prj_matlab_flt, param.pdView, 'none', param.nImgY);
toc;

%%
disp ('implementation ver.')

disp ('projection - implementation');
tic;
prj_imp         	= projection(src, param);
toc;

disp ('filtering - implementation');
tic;
prj_imp_flt         = filtering(prj_imp, param);
toc;

disp ('backprojection - implementation');
tic;
dst_imp             = backprojection(prj_imp_flt, param);
toc;

%%
wndImg      = [0, max(src(:))];

figure(2); colormap gray;
subplot(331);   imagesc(src, wndImg);     	
                axis image;     xlabel('X-axis'); 	ylabel('Y-axis');	title('ground truth');
subplot(332);   imagesc(dst_matlab, wndImg);
                axis image;     xlabel('X-axis'); 	ylabel('Y-axis');	title(['reconstruction_{built-in, # of view = ' num2str(param.nView) '}']);
subplot(333);   imagesc(dst_imp, wndImg);
                axis image;     xlabel('X-axis'); 	ylabel('Y-axis');	title(['reconstruction_{implementation, # of view = ' num2str(param.nView) '}']);

subplot(335);   imagesc(src - dst_matlab);
                axis image;     xlabel('X-axis'); 	ylabel('Y-axis');	title(['difference_{ground truth - built-in, # of view = ' num2str(param.nView) '}']);
subplot(336);   imagesc(src - dst_imp);
                axis image;     xlabel('X-axis'); 	ylabel('Y-axis');	title(['difference_{ground truth - implementation, # of view = ' num2str(param.nView) '}']);

subplot(338);   imagesc(prj_matlab);
                xlabel(['Angle ( \Delta\theta : ' num2str(param.dView) ' \circ )']);	ylabel('Detector');	title(['sinogram_{built-in, # of view = ' num2str(param.nView) '}']);
                ax              = gca;
                ax.XTick        = linspace(0, param.nView, 10);
                ax.XTickLabel	= linspace(0, param.dAngle, 10);
                
subplot(339);   imagesc(prj_imp);  
                xlabel(['Angle ( \Delta\theta : ' num2str(param.dView) ' \circ )']);	ylabel('Detector');	title(['sinogram_{implementation, # of view = ' num2str(param.nView) '}']);
                ax              = gca;
                ax.XTick        = linspace(0, param.nView, 10);
                ax.XTickLabel	= linspace(0, param.dAngle, 10);