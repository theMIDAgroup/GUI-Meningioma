%% DeleteSlices
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION:
% This function allows the user to remove slices from the selected ROI.
% - 'ROI' is the number of ROI from which one aims to remove slices
% - 'NEW START' is the new first slice of the ROI
% - 'NEW END' is the new last slice of the ROI
% - click 'DELETE' to update the selected ROI
% You can use this function
% - just after you create the ROI (for the first time)
% - when the analysis has finished but you want to modify your ROI (then
%   click 'START ANALYSIS' and check all the slices again)
% The global variable ROI is saved in any of these cases.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain(), button 'DELETE'
%%%% call: PopUp_Districts()

global ROI
global Info
global gui_ROI

Nval = length(ROI);

% choose the to-be-modified district
val = get(gui_ROI.PANELdelete_slices.which_tumour,'string');
val = str2num(val);

% change the beginning and/or the end of the ROI
new_StartMR = get(gui_ROI.PANELdelete_slices.new_Start,'string');
new_StartMR = str2num(new_StartMR);
new_EndMR = get(gui_ROI.PANELdelete_slices.new_End,'string');
new_EndMR = str2num(new_EndMR);

% Check whether the ranges are correct: new_StartMR must be equal or larger
% than the previous Start, while new_EndMR must be equal or smaller.

index_new_StartMR = find(ROI{val}.RoiSlice == new_StartMR - 1);

if new_StartMR < ROI{val}.StartMR || new_EndMR > ROI{val}.EndMR
    msgbox('Error: check the ranges NEW START - NEW END')
else
    if new_StartMR ~= ROI{val}.StartMR(1)
        ROI{val}.RoiSlice(1:index_new_StartMR) = [];
        ROI{val}.RoiPosition(1:index_new_StartMR) = [];
        ROI{val}.RoiKind(1:index_new_StartMR) = [];
        ROI{val}.RoiRegion(1:index_new_StartMR,:) = [];

        % in order to delete without clicking on 'start analysis'
        if ~isempty(ROI{val}.RoiPixelIdxList)  
            ROI{val}.RoiPixelIdxList(1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.RoiSegmentationPixelIdxList)  
            ROI{val}.RoiSegmentationPixelIdxList(1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.RoiSegmentationPixelIdxBackwardList)  
            ROI{val}.RoiSegmentationPixelIdxBackwardList(1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.RoiSegmentationPixelIdxForwardList)  
            ROI{val}.RoiSegmentationPixelIdxForwardList(1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.Slices) 
            ROI{val}.Slices(1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.FinalMasks)  
            ROI{val}.FinalMasks(1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.MasksSlicesBackward) 
            ROI{val}.MasksSlicesBackward(1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.MasksSlicesForward) 
            ROI{val}.MasksSlicesForward(1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.MasksSlicesLevelSet)  
            ROI{val}.MasksSlicesLevelSet(1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.aux_pos_ls)  
            ROI{val}.aux_pos_ls(1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.SliceChoice) 
            ROI{val}.SliceChoice(:,1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.AlternativeSegmentationList)  
            ROI{val}.AlternativeSegmentationList(:,1:index_new_StartMR) = [];
        end
        if ~isempty(ROI{val}.first_next)  
            ROI{val}.first_next(:,1:index_new_StartMR) = [];
        end
        if isfield(ROI{val},'aux_pos_fwd')
            if length(ROI{val}.aux_pos_fwd) >= index_new_StartMR
                ROI{val}.aux_pos_fwd(1:index_new_StartMR) = [];
            else
                ROI{val} = rmfield(ROI{val},'aux_pos_fwd');
            end
        end
    end

    index_new_EndMR = find(ROI{val}.RoiSlice == new_EndMR + 1);

    if new_EndMR ~= ROI{val}.EndMR(end)
        ROI{val}.RoiSlice(index_new_EndMR:end) = [];
        ROI{val}.RoiPosition(index_new_EndMR:end) = [];
        ROI{val}.RoiKind(index_new_EndMR:end) = [];
        ROI{val}.RoiRegion(index_new_EndMR:end,:) = [];

        % in order to delete without clicking on 'start analysis'
        if ~isempty(ROI{val}.RoiPixelIdxList)  
            ROI{val}.RoiPixelIdxList(index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.RoiSegmentationPixelIdxList) 
            ROI{val}.RoiSegmentationPixelIdxList(index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.RoiSegmentationPixelIdxBackwardList) 
            ROI{val}.RoiSegmentationPixelIdxBackwardList(index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.RoiSegmentationPixelIdxForwardList)  
            ROI{val}.RoiSegmentationPixelIdxForwardList(index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.Slices)  
            ROI{val}.Slices(index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.FinalMasks)  
            ROI{val}.FinalMasks(index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.MasksSlicesBackward)  
            ROI{val}.MasksSlicesBackward(index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.MasksSlicesForward)  
            ROI{val}.MasksSlicesForward(index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.MasksSlicesLevelSet) 
            ROI{val}.MasksSlicesLevelSet(index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.aux_pos_ls)  
            ROI{val}.aux_pos_ls(index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.SliceChoice) 
            ROI{val}.SliceChoice(:,index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.AlternativeSegmentationList) 
            ROI{val}.AlternativeSegmentationList(:,index_new_EndMR:end) = [];
        end
        if ~isempty(ROI{val}.first_next)  
            ROI{val}.first_next(:,index_new_EndMR:end) = [];
        end
        if isfield(ROI{val},'aux_pos_fwd')
            if length(ROI{val}.aux_pos_fwd) >= index_new_EndMR
                ROI{val}.aux_pos_fwd(index_new_EndMR:end) = [];
            end
        end
    end

