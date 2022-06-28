%% radiomics_merged2D()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function computes the 2D radiomics features associated to each new
% slice coming from two merged ROIs (with the button "APPEND" in the main 
% GUI). The utilized package refers to <https://github.com/mvallieres/radiomics/>.
% -------------------------------------------------------------------------
%%%% called by: Merge_sameROI()
%%%% call: Write_xlsx_Radiomics()

function radiomics_merged2D(mri_img, volume_image_field_name,...
    mask_img, volume_mask_field_name, number_of_slices_ROIonly_field_name, globalTextures_field_name,...
    matrix_based_textures_field_name, nonTexture_field_name, output_file_name,...
    pixelW, sliceS)


global Info
global ROI 
global radiomics2D_merge

warning off;

% Radiomics parameters
scanType = 'MRscan';
R=1;
scale = 1;
quantAlgo = 'Equal';
Ng = 255;

% Load MRI volume 
volume_image = load(fullfile(Info.OutputPathMASK,mri_img));
volume = getfield(volume_image,volume_image_field_name);

% Initialize global radiomics_merge
radiomics2D_merge = cell(1);

val = Info.district_part1;

% Load mask for the val-th district
volume_mask = load(fullfile(Info.OutputPathMASK,...
    ['MASK_District' num2str(val)], mask_img));
mask = getfield(volume_mask,volume_mask_field_name);

%%%%%%%%% For non-texture features  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nonTexture = struct();
textType = 'nonTexture2D';

[ROIonly,~,~,~] = prepareVolume(volume,mask,scanType,...
    pixelW,sliceS,R,scale,textType);         

% Save number of slices after resize
ROI{val} = setfield(ROI{val},number_of_slices_ROIonly_field_name, size(ROIonly,3));  
% Load number of slices after resize and count them
number_of_slices_after_resize = getfield(ROI{val},number_of_slices_ROIonly_field_name);  

% Inherently 3D features, not considered here
%         nonTexture = setfield(nonTexture,'Eccentricity',getEccentricity(ROIonly,pixelW,sliceS));
%         nonTexture = setfield(nonTexture,'Size',getSize(ROIonly,pixelW,sliceS));
%         nonTexture = setfield(nonTexture,'Solidity',getSolidity(ROIonly,pixelW,sliceS));
        
nonTexture = setfield(nonTexture,'Area',getVolume(ROIonly(:,:,1),pixelW,sliceS));

radiomics2D_merge{1}= setfield(radiomics2D_merge{1},nonTexture_field_name, nonTexture);
aux_radiomics2D_1 = getfield(radiomics2D_merge{1},nonTexture_field_name);

for slice = 2:number_of_slices_after_resize
    aux_radiomics2D_1.Area(slice) = getVolume(ROIonly(:,:,slice),pixelW,sliceS);
end
radiomics2D_merge{1} = setfield(radiomics2D_merge{1},nonTexture_field_name,aux_radiomics2D_1);


%%%%%%%%% For Global textures  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textType = 'Global';
[ROIonly,~,~,~] = prepareVolume(volume,mask,scanType,...
    pixelW,sliceS,R,scale,textType);

radiomics2D_merge{1} = setfield(radiomics2D_merge{1},globalTextures_field_name,getGlobalTextures(ROIonly(:,:,1),100));
aux_radiomics2D = getfield(radiomics2D_merge{1},globalTextures_field_name);

for slice = 2:number_of_slices_after_resize
    aux_radiomics2D(slice) = getGlobalTextures(ROIonly(:,:,slice),100);
end
radiomics2D_merge{1} = setfield(radiomics2D_merge{1},globalTextures_field_name,aux_radiomics2D);

%%%%%%%%% For matrix-based textures  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matrix_based_textures = struct();
GLCM_all = {};
GLRLM_all = {};
GLSZM_all = {};
NGTDM_all = {};
countValid_all = {};

textType = 'Matrix';
[ROIonly,levels,~,~] = prepareVolume(volume,mask,scanType,...
    pixelW,sliceS,R,scale,textType,quantAlgo,Ng);

GLCM_all{1} = getGLCM(ROIonly(:,:,1),levels);
matrix_based_textures = setfield(matrix_based_textures,'GLCM',GLCM_all);
matrix_based_textures = setfield(matrix_based_textures, 'glcmTextures',...
    getGLCMtextures(GLCM_all{1}));

GLRLM_all{1} = getGLRLM(ROIonly(:,:,1),levels);
matrix_based_textures = setfield(matrix_based_textures,'GLRLM',GLRLM_all);
matrix_based_textures = setfield(matrix_based_textures,'glrlmTextures',...
    getGLRLMtextures(GLRLM_all{1}));

GLSZM_all{1} = getGLSZM(ROIonly(:,:,1),levels);
matrix_based_textures = setfield(matrix_based_textures,'GLSZM',GLSZM_all);
matrix_based_textures = setfield(matrix_based_textures,'glszmTextures',...
    getGLSZMtextures(GLSZM_all{1}));

[NGTDM_all{1},countValid_all{1}] = getNGTDM(ROIonly,levels);
matrix_based_textures = setfield(matrix_based_textures,'NGTDM',NGTDM_all);
matrix_based_textures = setfield(matrix_based_textures,'countValid',countValid_all);
matrix_based_textures = setfield(matrix_based_textures,'ngtdmTextures',...
    getNGTDMtextures(NGTDM_all{1},countValid_all{1}));

radiomics2D_merge{1}= setfield(radiomics2D_merge{1},matrix_based_textures_field_name, matrix_based_textures);
aux_radiomics2D_2 = getfield(radiomics2D_merge{1},matrix_based_textures_field_name);

for slice = 2:number_of_slices_after_resize
    GLCM_all{slice} = getGLCM(ROIonly(:,:,slice),levels);
    aux_radiomics2D_2.GLCM = GLCM_all;
    aux_radiomics2D_2.glcmTextures(slice) = getGLCMtextures(GLCM_all{slice});

    GLRLM_all{slice} = getGLRLM(ROIonly(:,:,slice),levels);
    aux_radiomics2D_2.GLRLM = GLRLM_all;
    aux_radiomics2D_2.glrlmTextures(slice) = getGLRLMtextures(GLRLM_all{slice});

    GLSZM_all{slice} = getGLSZM(ROIonly(:,:,slice),levels);
    aux_radiomics2D_2.GLSZM = GLSZM_all;
    aux_radiomics2D_2.glszmTextures(slice) = getGLSZMtextures(GLSZM_all{slice});

    [NGTDM_all{slice},countValid_all{slice}] = getNGTDM(ROIonly(:,:,slice),levels);
    aux_radiomics2D_2.NGTDM = NGTDM_all;
    aux_radiomics2D_2.countValid = countValid_all;
    aux_radiomics2D_2.ngtdmTextures(slice) = getNGTDMtextures(NGTDM_all{slice},countValid_all{slice});
end
radiomics2D_merge{1} = setfield(radiomics2D_merge{1},matrix_based_textures_field_name,aux_radiomics2D_2);


Write_xlsx_Radiomics2D_merged(number_of_slices_ROIonly_field_name,globalTextures_field_name,...
                matrix_based_textures_field_name,nonTexture_field_name,output_file_name);
disp('Radiomics 2D merged done!')

end
