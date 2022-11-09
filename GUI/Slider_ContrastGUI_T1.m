%% Slider_ContrastGUI_T1()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function sets the CLim values of the contrast, based on the maximum 
% and minimum Hounsfield values in the GUI T1.
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_T1()

function Slider_ContrastGUI_T1()

global gui_T1;

t = get(gui_T1.SLIDERcontrast,'value');
  
CLim_min = double(gui_T1.sup_hu)*(t-.5)+double(gui_T1.inf_hu);
CLim_max = double(gui_T1.sup_hu)*(t-.5)+double(gui_T1.sup_hu);

if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(gui_T1.ax, 'CLim', [CLim_min CLim_max]);
set(gui_T1.ax_ls, 'CLim', [CLim_min CLim_max]);
set(gui_T1.ax_fwd, 'CLim', [CLim_min CLim_max]);

% set(gui_T1.colorbar,'xtick',[round(CLim_min)+1,floor(CLim_max)]);
% set(gui_T1.colorbar,'xticklabel',{num2str(round(CLim_min)),num2str(floor(CLim_max))});
end
