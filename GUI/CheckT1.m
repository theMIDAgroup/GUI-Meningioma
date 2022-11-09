%% CheckT1()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function checks if a ROI is already present. If yes, then it calls 
% GUI_Check_T1, otherwise it shows a warning message box. 
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain(), button 'Check T1 segmentation'
%%%% call: GUI_Check_T1()

function CheckT1()

global ROI

idx_ROI_enabled = [];

for val = 1 : size(ROI,2)
    if ROI{val}.Enable
        idx_ROI_enabled = [idx_ROI_enabled, val];
    end
end

if isempty(idx_ROI_enabled)
    msgbox('No ROIs enabled!')
else
    n_ROI = 1;
    val = idx_ROI_enabled(n_ROI);
    if isempty(ROI{val}.SliceChoice)
        msgbox('No mask present!')
    else
        GUI_Check_T1;
    end
end
