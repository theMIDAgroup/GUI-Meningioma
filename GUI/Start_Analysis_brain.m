%% Start_Analysis_brain
% LISCOMP Lab 2021- 2022 https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% Functions for the segmentation and outputs production.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain() - panel 'Start Analysis'
%%%% call:  Save_All()
%%%%        Segmentation_Analysis_brain()
%%%%        GUI_Check_T1()

global gui_ROI;
global ROI;

Save_All;

count = 0;
for val = 1:size(ROI,2)
    if ROI{val}.Enable
        if ~isempty(ROI{val}.RoiSegmentationPixelIdxList)
            count = count+1; % it updates if other segmentation are already present in some ROIs
        end 
    end
end
 
if count ~= 0  % if other segmentation are already present in some ROIs
    choice = questdlg('Do you want to restart the segmentation analysis?', ...
        '!!Warning!!', 'No');
    switch choice
        case 'Yes'
            Segmentation_Analysis_brain;
            GUI_Check_T1;
        case 'No'
            GUI_Check_T1;
    end
else % if it is the first time, proceed 
    Segmentation_Analysis_brain;
    GUI_Check_T1;
end


