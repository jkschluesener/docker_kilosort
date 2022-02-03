% This is the matlab startup file
% During the build process it is copied into the container
% It adds the following packages to the matlab function searchpath

% Kilosort
addpath(genpath('/home/matlab/Documents/MATLAB/kilosort'))
% gui layout toolbox from unofficial mirror
addpath(genpath('/home/matlab/Documents/MATLAB/gui_layout_toolbox'))
% npy-matlab to read numpy files
addpath(genpath('/home/matlab/Documents/MATLAB/npy-matlab'))
