%% Reset_Roi()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function removes an existing ROI using Initialize_ROI_brain() and  
% goes back to the ROI menu calling Popup_Districts. It deletes the
% corresponding folder inside OUTPUT_MASKS.
% -------------------------------------------------------------------------
%%%% called by: Put_Roi()
%%%%            main_gui_brain(), button 'RESET ROI'
%%%% call: Initialize_ROI_brain()
%%%%       PopUp_Districts()

function Reset_Roi()
global gui_ROI;
global Info;
global ROI;

choice = questdlg('Do you want to clear the selected ROI?', ...
    '!!Warning!!', 'Yes','No','No');
switch choice
    case 'Yes'

        Initialize_ROI_brain(gui_ROI.PopupValue);
        PopUp_Districts;
        % Remove the corresponding folder inside OUTPUT_MASKS
        ROIfolder = [Info.OutputPathMASK gui_ROI.slash_pc_mac 'MASK_District',num2str(gui_ROI.PopupValue)];
        [~, ~, ~] = rmdir(ROIfolder, 's');
        disp(['Folder MASK_District', num2str(gui_ROI.PopupValue), ' has been deleted'])
        save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');
        save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat');  
        
    case 'No'
        return;
end


end

