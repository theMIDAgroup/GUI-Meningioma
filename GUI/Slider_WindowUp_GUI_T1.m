%% Slider_WindowUp_GUI_T1()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function changes the CLim of the Hounsfield values in the GUI T1.
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_T1()

function Slider_WindowUp_GUI_T1()
global gui_T1;


set(gui_T1.SLIDERcontrast,'value',0.5);
aux_up = get(gui_T1.SLIDERwindowUp_edit,'string');
aux_up = str2num(aux_up);
gui_T1.sup_hu = aux_up;
CLim_max = aux_up;
aux = get(gui_T1.ax, 'CLim');
CLim_min = aux(1);
if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(gui_T1.ax, 'CLim', [CLim_min CLim_max]);
set(gui_T1.ax_ls, 'CLim', [CLim_min CLim_max]);
set(gui_T1.ax_fwd, 'CLim', [CLim_min CLim_max]);

% a che serve???
% get(gui_T1.ax, 'CLim')

% set(gui_T1.colorbar,'xtick',[round(CLim_min)+1,floor(CLim_max)]);
% set(gui_T1.colorbar,'xticklabel',{num2str(round(CLim_min)),num2str(floor(CLim_max))});
% set(gui_T1.colorbar,'Color',gui_ROI.fgc);
% set(gui_T1.colorbar,'Fontsize', gui_ROI.fs)
end
