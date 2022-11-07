%% radiomics_T1_and_Continue()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function calls the radiomics for T1 images. If ADC exists, the
% analysis continues, otherwise it stops here.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain()
%%%%            Save_Last_Slice()
%%%% call:  mask2dcm()  
%%%%        radiomics_general()
%%%%        radiomics_general2D()
     
function radiomics_T1_and_Continue()

global Info;
global gui_ROI;
global ROI

% T1
mydir = Info.InputPath;
string_mydir  = strfind(mydir,gui_ROI.slash_pc_mac);
subj = mydir(string_mydir(end)-4:string_mydir(end)-1);

str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' Radiomics analysis in progress'];
w = waitbar(0,'Radiomics analysis in progress','Name','Radiomics analysis in progress');
waitbar(0.15, w,str_wbar);

quantAlgo = gui_ROI.PopupValueQuant; 

% radiomics 2D (slice-wise)
radiomics_general2D('volume_image.mat','volume_image','volume_mask.mat','volume_mask',...
                'number_of_slices_after_resize','globalTextures','matrix_based_textures','nonTexture',...
                [Info.OutputPathRadiomics gui_ROI.slash_pc_mac subj '_radiomics2D.xlsx'],Info.PixelSizeMR(1),Info.SliceThicknessMR, quantAlgo);

str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' Radiomics 2D done!'];
waitbar(0.33, w,str_wbar);

% radiomics 3D (on the volume)
radiomics_general('volume_image.mat', 'volume_image', 'volume_mask.mat', 'volume_mask',...
    'globalTextures', 'matrix_based_textures', 'nonTexture',[Info.OutputPathRadiomics gui_ROI.slash_pc_mac subj '_radiomics.xlsx'],...
    Info.PixelSizeMR(1),Info.SliceThicknessMR, quantAlgo);

str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' Radiomics 3D done!'];
waitbar(0.67, w,str_wbar);

mydir = Info.InputPath;
string_mydir  = strfind(mydir,gui_ROI.slash_pc_mac); 
newdir = mydir(1:string_mydir(end)-1);
% Check if the ADC folder exists, if yes, save Info.ADC_directory in 
% mask2dcm.m
ADC_directory  = [newdir gui_ROI.slash_pc_mac 'ADC'];

if exist(ADC_directory,'dir')
    str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' Mask conversion to DICOM']; 
    waitbar(0.85, w,str_wbar);
    mask2dcm;
    str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' End of radiomics analysis!']; 
    waitbar(1, w,str_wbar);
    close(w);
else
    save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');   
    save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat');  
    str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' End of radiomics analysis!']; 
    waitbar(1, w,str_wbar);
    close(w);
end

end