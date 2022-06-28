%% AppendROIs
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION:
% This function allows one to append some slices to the selected ROI.
% - 'ROI head' is the leading ROI, to which one aims to append the slices
% - 'ROI tail' is the ROI containing the slices one aims to append
% - click APPEND to update the selected ROI
% You can use this function
% - just after you create the ROIs (for the first time)
% - when the analysis has finished but you want to modify your ROI (then
%   click START ANALYSIS and check all the slices again)
% Note that 'ROI tail' will be re-initialized.
% Note that this function does not delete files from your PC folders (if
% you started the analysis before APPEND, you would still find
% folders containing mat, xsl, dcm files etc related to 'ROI tail').
% The global variable ROI is saved in any of these cases.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain(), button "APPEND"
%%%% call: PopUp_Districts()

global ROI
global Info;
global gui_ROI;

load([Info.InputPath '_MAT' gui_ROI.slash_pc_mac, 'ROI.mat']);

% choose the 2 to-be-attached districts
% first district (ROI head)
val1= get(gui_ROI.PANELappend_ROI.val_1,'string');
val1 = str2num(val1);
% second district (ROI tail)
val2= get(gui_ROI.PANELappend_ROI.val_2,'string');
val2 = str2num(val2);

% Check that they are both processed or not processed
if (ROI{val1}.Segmented && ROI{val2}.Segmented) || (~ROI{val1}.Segmented && ~ROI{val2}.Segmented)
    % Check that the slices are consecutive
    if ROI{val1}.RoiSlice(end)+1 ~= ROI{val2}.RoiSlice(1)
        msgbox('Error: slices are not consecutive');
    else
        ROI{val1}.RoiSlice = [ROI{val1}.RoiSlice(1:end); ROI{val2}.RoiSlice(1:end)];
        ROI{val1}.RoiRegion = [ROI{val1}.RoiRegion(1:end,:); ROI{val2}.RoiRegion(1:end,:)];
        ROI{val1}.RoiPosition = [ROI{val1}.RoiPosition(1:end), ROI{val2}.RoiPosition(1:end)];
        ROI{val1}.RoiKind = [ROI{val1}.RoiKind(1:end), ROI{val2}.RoiKind(1:end)];

        % -) If the two ROIs have already been processed, then this
        % function attaches the related slices information in the correct
        % fields, then opens GUI_Check_T1()
        % -) If none of the ROIs have been processed yet, then it updates
        % the dimension

        ROI{val1}.RoiPixelIdxList = ...
            [ROI{val1}.RoiPixelIdxList(1:end), ROI{val2}.RoiPixelIdxList(1:end)];
        ROI{val1}.RoiSegmentationPixelIdxList = ...
            [ROI{val1}.RoiSegmentationPixelIdxList(1:end), ROI{val2}.RoiSegmentationPixelIdxList(1:end)];
        ROI{val1}.RoiSegmentationPixelIdxBackwardList = ...
            [ROI{val1}.RoiSegmentationPixelIdxBackwardList(1:end), ROI{val2}.RoiSegmentationPixelIdxBackwardList(1:end)];
        ROI{val1}.RoiSegmentationPixelIdxForwardList =...
            [ROI{val1}.RoiSegmentationPixelIdxForwardList(1:end), ROI{val2}.RoiSegmentationPixelIdxForwardList(1:end)];
        ROI{val1}.Slices =...
            [ROI{val1}.Slices(1:end), ROI{val2}.Slices(1:end)];
        ROI{val1}.FinalMasks =...
            [ROI{val1}.FinalMasks(1:end), ROI{val2}.FinalMasks(1:end)];
        ROI{val1}.MasksSlicesBackward =...
            [ROI{val1}.MasksSlicesBackward(1:end), ROI{val2}.MasksSlicesBackward(1:end)];
        ROI{val1}.MasksSlicesForward =...
            [ROI{val1}.MasksSlicesForward(1:end), ROI{val2}.MasksSlicesForward(1:end)];
        ROI{val1}.MasksSlicesLevelSet =...
            [ROI{val1}.MasksSlicesLevelSet(1:end), ROI{val2}.MasksSlicesLevelSet(1:end)];
        ROI{val1}.aux_pos_ls =...
            [ROI{val1}.aux_pos_ls(1:end), ROI{val2}.aux_pos_ls(1:end)];
        ROI{val1}.SliceChoice =...
            [ROI{val1}.SliceChoice(1:end), ROI{val2}.SliceChoice(1:end)];
        ROI{val1}.AlternativeSegmentationList =...
            [ROI{val1}.AlternativeSegmentationList(1:end), ROI{val2}.AlternativeSegmentationList(1:end)];
        ROI{val1}.first_next =...
            [ROI{val1}.first_next(1:end), ROI{val2}.first_next(1:end)];
        if isfield(ROI{val1},'aux_pos_fwd') && ...
                isfield(ROI{val2},'aux_pos_fwd')
            % if the length of aux_pos_fwd is less than the slices number,
            % fill aux_pos_fwd with [] to reach the correct slices number,
            % then attach the second ROI
            if length(ROI{val1}.aux_pos_fwd) < length(ROI{val1}.RoiSlice)
                for i = (length(ROI{val1}.aux_pos_fwd)+1):length(ROI{val1}.RoiSlice)
                    ROI{val1}.aux_pos_fwd(i).row = [];
                    ROI{val1}.aux_pos_fwd(i).col = [];
                end
            end
            ROI{val1}.aux_pos_fwd =...
                [ROI{val1}.aux_pos_fwd(1:end), ROI{val2}.aux_pos_fwd(1:end)];

        elseif ~isfield(ROI{val1},'aux_pos_fwd') && ...
                isfield(ROI{val2},'aux_pos_fwd')
            for i = 1:length(ROI{val1}.RoiSlice)
                ROI{val1}.aux_pos_fwd(i).row = [];
                ROI{val1}.aux_pos_fwd(i).col = [];
            end
            ROI{val1}.aux_pos_fwd =...
                [ROI{val1}.aux_pos_fwd(1:end), ROI{val2}.aux_pos_fwd(1:end)];
        end

        % Introduced with ADC analysis - ADC analysis has to be done again
        % if the mask is modified, hence the ROI vectors containing ADC
        % fields have to be emptied
        if isfield(ROI{val1},'MasksADC') && ...
                isfield(ROI{val2},'MasksADC')
            ROI{val1}.MasksADC = [];
        end
        if isfield(ROI{val1},'first_next_ADC') && ...
                isfield(ROI{val2},'first_next_ADC')
            ROI{val1}.first_next_ADC = [];
        end
        if isfield(ROI{val1},'pos_ADC_masks') && ...
                isfield(ROI{val2},'pos_ADC_masks')
            ROI{val1}.pos_ADC_masks = [];
        end
        if isfield(ROI{val1},'aux_pos_ls_ADC') && ...
                isfield(ROI{val2},'aux_pos_ls_ADC')
            ROI{val1}.aux_pos_ls_ADC = [];
        end
        if isfield(ROI{val1},'RoiSegmentationPixelIdxListADC') && ...
                isfield(ROI{val2},'RoiSegmentationPixelIdxListADC')
            ROI{val1}.RoiSegmentationPixelIdxListADC = [];
        end
        if isfield(ROI{val1},'FinalMasksADC') && ...
                isfield(ROI{val2},'FinalMasksADC')
            ROI{val1}.FinalMasksADC = [];
        end
        if isfield(ROI{val1},'slices_merged')
            ROI{val1} = rmfield(ROI{val1},'slices_merged');
        end
        if isfield(ROI{val1},'slices_merged_ADC')
            ROI{val1} = rmfield(ROI{val1},'slices_merged_ADC');
        end
        if isfield(ROI{val1},'number_of_slices_after_resize')
            ROI{val1} = rmfield(ROI{val1},'number_of_slices_after_resize');
        end
        if isfield(ROI{val1},'number_of_slices_after_resize_ADC')
            ROI{val1} = rmfield(ROI{val1},'number_of_slices_after_resize_ADC');
        end
        if isfield(ROI{val1},'segmented_slices_adc')
            ROI{val1} = rmfield(ROI{val1},'segmented_slices_adc');
        end

        ROI{val1}.EndMR(1) = ROI{val1}.EndMR(1) + length(ROI{val2}.RoiSlice);

        Initialize_ROI_brain(val2);

        % To show changes in the GUI: if the current district is 'val1',
        % then it updates the start and end values. If the current district
        % is 'val2' (now disabled), it disables the relative buttons.
        PopUp_Districts;

        save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');
        disp(['ROI ', num2str(val2), ' has been attached to ROI ', num2str(val1)])
    end
else
    msgbox('Error: one slice has not been analysed yet')
end

