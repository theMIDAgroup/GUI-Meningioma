%% Replace_With_Previous_Slice()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function replaces the polygon in the current slice with the one of 
% the previous slice, according to the choice made in the previous 
% slice, example: 
% 
% IF choice for slice k-1 = 1, then it replaces the polygon for choice 1 
% in slice k and it leaves unvaried choice 2 (if existing).
% IF choice for slice k-1 = 2, then it replaces the polygon for choice 2
% in slice k (it also creates the panel if it did not exist before) and it
% leaves unvaried choice 1 (that exists by default). 
% It also updates AlternativeSegmentationList.
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_T1()
%%%% call: Show_ROI()

function Replace_With_Previous_Slice()

global gui_ROI
global ROI
global gui_T1
global Info

% CASE 1: the previous choice was = 1
if ROI{gui_T1.val}.SliceChoice(gui_T1.SlicesList{gui_T1.val}(gui_T1.k - 1))==1

     % If I replace with choice 1 from previous slice, then choice for this slice becomes 1
    ROI{gui_T1.val}.SliceChoice(gui_T1.SlicesList{gui_T1.val}(gui_T1.k))=1;

    ROI{gui_T1.val}.aux_pos_ls(gui_T1.SlicesList{gui_T1.val}(gui_T1.k)) =...
        ROI{gui_T1.val}.aux_pos_ls(gui_T1.SlicesList{gui_T1.val}(gui_T1.k - 1));

    if ROI{gui_T1.val}.AlternativeSegmentationList(gui_T1.k) ~= 0   % if the second panel exists
            % store aux_pos_fwd as they are
        aux = gui_T1.ROI_fwd(gui_T1.k);       % it takes the polygon coordinates from the GUI
        ROI{gui_T1.val}.aux_pos_fwd(gui_T1.k).row = aux.Position(:,1);
        ROI{gui_T1.val}.aux_pos_fwd(gui_T1.k).col = aux.Position(:,2);
    end
    
    ROI{gui_T1.val}.first_next(gui_T1.it2show) = 1;
    Show_ROI(gui_T1.val,gui_T1.it2show);

% CASE 2: the previous choice was = 2
elseif ROI{gui_T1.val}.SliceChoice(gui_T1.SlicesList{gui_T1.val}(gui_T1.k - 1))==2

    if ROI{gui_T1.val}.AlternativeSegmentationList(gui_T1.k) ~= 0   % if the second panel exists
        
        % If I replace with choice 2 from previous slice, then choice for this slice becomes 2
        ROI{gui_T1.val}.SliceChoice(gui_T1.SlicesList{gui_T1.val}(gui_T1.k))=2;
        
        % store aux_pos_ls as they are
        aux = gui_T1.ROI_ls(gui_T1.k);       % it takes the polygon coordinates from the GUI
        ROI{gui_T1.val}.aux_pos_ls(gui_T1.k).row = aux.Position(:,1);
        ROI{gui_T1.val}.aux_pos_ls(gui_T1.k).col = aux.Position(:,2);

        % store in aux_pos_fwd the previous positions
        ROI{gui_T1.val}.aux_pos_fwd(gui_T1.SlicesList{gui_T1.val}(gui_T1.k)) =...
            ROI{gui_T1.val}.aux_pos_fwd(gui_T1.SlicesList{gui_T1.val}(gui_T1.k - 1));

    else
        ROI{gui_T1.val}.SliceChoice(gui_T1.SlicesList{gui_T1.val}(gui_T1.k))=1;
        ROI{gui_T1.val}.aux_pos_ls(gui_T1.SlicesList{gui_T1.val}(gui_T1.k)) =...
            ROI{gui_T1.val}.aux_pos_fwd(gui_T1.SlicesList{gui_T1.val}(gui_T1.k - 1));
    end
    
    ROI{gui_T1.val}.first_next(gui_T1.it2show) = 1;
    Show_ROI(gui_T1.val,gui_T1.it2show);

end


end
