%% mask2dcm()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION:  
% This function transforms:
% - T1 volume mask from mat to dicom format (it produces and saves a
%   dicom file for each slice of the volume mask associated to each ROI)
% - T1 mask from dicom to nifti format (for each ROI)
% - T1 image from dicom to nifti format
% - ADC image from dicom to nifti
% From here, if using Windows or Linux:
% - run fsl2matlab.py to coregister T1 and ADC images and save 
%   the transformation matrix (using FSL)
% - run maskT1_2_maskADC.py to produce ADC masks (one for each ROI)
% - come back to Matlab and run mask_adc_nii2mat.m
% If using Mac, all the above steps are integrated in this function.
% -------------------------------------------------------------------------
%%%% called by: radiomics_T1_and_Continue()
%%%% call: mask_adc_nii2mat() if using Mac

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

%% sort slices according to SliceLocation
number_of_file = length(FilesList);
for it = 1 : number_of_file
    INFO = dicominfo([Info.InputPath,gui_ROI.slash_pc_mac, FilesList(it).name]);
    if isfield(INFO,'SliceLocation')
        temp_index(it,:) = [INFO.SeriesNumber , INFO.InstanceNumber,INFO.SliceLocation, it, INFO.ImagePositionPatient(3)];
    else
        temp_index(it,:) = [INFO.SeriesNumber , INFO.InstanceNumber,0, it, 0];
    end
    temp_modality{it} = INFO.Modality;
end
clear INFO;
temp_index = sortrows(temp_index,3); 
[~,index_cambio_acquisizione_start] = unique(temp_index(:,1),'first');
[~,index_cambio_acquisizione_end] = unique(temp_index(:,1),'last');
index1 = index_cambio_acquisizione_start;
index2 = index_cambio_acquisizione_end;

Info.FilesListADC = FilesList(temp_index(index1:index2,4));

%%
save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');   
save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat');

disp('End of T1 analysis and radiomics')

% with Windows and Linux the Matlab code ends here and one should continue on Python,
% with coregistrationT1_ADC.py and maskT1_2_maskADC.py. One should then
% reopen Matlab and run mask_adc_nii2mat.m 
% with Mac, it is possible to continue
if ispc; disp('Go to Python and run coregistrationT1_ADC.py and maskT1_2_maskADC.py');
elseif ismac
    %% FSL
    fsldir = '/usr/local/fsl';
    fsldirmpath = sprintf('%s/etc/matlab',fsldir);
    setenv('FSLDIR', fsldir);
    setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
    path(path, fsldirmpath);

    string_coregistr = ['/usr/local/fsl/bin/flirt -in ' Info.OutputPathMASK,'/T1.nii.gz -ref ' Info.OutputPathMASK,'/ADC.nii.gz -out ', Info.OutputPathMASK,'/coregistration_T1_ADC.nii -omat ' Info.OutputPathMASK,'/coregistration_matrix.mat -bins 256 -cost corratio -dof 12 -interp trilinear -searchrx -90 90 -searchry -90 90 -searchrz -90 90'];
    call_fsl(string_coregistr);

    for val = 1 : Nval
        if ROI{val}.Enable
            volume_mask_directory = [Info.OutputPathMASK gui_ROI.slash_pc_mac...
                'MASK_' regexprep(ROI{val}.Name,'[^\w'']','')];

            string_adc_mask = ['/usr/local/fsl/bin/flirt -in ' volume_mask_directory ,'/T1_mask.nii.gz -ref ' Info.OutputPathMASK,'/ADC.nii.gz -applyxfm -init ', Info.OutputPathMASK,'/coregistration_matrix.mat -o ' volume_mask_directory,'/ADC_mask.nii.gz'];
            call_fsl(string_adc_mask);
        end
    end

    mask_adc_nii2mat;
end
end