% Introduced with ADC analysis - ADC analysis has to be done again if the
% mask is modified, hence the ROI vectors containing ADC fields have to be
% emptied
if isfield(ROI{val},'EnableADC')
    ROI{val} = rmfield(ROI{val},'EnableADC');
end
if isfield(ROI{val},'MasksADC')
    ROI{val} = rmfield(ROI{val},'MasksADC'); 
end
if isfield(ROI{val},'first_next_ADC')
    ROI{val} = rmfield(ROI{val},'first_next_ADC'); 
end
if isfield(ROI{val},'pos_ADC_masks')
    ROI{val} = rmfield(ROI{val},'pos_ADC_masks'); 
end
if isfield(ROI{val},'aux_pos_ls_ADC')
    ROI{val} = rmfield(ROI{val},'aux_pos_ls_ADC'); 
end
if isfield(ROI{val},'RoiSegmentationPixelIdxListADC')
     ROI{val} = rmfield(ROI{val},'RoiSegmentationPixelIdxListADC'); 
end
if isfield(ROI{val},'FinalMasksADC')
    ROI{val} = rmfield(ROI{val},'FinalMasksADC'); 
end
if isfield(ROI{val},'slices_merged')
    ROI{val} = rmfield(ROI{val},'slices_merged');
end
if isfield(ROI{val},'slices_merged_ADC')
    ROI{val} = rmfield(ROI{val},'slices_merged_ADC');
end
if isfield(ROI{val},'number_of_slices_after_resize')
    ROI{val} = rmfield(ROI{val},'number_of_slices_after_resize');
end
if isfield(ROI{val},'number_of_slices_after_resize_ADC')
    ROI{val} = rmfield(ROI{val},'number_of_slices_after_resize_ADC');
end
if isfield(ROI{val},'segmented_slices_adc')
    ROI{val} = rmfield(ROI{val},'segmented_slices_adc');
end
if isfield(ROI{val},'number_of_slices_after_resize_merged')
    ROI{val} = rmfield(ROI{val},'number_of_slices_after_resize_merged');
end
if isfield(ROI{val},'number_of_slices_after_resize_merged_ADC')
    ROI{val} = rmfield(ROI{val},'number_of_slices_after_resize_merged_ADC');
end

ROI{val}.StartMR(1) = new_StartMR;
ROI{val}.EndMR(1) = new_EndMR;

set(gui_ROI.PANELroi.PANEL3.TXT1b,'string',num2str(ROI{val}.StartMR))
set(gui_ROI.PANELroi.PANEL3.TXT2b,'string',num2str(ROI{val}.EndMR))

% To show changes in the GUI: it updates the start and end values of the
% selected district
PopUp_Districts;

save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat'); 
save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat'); 

disp('The selected slices have been deleted')  

GUI_Check_T1; 
end

