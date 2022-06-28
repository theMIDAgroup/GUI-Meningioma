%% Slider_ContrastGUI_T1()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function sets the CLim values of the contrast, based on the maximum 
% and minimum Hounsfield values in the GUI T1.
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_T1()

function Slider_ContrastGUI_T1()

global gui_CHECK;

t = get(gui_CHECK.SLIDERcontrast,'value');
  
CLim_min = double(gui_CHECK.sup_hu)*(t-.5)+double(gui_CHECK.inf_hu);
CLim_max = double(gui_CHECK.sup_hu)*(t-.5)+double(gui_CHECK.sup_hu);

if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(gui_CHECK.ax, 'CLim', [CLim_min CLim_max]);
set(gui_CHECK.ax_ls, 'CLim', [CLim_min CLim_max]);
set(gui_CHECK.ax_fwd, 'CLim', [CLim_min CLim_max]);

% set(gui_CHECK.colorbar,'xtick',[round(CLim_min)+1,floor(CLim_max)]);
% set(gui_CHECK.colorbar,'xticklabel',{num2str(round(CLim_min)),num2str(floor(CLim_max))});
end
