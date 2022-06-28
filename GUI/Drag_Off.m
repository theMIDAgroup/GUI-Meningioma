%% Drag_Off()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% Mouse-motion callback function.
% -------------------------------------------------------------------------
%%%% called by: Show_Image()
%%%%            Enable_MouseControl()

function Drag_Off()
global gui_ROI;
set(gui_ROI.fig,'WindowButtonMotionFcn','');
end

