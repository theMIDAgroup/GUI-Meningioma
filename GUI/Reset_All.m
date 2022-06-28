%% Reset_All()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function removes all the ROIs using Initialize_ROI_brain() and goes  
% back to the ROI menu calling Popup_Districts().
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain(), button "RESET ALL"
%%%% call: Initialize_ROI_brain()
%%%%       Popup_Districts()

function Reset_All()

global gui_ROI;

choice = questdlg('Do you want to clear ALL the existing ROI?', ...
    '!!Warning!!', 'Yes','No','No');
switch choice
    case 'Yes'
        for it = 1 : length(gui_ROI.PANELroi.ROIName)-2
            Initialize_ROI_brain(it);
        end
        PopUp_Districts;
    case 'No'
        return;
end
end