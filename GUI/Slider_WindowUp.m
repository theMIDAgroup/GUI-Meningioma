%% Slider_WindowUp()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function changes the CLim of the Hounsfield values in the GUI ROI.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain() - panel 'MR Figure'

function Slider_WindowUp()
global gui_ROI;


set(gui_ROI.PANELax.SLIDERcontrast,'value',0.5);
aux_up = get(gui_ROI.PANELax.SLIDERwindowUp_edit,'string');
aux_up = str2num(aux_up);
gui_ROI.sup_hu = aux_up;
CLim_max = aux_up;
aux = get(gui_ROI.PANELax.ax, 'CLim');
CLim_min = aux(1);
if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(gui_ROI.PANELax.ax, 'CLim', [CLim_min CLim_max]);
get(gui_ROI.PANELax.ax, 'CLim')

set(gui_ROI.PANELax.colorbar,'xtick',[round(CLim_min)+1,floor(CLim_max)]);
set(gui_ROI.PANELax.colorbar,'xticklabel',{num2str(round(CLim_min)),num2str(floor(CLim_max))});
set(gui_ROI.PANELax.colorbar,'Color',gui_ROI.fgc);
set(gui_ROI.PANELax.colorbar,'Fontsize', gui_ROI.fs)
end
