%% Show_Image()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function selects the MR image to show: it reads the associated DICOM
% file and shows the MR image.
% -------------------------------------------------------------------------
%%%% called by: Select_MR_Series()
%%%%            Slider_Image_brain()
%%%%            PopUp_Districts()
%%%%            Put_Roi()
%%%% call: Slider_Contrast()
%%%%       Enable_MouseControl()
%%%%       Drag_Off()

function Show_Image()
global Info;
global gui_ROI;

xlim = get(gui_ROI.PANELax.ax,'xlim'); % VC
ylim = get(gui_ROI.PANELax.ax,'ylim');

gui_ROI.SliceNumber = round(get(gui_ROI.PANELax.SLIDERimage, 'Value')*(Info.NumberFileMR-1)+1);
str = sprintf('slice number: %d / %d',gui_ROI.SliceNumber,Info.NumberFileMR);
set(gui_ROI.PANELax.TXT,'string',str);

I_MR = dicomread([Info.InputPath, gui_ROI.slash_pc_mac, Info.FileMR(gui_ROI.SliceNumber).name]);

% xlim = [0, size(I_MR,2)]; % VC
% ylim = [0, size(I_MR,1)];

imshow(I_MR,'parent',gui_ROI.PANELax.ax);
set(gui_ROI.PANELax.ax, 'xlim', xlim ,'ylim', ylim);
if gui_ROI.first_opening == 0
    gui_ROI.first_opening = 1;
    gui_ROI.PANELax.colorbar = colorbar('peer',gui_ROI.PANELax.ax,'horiz');
    set(gui_ROI.PANELax.colorbar,'Color',gui_ROI.fgc);
    set(gui_ROI.PANELax.colorbar,'Fontsize', gui_ROI.fs);
    set(get(gui_ROI.PANELax.colorbar, 'Title'), 'Fontsize', gui_ROI.fs)
    gui_ROI.sup_hu = max(max(I_MR));
    gui_ROI.inf_hu = min(min(I_MR));
    CLim_max = gui_ROI.sup_hu;
    CLim_min = gui_ROI.inf_hu;
    if CLim_max == CLim_min
        CLim_max = CLim_max+100;
    end
    set(gui_ROI.PANELax.SLIDERwindowDown_edit,'string',CLim_min);
    set(gui_ROI.PANELax.SLIDERwindowUp_edit,'string',CLim_max);
    set(gui_ROI.PANELax.ax, 'CLim', [CLim_min CLim_max]);
    set(gui_ROI.PANELax.colorbar,'xtick',[round(CLim_min)+1,floor(CLim_max)]);
    set(gui_ROI.PANELax.colorbar,'xticklabel',{num2str(round(CLim_min)),num2str(floor(CLim_max))});
else
    gui_ROI.PANELax.colorbar = colorbar('peer',gui_ROI.PANELax.ax,'horiz');
    set(get(gui_ROI.PANELax.colorbar, 'Title'), 'Fontsize', gui_ROI.fs)
    set(gui_ROI.PANELax.colorbar,'Color',gui_ROI.fgc);
    set(gui_ROI.PANELax.colorbar,'Fontsize', gui_ROI.fs)
end

Slider_Contrast;
Enable_MouseControl;
Drag_Off;

end
