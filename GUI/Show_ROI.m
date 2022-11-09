%% Show_ROI()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function is used to show the current slice of the MRI image and the 
% segmentation results within the GUI (gui_T1). There are at most two 
% segmentation proposals for each slice of the tumor (T1).
% -------------------------------------------------------------------------
%%%% called by: Go_Next_Slice()
%%%%            Go_Previous_Slice()
%%%%            Replace_With_Previous_slice()         
%%%%            Replace_With_Next_slice()         
%%%%            GUI_Check_T1()

function Show_ROI(val,it)
global Info;
global gui_ROI;
global ROI;
global gui_T1;

% To save the choice 1 (ls, level-set) or 2 (fwd, forward)
if ROI{val}.first_next(it) == 0

    set(gui_T1.rb_ls,'value',1);
    set(gui_T1.rb_fwd,'value',0);
    
elseif ROI{val}.first_next(it) == 1

    if ROI{val}.SliceChoice(it) == 1
        set(gui_T1.rb_ls,'value',1);
        set(gui_T1.rb_fwd,'value',0);
    elseif ROI{val}.SliceChoice(it) == 2
        set(gui_T1.rb_ls,'value',0);
        set(gui_T1.rb_fwd,'value',1);
    end
end

xlim = get(gui_T1.ax,'xlim');
ylim = get(gui_T1.ax,'ylim');

I_MR = ...
   dicomread([Info.InputPath, gui_ROI.slash_pc_mac,...
   Info.FileMR(it+ROI{val}.RoiSlice(1)-1).name]);    

% I_MR_zoom = I_MR(ROI{val}.RoiRegion(it,3):ROI{val}.RoiRegion(it,4),...
%         ROI{val}.RoiRegion(it,1):ROI{val}.RoiRegion(it,2));
I_MR_zoom = I_MR;
 
if gui_T1.first_opening == 0
    gui_T1.first_opening = 1;
    gui_T1.sup_hu = max(max(I_MR));
    gui_T1.inf_hu = min(min(I_MR));
    CLim_max = gui_T1.sup_hu;
    CLim_min = gui_T1.inf_hu;
    set(gui_T1.SLIDERwindowDown_edit,'string',CLim_min);
    set(gui_T1.SLIDERwindowUp_edit,'string',CLim_max);
    set(gui_T1.ax, 'CLim', [CLim_min CLim_max]);
    set(gui_T1.ax_ls, 'CLim', [CLim_min CLim_max]);
    set(gui_T1.ax_fwd, 'CLim', [CLim_min CLim_max]);

end
       
imshow(I_MR_zoom,'parent',gui_T1.ax);
CLim_max = gui_T1.sup_hu;
CLim_min = gui_T1.inf_hu;
set(gui_T1.ax, 'CLim', [CLim_min CLim_max]);

% ls
imshow(I_MR_zoom,'parent',gui_T1.ax_ls);
set(gui_T1.ax_ls, 'CLim', [CLim_min CLim_max]);

if ROI{val}.first_next(it) == 0   % first time I see the slice

    aux_ls = zeros(size(I_MR));   % initialize aux_ls same size as the slice I_MR
    aux_ls(ROI{val}.RoiSegmentationPixelIdxList{it}) = 1;  % mask interior 

    B_ls = bwboundaries(aux_ls);
    B_ls = [B_ls{1,1}(:,2),B_ls{1,1}(:,1)];
    B_ls = B_ls(1:4:end,:);        % downsize the boundary (one every 4 dots)

    gui_T1.ROI_ls(it) = drawpolygon('Parent',gui_T1.ax_ls,...
        'Position',B_ls,'Color', 'red', 'FaceAlpha', 0);

else
    ROI_pos = [ROI{val}.aux_pos_ls(it).row,...   % otherwise draw polygon with previously assigned 
        ROI{val}.aux_pos_ls(it).col];            % pixel positions, defined in go next slice
    gui_T1.ROI_ls(it) = drawpolygon('Parent',gui_T1.ax_ls,...
        'Position',ROI_pos,'Color', 'red', 'FaceAlpha', 0);
end

if ROI{val}.AlternativeSegmentationList(it) == 1  ||...
         ROI{val}.AlternativeSegmentationList(it) == 3 
        
    % fwd
    set(gui_T1.rb_fwd,'Visible','on')
    set(gui_T1.ax_fwd,'Visible','on');
    imshow(I_MR_zoom,'parent',gui_T1.ax_fwd);
    set(gui_T1.ax_fwd, 'CLim', [CLim_min CLim_max]);
        
    if ROI{val}.first_next(it) == 0
        aux_fwd = zeros(size(I_MR));
        aux_fwd(ROI{val}.RoiSegmentationPixelIdxForwardList{it}) = 1;

        B_fwd = bwboundaries(aux_fwd);
        B_fwd = [B_fwd{1,1}(:,2),B_fwd{1,1}(:,1)];
        B_fwd = B_fwd(1:4:end,:);
        gui_T1.ROI_fwd(it) = drawpolygon('Parent',gui_T1.ax_fwd,...
            'Position',B_fwd,'Color', 'green', 'FaceAlpha', 0);%, 'MarkerSize',4);
        
    else

        ROI_pos = [ROI{val}.aux_pos_fwd(it).row,...
            ROI{val}.aux_pos_fwd(it).col];
        gui_T1.ROI_fwd(it) = drawpolygon('Parent',gui_T1.ax_fwd,...
            'Position',ROI_pos,'Color', 'green', 'FaceAlpha', 0);%, 'MarkerSize',4);
        
    end

elseif ROI{val}.AlternativeSegmentationList(it) == 2
    % fwd
    set(gui_T1.rb_fwd,'Visible','on')
    set(gui_T1.ax_fwd,'Visible','on');
    imshow(I_MR_zoom,'parent',gui_T1.ax_fwd);
    set(gui_T1.ax_fwd, 'CLim', [CLim_min CLim_max]);
    
    if ROI{val}.first_next(it) == 0
        aux_fwd = zeros(size(I_MR));
        aux_fwd(ROI{val}.RoiSegmentationPixelIdxBackwardList{it}) = 1;

        B_fwd = bwboundaries(aux_fwd);
        B_fwd = [B_fwd{1,1}(:,2),B_fwd{1,1}(:,1)];
        B_fwd = B_fwd(1:4:end,:);

        gui_T1.ROI_fwd(it) = drawpolygon('Parent',gui_T1.ax_fwd,...
            'Position',B_fwd,'Color', 'green', 'FaceAlpha', 0);%, 'MarkerSize',4);
    else
        
        ROI_pos = [ROI{val}.aux_pos_fwd(it).row,...
            ROI{val}.aux_pos_fwd(it).col];
        gui_T1.ROI_fwd(it) = drawpolygon('Parent',gui_T1.ax_fwd,...
                'Position',ROI_pos,'Color', 'green', 'FaceAlpha', 0);%, 'MarkerSize',4);
            
    end   

else
    set(gui_T1.rb_fwd,'Visible','off')
    axisObj = gui_T1.ax_fwd;
    if ishandle(axisObj)
        handles2delete = get(axisObj,'Children');
        delete(handles2delete);
        set(axisObj,'visible','off') 
    end

end


end

