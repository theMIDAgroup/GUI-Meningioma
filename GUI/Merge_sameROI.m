%% Merge_sameROI()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION:
% You can use this option when you have two connected components of the
% same ROI in one or more slices. First you treat these components as two
% different ROIs, then you press 'START ANALYSIS'. When T1 and ADC
% analysis has finished, you can come back to the GUI and merge the two
% components:
% - 'ROI part 1' is the 1st connected component
% - 'ROI part 2' is the 2nd connected component
% - click 'MERGE' to merge the masks of the two components and compute the
%   radiomics of their union.
% This function creates a new mat file with the mask of the union of the
% two components (one file for T1 and another one for ADC). Moreover, this
% function creates a new csv file with the radiomics of the union (one
% file for T1 and another for ADC).
% Note that if you open GUI_Check_T1 or GUI_Check_ADC with
% Run_GUI_CheckSlices, the two connected components are always shown
% separately, as if they were two different ROIs.
% Note that in the global variable ROI, attributes remain unchanged, so
% the two connected components are still considered as two different ROIs.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain(), button 'MERGE'
%%%% call: radiomics_merged()
%%%%       radiomics_merged2D()

function Merge_sameROI()
global ROI
global Info
global gui_ROI

% district to which one attaches (part 1)
val1 = get(gui_ROI.PANELsame_roi.val_part1,'string');
val1 = str2num(val1);

% district to attach (part 2)
val2 = get(gui_ROI.PANELsame_roi.val_part2,'string');
val2 = str2num(val2);

mydir = Info.InputPath;
string_mydir  = strfind(mydir,gui_ROI.slash_pc_mac);
subj = mydir(string_mydir(end)-4:string_mydir(end)-1);

% MERGE T1
% load volume_mask
output_directory = [Info.OutputPathMASK gui_ROI.slash_pc_mac...
    'MASK_' regexprep(ROI{val1}.Name,'[^\w'']','')];
load([output_directory gui_ROI.slash_pc_mac 'volume_mask.mat']);

if (isempty(ROI{val1}.FinalMasks) || isempty(ROI{val2}.FinalMasks)) ||...
        (~isfield(ROI{val1},'FinalMasks') || ~isfield(ROI{val2},'FinalMasks'))
    disp('Find the volume masks first!')
else

    for i = 1:length(ROI{val2}.RoiSlice)
        slice_i = volume_mask(:,:,ROI{val2}.RoiSlice(i));
        slice_i(find(ROI{val2}.FinalMasks{i}~=0)) = 1;
        volume_mask(:,:,ROI{val2}.RoiSlice(i)) = slice_i;
        %     figure;imagesc(volume_mask(:,:,ROI{val2}.RoiSlice(i)))
    end

    save([output_directory gui_ROI.slash_pc_mac 'volume_mask_merged.mat'],'volume_mask')

    % Save 'val2' in global Info in order to indicate that this function has
    % been used, so that in the radiomics file the features are only related to
    % val1 (including val2)
    Info.district_part1 = val1;
    Info.district_part2 = val2;

    % Save the (merged) districts slices number
    ROI{val1}.slices_merged = union(ROI{val1}.RoiSlice,ROI{val2}.RoiSlice);

    quantAlgo = gui_ROI.PopupValueQuant;

    radiomics_merged2D('volume_image.mat', 'volume_image', 'volume_mask_merged3.mat',...
        'volume_mask','number_of_slices_after_resize_merged',...
        'globalTextures', 'matrix_based_textures',...
        'nonTexture',[Info.OutputPathRadiomics gui_ROI.slash_pc_mac subj '_radiomics2D_merged.csv'],...
        Info.PixelSizeMR(1),Info.PixelSizeMR(2),quantAlgo);

    radiomics_merged('volume_image.mat', 'volume_image', 'volume_mask_merged3.mat',...
        'volume_mask',...
        'globalTextures', 'matrix_based_textures',...
        'nonTexture',[Info.OutputPathRadiomics gui_ROI.slash_pc_mac subj '_radiomics_merged.csv'],...
        Info.PixelSizeMR(1),Info.PixelSizeMR(2), quantAlgo);

    % MERGE ADC (if ADC folder exists)
    if isfield(Info,'ADC_directory')

        indices_val1 = find(~cellfun(@isempty,ROI{val1}.RoiSegmentationPixelIdxListADC));
        indices_val2 = find(~cellfun(@isempty,ROI{val2}.RoiSegmentationPixelIdxListADC));
        ROI{val1}.slices_merged_ADC = union(indices_val1,indices_val2);
        slices_merged_ADC = ROI{val1}.slices_merged_ADC; %CONTROLLARE

        output_directory = [Info.OutputPathMASK gui_ROI.slash_pc_mac...
            'MASK_' regexprep(ROI{val1}.Name,'[^\w'']','')];
        load([output_directory gui_ROI.slash_pc_mac 'volume_mask_adc.mat']);

        if (isempty(ROI{val1}.FinalMasksADC) || isempty(ROI{val2}.FinalMasksADC)) ||...
                (~isfield(ROI{val1},'FinalMasksADC') || ~isfield(ROI{val2},'FinalMasksADC'))
            disp('Find the ADC volume masks first!')
        else

            for i = 1:length(slices_merged_ADC)
                slice_i = volume_mask(:,:,slices_merged_ADC(i));
                slice_i(find(ROI{val2}.FinalMasksADC{slices_merged_ADC(i)}~=0)) = 1;
                volume_mask(:,:,slices_merged_ADC(i)) = slice_i;
            end
            save([output_directory gui_ROI.slash_pc_mac 'volume_mask_adc_merged.mat'],'volume_mask')

            radiomics_merged2D('volume_image_adc.mat', 'volume_image_adc', 'volume_mask_adc_merged.mat',...
                'volume_mask','number_of_slices_after_resize_merged_ADC',...
                'globalTextures_ADC', 'matrix_based_textures_ADC',...
                'nonTexture_ADC',[Info.OutputPathRadiomics gui_ROI.slash_pc_mac subj '_radiomics2D_ADC_merged.csv'],...
                Info.PixelSizeADC(1),Info.PixelSizeADC(3), quantAlgo); 

            radiomics_merged('volume_image_adc.mat', 'volume_image_adc', 'volume_mask_adc_merged.mat',...
                'volume_mask',...
                'globalTextures_ADC', 'matrix_based_textures_ADC',...
                'nonTexture_ADC',[Info.OutputPathRadiomics gui_ROI.slash_pc_mac subj '_radiomics_ADC_merged.csv'],...
                Info.PixelSizeADC(1),Info.PixelSizeADC(3), quantAlgo); 


        end
    end

    save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');
    save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat');
end
end

