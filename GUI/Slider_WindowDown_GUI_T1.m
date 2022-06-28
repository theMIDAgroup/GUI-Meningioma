%% Slider_WindowDown_GUI_T1()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function changes the CLim of the Hounsfield values in the GUI T1.
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_T1()

function Slider_WindowDown_GUI_T1()

global gui_ROI;
global gui_CHECK;

set(gui_CHECK.SLIDERcontrast,'value',0.5);
aux_down = get(gui_CHECK.SLIDERwindowDown_edit,'string');
aux_down = str2num(aux_down);
gui_CHECK.inf_hu = aux_down;
CLim_min = aux_down;
aux = get(gui_CHECK.ax, 'CLim');
CLim_max = aux(2);
if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(gui_CHECK.ax, 'CLim', [CLim_min CLim_max]);
set(gui_CHECK.ax_ls, 'CLim', [CLim_min CLim_max]);
set(gui_CHECK.ax_fwd, 'CLim', [CLim_min CLim_max]);
%
% set(gui_CHECK.colorbar,'xtick',[round(CLim_min)+1,floor(CLim_max)]);
% set(gui_CHECK.colorbar,'xticklabel',{num2str(round(CLim_min)),num2str(floor(CLim_max))});
% set(gui_CHECK.colorbar,'Color',gui_ROI.fgc);
% set(gui_CHECK.colorbar,'Fontsize', gui_ROI.fs)
end