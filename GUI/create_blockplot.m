clc
clear
close all

% Choose patient
patient = 'M039';
% choose slice (check the GUI)
slice = 46;  % overall volume slice % 66 for patient M019, 46 for patient M039
load(['/Users/valentina/Documents/PostDoc/Radiomics/NEW_GUI_Meningioma/Data/data_true/',patient,'/T1_MAT/Info.mat'])
load(['/Users/valentina/Documents/PostDoc/Radiomics/NEW_GUI_Meningioma/Data/data_true/',patient,'/T1_MAT/ROI.mat'])
load(['/Users/valentina/Documents/PostDoc/Radiomics/NEW_GUI_Meningioma/Data/data_true/',patient,'/T1_OUTPUT_MASK/volume_image.mat'])
load(['/Users/valentina/Documents/PostDoc/Radiomics/NEW_GUI_Meningioma/Data/data_true/',patient,'/T1_OUTPUT_MASK/MASK_District1/volume_mask.mat'])

%% blockPlot
it_start = 1;
val = 1;
Nit = length(ROI{val}.RoiSlice);
str = [Info.InputPath, '/', Info.FileMR(it_start + ROI{val}.RoiSlice(1)-1).name];

% MRI slice
I0 = double(dicomread(str));
dim_I0 = size(I0);

for it = it_start:Nit
    slice_ls = zeros(dim_I0(1), dim_I0(2));
    slice_ls(ROI{val}.RoiSegmentationPixelIdxList{it}) = 1;
    level_set_3d(:,:,it) = slice_ls;
end

figure; blockPlot(level_set_3d)%[0,0,0],%'color','r','facealpha',.5,'edgecolor','none')
view([-69 19])
grid on 
zlim([0 60])

%% Histograms 

%figure, imshow(volume_mask(:,:,slice))
figure, imagesc(volume_image(:,:,slice)), colormap gray
segmented_tumor = volume_mask(:,:,slice).*volume_image(:,:,slice);
figure, imagesc(segmented_tumor), colormap gray

grey_levels = find(segmented_tumor);
nbins = 25;
h = histogram(grey_levels,nbins);
title(['Grey levels on tumor slice ', num2str(slice)])

% [X,Y] = meshgrid(1:224,1:256);
% figure, surf(X,Y,segmented_tumor)
% figure, surf(X,Y,volume_image(:,:,slice))

%% Radiomics features

% volume = getfield(volume_image,volume_image_field_name);
% mask = getfield(volume_mask,volume_mask_field_name);
scanType = 'MRscan';
R=1;
scale = 1;
quantAlgo = 'Lloyd';
Ng = 255;
textType = 'Matrix';
pixelW = Info.PixelSizeMR(1);
sliceS = Info.SliceThicknessMR;

[ROIonly,levels,~,~] = prepareVolume(volume_image,volume_mask,scanType,...
    pixelW,sliceS,R,scale,textType,quantAlgo,Ng);

GLCM = getGLCM(ROIonly,levels);
GLRLM = getGLRLM(ROIonly,levels);
GLSZM = getGLSZM(ROIonly,levels);
[NGTDM,countValid] = getNGTDM(ROIonly,levels);

figure, imagesc(GLCM)
figure, imagesc(GLRLM)
figure, imagesc(GLSZM)
figure, imagesc(NGTDM)



