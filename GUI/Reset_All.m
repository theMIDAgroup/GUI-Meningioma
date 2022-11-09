%% Reset_All()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION:
% This function removes all the ROIs using Initialize_ROI_brain() and goes
% back to the ROI menu calling Popup_Districts(). It deletes the
% corresponding folders inside OUTPUT_MASKS.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain(), button 'RESET ALL'
%%%% call: Initialize_ROI_brain()
%%%%       Popup_Districts()

function Reset_All()

global gui_ROI;
global Info;
global ROI;

choice = questdlg('Do you want to clear ALL the existing ROIs?', ...
    '!!Warning!!', 'Yes','No','No');
switch choice
    case 'Yes'

        for it = 1 : length(gui_ROI.PANELroi.ROIName)-2
            Initialize_ROI_brain(it);
            % Remove the corresponding folders inside OUTPUT_MASKS
            ROIfolder = [Info.OutputPathMASK gui_ROI.slash_pc_mac 'MASK_District',num2str(it)];
            [~, ~, ~] = rmdir(ROIfolder, 's');
            disp(['Folder MASK_District', num2str(it), ' has been deleted'])
            save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');
            save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat');  
        end
        PopUp_Districts;

    case 'No'
        return;
end

end