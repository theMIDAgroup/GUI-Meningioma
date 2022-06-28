%% mask2dcm()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION:  
% This function transforms:
% - T1 volume mask from mat to dicom format (it produces and saves a
%   dicom file for each slice of the volume mask associated to each ROI)
% - T1 mask from dicom to nifti format (for each ROI)
% - T1 image from dicom to nifti format
% - ADC image from dicom to nifti
% From here:
% - run fsl2matlab.py to coregister T1 and ADC images and save 
%   the transformation matrix (using FSL)
% - run maskT1_2_maskADC.py to produce ADC masks (one for each ROI)
% - come back to Matlab and run mask_adc_nii2mat.m
% -------------------------------------------------------------------------
%%%% called by: radiomics_T1_and_Continue()

function mask2dcm()

global ROI;
global Info;
global gui_ROI;

warning off;

% Save in global Info the ADC folder and the files it contains, in order to
% loop over the files in in Show_ROI_ADC
mydir = Info.InputPath;
string_mydir  = strfind(mydir,gui_ROI.slash_pc_mac);
newdir = mydir(1:string_mydir(end)-1);
Info.ADC_directory  = [newdir gui_ROI.slash_pc_mac 'ADC'];

% To load the folder manually:
% Info.ADC_directory = uigetdir(path,'Select ADC folder');

Nval = length(ROI);

for val = 1 : Nval
    
    if ROI{val}.Enable

        volume_mask_directory = [Info.OutputPathMASK gui_ROI.slash_pc_mac...
            'MASK_' regexprep(ROI{val}.Name,'[^\w'']','')];
        
        volume_aux = load(fullfile(volume_mask_directory,'volume_mask.mat'));
        volume_mask = volume_aux.volume_mask;
        
        output_directory_dicom = [volume_mask_directory gui_ROI.slash_pc_mac...
            'MASK_DICOM'];
        
        if ~exist(output_directory_dicom,'dir'), mkdir(output_directory_dicom); end
        
        Nit = Info.NumberFileMR;
        
        for it = 1 : Nit
            
            str = [Info.InputPath, gui_ROI.slash_pc_mac,...
                    Info.FileMR(it).name];
            INFO_MR = dicominfo(str);
            I_MR = uint16(volume_mask(:,:,it));
           
            str_save = [output_directory_dicom gui_ROI.slash_pc_mac ,...
                Info.FileMR(it).name];
            dicomwrite(I_MR,str_save,INFO_MR,'CreateMode','copy');
        end
        % T1 mask from dicom to nii
        dicm2nii(output_directory_dicom,volume_mask_directory,'.nii.gz' ,'T1_mask');
    end
end

% T1 from dicom to nii
dicm2nii(Info.InputPath,Info.OutputPathMASK,'.nii.gz' ,'T1');
% ADC from dicom to nii
dicm2nii(Info.ADC_directory,Info.OutputPathMASK,'.nii.gz' ,'ADC');

% Save in global Info the ADC dcm files, in order to loop over the files in
% Show_ROI_ADC
FilesList = dir(Info.ADC_directory);

while FilesList(1).name(1) == '.'
    FilesList(1) = [];
end

Info.FilesListADC = FilesList;

save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');   
save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat');

disp('End of T1 analysis and radiomics')

end
