%% Replace_With_Next_Slice_ADC()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function replaces the polygon in the current slice with the one of 
% the following slice, according to the choice made in the following slice,
% in the same manner as Replace_With_Next_Slice().
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_ADC()
%%%% call: Show_ROI_ADC()

function Replace_With_Next_Slice_ADC()

global ROI
global gui_ADC
  
% the value of first_next = 1, 
% it is assumed that one first checks the following slice, then comes back
% and replaces the current slice with the following, hence aux_pos_ls must 
% already exist.

if ~isempty(ROI{gui_ADC.val}.pos_ADC_masks{gui_ADC.k+1})  % if it's not the first time I open ADC
    ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k)) =...
    ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k + 1));
   
    ROI{gui_ADC.val}.pos_ADC_masks{gui_ADC.k} = ROI{gui_ADC.val}.pos_ADC_masks{gui_ADC.k+1};  

else
    msgbox('View next slice first')
end

Show_ROI_ADC(gui_ADC.val,gui_ADC.it2show);

end
