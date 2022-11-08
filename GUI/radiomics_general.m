%% radiomics_general()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function computes the 3D radiomics features associated to each ROI
% volume. The utilized package refers to 
% <https://github.com/mvallieres/radiomics/>.
% -------------------------------------------------------------------------
%%%% called by: radiomics_T1_and_Continue()
%%%%            Save_Last_Slice_ADC()
%%%% call: Write_csv_Radiomics()

function radiomics_general(mri_img, volume_image_field_name,...
    mask_img, volume_mask_field_name, globalTextures_field_name,...
    matrix_based_textures_field_name, nonTexture_field_name, output_file_name,...
    pixelW, sliceS, quantAlgo)

global ROI
global Info
global radiomics

warning off;

% Radiomics parameters
scanType = 'MRscan';
R=1;
scale = 1;
% quantAlgo info is included in the inputs of the function
Ng = 255;

% Load MRI volume 
volume_image = load(fullfile(Info.OutputPathMASK,mri_img));
volume = getfield(volume_image,volume_image_field_name);
Nval = length(ROI);

% initialize global radiomics
radiomics = cell(1,Nval);

for val = 1 : Nval
    
    if ROI{val}.Enable  
        % Load mask for the val-th district  
        volume_mask = load(fullfile(Info.OutputPathMASK,...
            ['MASK_District' num2str(val)], mask_img));
        mask = getfield(volume_mask,volume_mask_field_name);
        
        % For non-texture features
        nonTexture = struct();
        textType = 'nonTexture';
        
        [ROIonly,~,~,~] = prepareVolume(volume,mask,scanType,...
            pixelW,sliceS,R,scale,textType);
         
        nonTexture = setfield(nonTexture,'Eccentricity',getEccentricity(ROIonly,pixelW,sliceS));
        nonTexture = setfield(nonTexture,'Size',getSize(ROIonly,pixelW,sliceS));
        nonTexture = setfield(nonTexture,'Solidity',getSolidity(ROIonly,pixelW,sliceS));
        nonTexture = setfield(nonTexture,'Volume',getVolume(ROIonly,pixelW,sliceS));
        
        radiomics{val}= setfield(radiomics{val},nonTexture_field_name, nonTexture);
        
        % For Global textures
        textType = 'Global';

        [ROIonly,~,~,~] = prepareVolume(volume,mask,scanType,...
            pixelW,sliceS,R,scale,textType);
        
        radiomics{val} = setfield(radiomics{val},globalTextures_field_name,getGlobalTextures(ROIonly,100));
        
        % For matrix-based textures
        matrix_based_textures = struct();
        
        textType = 'Matrix';

        [ROIonly,levels,~,~] = prepareVolume(volume,mask,scanType,...
            pixelW,sliceS,R,scale,textType,quantAlgo,Ng);

        GLCM = getGLCM(ROIonly,levels);
        GLRLM = getGLRLM(ROIonly,levels);
        GLSZM = getGLSZM(ROIonly,levels);
        matrix_based_textures = setfield(matrix_based_textures,'GLCM',getGLCM(ROIonly,levels));
        matrix_based_textures = setfield(matrix_based_textures, 'glcmTextures',...
            getGLCMtextures(getfield(matrix_based_textures,"GLCM")));
        matrix_based_textures = setfield(matrix_based_textures,'GLRLM',getGLRLM(ROIonly,levels));
        matrix_based_textures = setfield(matrix_based_textures,'glrlmTextures',...
            getGLRLMtextures(getfield(matrix_based_textures,'GLRLM')));
        matrix_based_textures = setfield(matrix_based_textures,'GLSZM',getGLSZM(ROIonly,levels));
        matrix_based_textures = setfield(matrix_based_textures,'glszmTextures',...
            getGLSZMtextures(getfield(matrix_based_textures,'GLSZM')));

        [NGTDM,countValid] = getNGTDM(ROIonly,levels);
        matrix_based_textures = setfield(matrix_based_textures,'NGTDM',NGTDM);
        matrix_based_textures = setfield(matrix_based_textures,'countValid',countValid);
        matrix_based_textures = setfield(matrix_based_textures,'ngtdmTextures',...
            getNGTDMtextures(matrix_based_textures.NGTDM,matrix_based_textures.countValid));

        radiomics{val}= setfield(radiomics{val},matrix_based_textures_field_name, matrix_based_textures);
        
    end
end
            
Write_csv_Radiomics(globalTextures_field_name,matrix_based_textures_field_name,...
                nonTexture_field_name,output_file_name);
disp('radiomics 3D done!')

end
