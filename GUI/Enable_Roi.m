%% Enable_Roi()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% this function enables ROIs and the other checkboxes for output selection.
% -------------------------------------------------------------------------
%%%% called by: PopUp_Districts()
%%%%            Roi_End()
%%%%            main_gui_brain() - panel 'ROI 4'

function Enable_Roi()

global gui_ROI;
global ROI;
val = gui_ROI.PopupValue;
val_enable = get(gui_ROI.PANELroi.PANEL4.CKBOX1,'value');
ROI{val}.Enable = val_enable;

if val_enable
    set(gui_ROI.PANELroi.PANEL4.CKBOX2,'enable','on');
else
    set(gui_ROI.PANELroi.PANEL4.CKBOX2,'enable','off');
end

end