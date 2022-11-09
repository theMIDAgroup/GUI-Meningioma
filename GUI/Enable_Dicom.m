%% Enable_Dicom()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% this function enables the saving of the results in Dicom format.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain() - panel 'ROI 4'

function Enable_Dicom()
global gui_ROI;
global ROI;
val = gui_ROI.PopupValue;
val_enable = get(gui_ROI.PANELroi.PANEL4.CKBOX2,'value');
ROI{val}.OutputDicom = val_enable;
end

