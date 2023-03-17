%% Initialize_ROI_brain()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function creates the struct ROI and sets the fields of the struct 
% to default value. If ADC fields are present, it removes them in order to
% re-initialize the ROI.
% -------------------------------------------------------------------------
%%%% called by: Load_Data()
%%%%            Reset_Roi()
%%%%            Reset_All()
%%%%            AppendROIs       

function[] = Initialize_ROI_brain(it)
global gui_ROI
global ROI

ROI{it}.Name = gui_ROI.PANELroi.ROIName{it+1};
ROI{it}.Id = gui_ROI.PANELroi.ROIId(it+1);
ROI{it}.Enable = 0;
ROI{it}.StartMR = [];
ROI{it}.EndMR = [];
ROI{it}.CenterMR = [];
ROI{it}.RoiSlice = [];
ROI{it}.RoiPosition = [];
ROI{it}.RoiKind = [];
ROI{it}.RoiEnd = false;
ROI{it}.RoiRegion = [];
ROI{it}.RoiEmpty = true;
ROI{it}.RoiRemovePosition = [];
ROI{it}.RoiRemoveKind = [];
ROI{it}.RoiPixelIdxList = [];
ROI{it}.OutputDicom = 0;

ROI{it}.Segmented = false; % =true in Segmentation_Analysis_brain
ROI{it}.DicomWrittenMR = false;
ROI{it}.VoxelNumberMR = [];

ROI{it}.RoiPixelIdxList = [];
ROI{it}.RoiSegmentationPixelIdxList = [];
ROI{it}.FinalMasks = [];
ROI{it}.Slices = [];
ROI{it}.RoiSegmentationPixelIdxForwardList = [];
ROI{it}.RoiSegmentationPixelIdxBackwardList = [];
ROI{it}.MasksSlicesLevelSet = [];
ROI{it}.MasksSlicesForward = [];
ROI{it}.MasksSlicesBackward = [];
ROI{it}.aux_pos_ls = [];
ROI{it}.SliceChoice = [];
ROI{it}.AlternativeSegmentationList = [];
ROI{it}.first_next = [];

% Check if the following fields exist, if yes delete them to re-initialize
% the ROI
if isfield(ROI{it},'aux_pos_fwd')
    %ROI{it}.aux_pos_fwd = []; % control if
    %~isfield(ROI{val1},'aux_pos_fwd')in AppendROIs
    ROI{it} = rmfield(ROI{it},'aux_pos_fwd');
end

if isfield(ROI{it},'slices_merged')
    ROI{it} = rmfield(ROI{it},'slices_merged');
end
if isfield(ROI{it},'number_of_slices_after_resize')
    ROI{it} = rmfield(ROI{it},'number_of_slices_after_resize');
end
if isfield(ROI{it},'number_of_slices_after_resize_merged')
    ROI{it} = rmfield(ROI{it},'number_of_slices_after_resize_merged');
end


% ADC related
if isfield(ROI{it},'EnableADC')
    ROI{it} = rmfield(ROI{it},'EnableADC');
end
if isfield(ROI{it},'MasksADC')
    ROI{it} = rmfield(ROI{it},'MasksADC');end
if isfield(ROI{it},'first_next_ADC')
    ROI{it} = rmfield(ROI{it},'first_next_ADC');
end
if isfield(ROI{it},'pos_ADC_masks')
    ROI{it} = rmfield(ROI{it},'pos_ADC_masks');
end
if isfield(ROI{it},'aux_pos_ls_ADC')
    ROI{it} = rmfield(ROI{it},'aux_pos_ls_ADC');
end
if isfield(ROI{it},'RoiSegmentationPixelIdxListADC')
    ROI{it} = rmfield(ROI{it},'RoiSegmentationPixelIdxListADC');
end
if isfield(ROI{it},'FinalMasksADC')
    ROI{it} = rmfield(ROI{it},'FinalMasksADC');
end
if isfield(ROI{it},'slices_merged_ADC')
    ROI{it} = rmfield(ROI{it},'slices_merged_ADC');
end
if isfield(ROI{it},'number_of_slices_after_resize_ADC')
    ROI{it} = rmfield(ROI{it},'number_of_slices_after_resize_ADC');
end
if isfield(ROI{it},'segmented_slices_adc')
    ROI{it} = rmfield(ROI{it},'segmented_slices_adc');
end
if isfield(ROI{it},'number_of_slices_after_resize_merged_ADC')
    ROI{it} = rmfield(ROI{it},'number_of_slices_after_resize_merged_ADC');
end
