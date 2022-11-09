%% CheckADC()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function checks if ADC segmentation is already present. If yes, then
% it calls GUI_Check_ADC, otherwise it shows a warning message box. 
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain(), button 'Check ADC segmentation'
%%%% call: GUI_Check_ADC()

function CheckADC()

global Info
global ROI
global gui_ROI

% First check if the ADC folder exists, then check if first_next is a field
mydir = Info.InputPath;
string_mydir  = strfind(mydir,gui_ROI.slash_pc_mac);    
newdir = mydir(1:string_mydir(end)-1);
ADC_directory  = [newdir gui_ROI.slash_pc_mac 'ADC'];

if exist(ADC_directory,'dir')

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

        if isfield(ROI{val},'first_next_ADC')
            GUI_Check_ADC;
        else
            msgbox('No mask present!')
        end
    end
else
    msgbox('No ADC present!')
end

