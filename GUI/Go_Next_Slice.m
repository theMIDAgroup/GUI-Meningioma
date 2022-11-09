%% Go_Next_Slice()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function saves the changes of the current mask in gui_T1 and sets 
% the following slice as the new current slice.
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_T1()
%%%% call: Show_ROI()

function Go_Next_Slice()
global ROI;
global gui_T1;

if ROI{gui_T1.val}.first_next(gui_T1.it2show) == 0
    ROI{gui_T1.val}.first_next(gui_T1.it2show) = 1;
end

% Save the ROIs modified in Show_ROI
aux = gui_T1.ROI_ls(gui_T1.it2show);     % it takes the polygon coordinates from the GUI
ROI{gui_T1.val}.aux_pos_ls(gui_T1.it2show).row = aux.Position(:,1);
ROI{gui_T1.val}.aux_pos_ls(gui_T1.it2show).col = aux.Position(:,2);

if ROI{gui_T1.val}.AlternativeSegmentationList(gui_T1.it2show) ~= 0
    aux = gui_T1.ROI_fwd(gui_T1.it2show);
    ROI{gui_T1.val}.aux_pos_fwd(gui_T1.it2show).row = aux.Position(:,1);
    ROI{gui_T1.val}.aux_pos_fwd(gui_T1.it2show).col = aux.Position(:,2);
end

% check the radio button and substitute
ix_ls = get(gui_T1.rb_ls,'value');
ix_fwd = get(gui_T1.rb_fwd,'value');

if ix_ls == 1 && ix_fwd == 0
    ROI{gui_T1.val}.SliceChoice(gui_T1.it2show) = 1;   % choice n. 1 (red dots)
elseif ix_ls == 0 && ix_fwd == 1
    ROI{gui_T1.val}.SliceChoice(gui_T1.it2show) = 2;   % choice n. 2 (green dots)
end
  
% if not the last slice, update k to k+1
if gui_T1.it2show ~= gui_T1.SlicesList{gui_T1.val}(gui_T1.NumSlices{gui_T1.val})
    gui_T1.k = gui_T1.k + 1;     
    gui_T1.it2show = gui_T1.SlicesList{gui_T1.val}(gui_T1.k);
    set(gui_T1.TxtSlice_val,'string', num2str(gui_T1.it2show));
    Show_ROI(gui_T1.val,gui_T1.it2show)
else   
    % If last slice of the last ROI
    if gui_T1.it2show == gui_T1.SlicesList{gui_T1.val}(gui_T1.NumSlices{gui_T1.val}) &&...
            gui_T1.val == max(gui_T1.idx_ROI_enabled)
        set(gui_T1.Next_slice,'enable','off')
        set(gui_T1.Done,'enable','on')
    % If last slice, but not last ROI   
    elseif gui_T1.it2show == gui_T1.SlicesList{gui_T1.val}(gui_T1.NumSlices{gui_T1.val}) &&...
            gui_T1.val ~= max(gui_T1.idx_ROI_enabled)
        gui_T1.n_ROI = gui_T1.n_ROI + 1;
        gui_T1.val = gui_T1.idx_ROI_enabled(gui_T1.n_ROI);
        set(gui_T1.TxtROI_val,'string', num2str(gui_T1.val));
        gui_T1.k = 1;
        gui_T1.it2show = gui_T1.SlicesList{gui_T1.val}(gui_T1.k);
        set(gui_T1.TxtSlice_val,'string', num2str(gui_T1.it2show));
        set(gui_T1.TxtSlice_num,'string', num2str(length(gui_T1.SlicesList{gui_T1.val})));  
        Show_ROI(gui_T1.val,gui_T1.it2show)
    end
end

% in order for the "previous slice" button to work
if gui_T1.val == min(gui_T1.idx_ROI_enabled) && gui_T1.it2show == 1
    set(gui_T1.Previous_slice,'enable','off')
else
    set(gui_T1.Previous_slice,'enable','on')
end

if gui_T1.val == max(gui_T1.idx_ROI_enabled) &&...
        gui_T1.it2show == gui_T1.SlicesList{gui_T1.val}(gui_T1.NumSlices{gui_T1.val})
    set(gui_T1.Next_slice,'enable','off')
    set(gui_T1.Done,'enable','on')
else
    set(gui_T1.Next_slice,'enable','on')
end

% if checking the first slice, disable the button for backward replacement
if gui_T1.it2show == 1
    set(gui_T1.replace_with_previous,'enable','off')
else
    set(gui_T1.replace_with_previous,'enable','on')
end

% if checking the last slice, disable the button for forward replacement
if gui_T1.it2show == gui_T1.SlicesList{gui_T1.val}(gui_T1.NumSlices{gui_T1.val})
    set(gui_T1.replace_with_next,'enable','off')
else
    set(gui_T1.replace_with_next,'enable','on')
end

% Set the contrast as in the previous slice
t = get(gui_T1.SLIDERcontrast,'value');
CLim_min = double(gui_T1.sup_hu)*(t-.5)+double(gui_T1.inf_hu);
CLim_max = double(gui_T1.sup_hu)*(t-.5)+double(gui_T1.sup_hu);
if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(gui_T1.ax, 'CLim', [CLim_min CLim_max]);
set(gui_T1.ax_ls, 'CLim', [CLim_min CLim_max]);
set(gui_T1.ax_fwd, 'CLim', [CLim_min CLim_max]);

end

