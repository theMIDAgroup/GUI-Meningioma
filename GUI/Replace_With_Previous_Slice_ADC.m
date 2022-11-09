%% Replace_With_Previous_Slice_ADC()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function replaces the polygon in the current slice with the one of 
% the previous slice, according to the choice made in the previous slice, 
% in the same manner as Replace_With_Previous_Slice().
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_ADC()
%%%% call: Show_ROI_ADC()

function Replace_With_Previous_Slice_ADC()

global ROI
global gui_ADC

ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k)) =...
    ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k - 1));


ROI{gui_ADC.val}.first_next_ADC(gui_ADC.it2show) = 1;
ROI{gui_ADC.val}.pos_ADC_masks{gui_ADC.k} = ROI{gui_ADC.val}.pos_ADC_masks{gui_ADC.k-1}; 
Show_ROI_ADC(gui_ADC.val,gui_ADC.it2show);

end
