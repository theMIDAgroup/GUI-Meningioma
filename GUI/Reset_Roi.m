%% Reset_Roi()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function removes an existing ROI using Initialize_ROI_brain() and  
% goes back to the ROI menu calling Popup_Districts.
% -------------------------------------------------------------------------
%%%% called by: Put_Roi()
%%%%            main_gui_brain(), button "RESET ROI"
%%%% call: Initialize_ROI_brain()
%%%%       PopUp_Districts()

function Reset_Roi()
global gui_ROI;

Initialize_ROI_brain(gui_ROI.PopupValue);
PopUp_Districts;

end

