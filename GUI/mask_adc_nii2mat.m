%% mask_adc_nii2mat()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function transforms the ADC volume mask from nifti to mat format and 
% saves it (for each ROI). ADC masks are also saved in the global variable 
% 'ROI'. Then the GUI function GUI_Check_ADC is called.
% Global variables Info and ROI are saved.
% -------------------------------------------------------------------------
%%%% call: GUI_Check_ADC()
%%%%       dicom23D()

function mask_adc_nii2mat()

global ROI;
global Info;
global gui_ROI;
global gui_T1;

if ispc==1, gui_ROI.slash_pc_mac='\'; else, gui_ROI.slash_pc_mac='/'; end
Nval = length(ROI);

[volume_image_adc, ~, ~] = dicom23D(Info.ADC_directory);
str_save = [Info.OutputPathMASK gui_ROI.slash_pc_mac 'volume_image_adc.mat'];
save(str_save,'volume_image_adc')

for val = 1 : Nval
    
    if ROI{val}.Enable

        adc_nii_directory = [Info.OutputPathMASK gui_ROI.slash_pc_mac...
            'MASK_' regexprep(ROI{val}.Name,'[^\w'']','')];
        volume_nifti = niftiread(fullfile(adc_nii_directory, 'ADC_mask.nii.gz'));
        vol_aux = double(volume_nifti);
        volume_mask_adc = zeros(size(vol_aux));
        volume_mask_adc(vol_aux~=0) = 1;
        str_save = [adc_nii_directory gui_ROI.slash_pc_mac 'volume_mask_adc.mat'];
        save(str_save,'volume_mask_adc')
        ROI{val}.MasksADC = volume_mask_adc;  
    end

end
aux = niftiinfo(fullfile(adc_nii_directory, 'ADC_mask.nii.gz'));
Info.PixelSizeADC = aux.PixelDimensions;
gui_T1.idx_ROI_enabled = [];
for val = 1 : size(ROI,2)
    if ROI{val}.Enable
       gui_T1.idx_ROI_enabled = [gui_T1.idx_ROI_enabled, val];
    end
end
val = min(gui_T1.idx_ROI_enabled);
Info.SizeADC = size(ROI{val}.MasksADC); 
% Set val = the first enabled ROI. This works since ADC dimensions are
% always the same for each district.

% NB: note that the co-registration swaps rows and columns. From here on:
% Info.SizeADC(2) rows
% Info.SizeADC(1) columns
% see Save_Last_Slice_ADC() when calling Write_3D_Masks_general()

save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');   
save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat');

GUI_Check_ADC;
end
