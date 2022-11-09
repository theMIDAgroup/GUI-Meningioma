%% Slider_Contrast()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function sets the CLim values of the contrast, based on the maximum 
% and minimum Hounsfield values in the GUI ROI.
% -------------------------------------------------------------------------
%%%% called by: Show_Image()
%%%%            main_gui_brain() - panel 'MRI Figure'

function Slider_Contrast()
global gui_ROI;

t = get(gui_ROI.PANELax.SLIDERcontrast,'value');
  
CLim_min = double(gui_ROI.sup_hu)*(t-.5)+double(gui_ROI.inf_hu);
CLim_max = double(gui_ROI.sup_hu)*(t-.5)+double(gui_ROI.sup_hu);

if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
if CLim_min==CLim_max
    CLim_max = CLim_max+100;
end
set(gui_ROI.PANELax.ax, 'CLim', [CLim_min CLim_max]);
set(gui_ROI.PANELax.colorbar,'xtick',[round(CLim_min)+1,floor(CLim_max)]);
set(gui_ROI.PANELax.colorbar,'xticklabel',{num2str(round(CLim_min)),num2str(floor(CLim_max))});
end
