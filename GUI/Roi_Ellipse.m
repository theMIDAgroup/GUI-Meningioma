%% Roi_Ellipse()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function plots an elliptic ROI using Put_Roi() and sets commands in 
% the ROI panel.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain(), panel ROI (dropdown menu)
%%%% call: Put_Roi()

function Roi_Ellipse()

global gui_ROI;
RoiKind = 'imellipse';
RoiPosition = [236,236,40,40];
Put_Roi(RoiKind,RoiPosition);
set(gui_ROI.PANELroi.PANEL3.PB2,'enable','on');
end
