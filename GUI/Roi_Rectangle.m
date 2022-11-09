%% Roi_Rectangle()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function plots a rectangular ROI using Put_Roi() and sets commands  
% in the ROI panel.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain(), panel 'ROI' (dropdown menu)
%%%% call: Put_Roi()

function Roi_Rectangle()

global gui_ROI;
RoiKind = 'imrect';
RoiPosition = [236,236,40,40];
Put_Roi(RoiKind,RoiPosition);
set(gui_ROI.PANELroi.PANEL3.PB2,'enable','on');
end
