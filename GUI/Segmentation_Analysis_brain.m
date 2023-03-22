%% Segmentation_Analysis_brain()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function computes the segmentation of the tumours via active
% contours algorithm, based on techniques of curve evolution, Mumford–Shah
% functional for segmentation and level sets.
% See: "Active Contours Without Edges" by Tony F. Chan, Member, IEEE, and Luminita A. Vese
% -------------------------------------------------------------------------
%%%% called by: Start_Analysis_brain()
%%%% call: level_set_segmentation()
%%%%       Find_BedPixelIdxList()          (included in this file)
%%%%       SegmentationAuto_MR()           (included in this file)

function Segmentation_Analysis_brain()

global ROI;
global Info;
global gui_ROI;

str = [Info.InputPath, gui_ROI.slash_pc_mac, Info.FileMR(1).name];

BedPixelIdxList = Find_BedPixelIdxList(str);
BedPixelIdxList = [];

Nval = length(ROI);
temp = false;
%% Get the voxel size
Info.PixelSizeMR = [];
Info.SizeMR = [];

INFO = dicominfo(str);
Info.PixelSizeMR = [INFO.PixelSpacing(1,1),INFO.PixelSpacing(2,1)];
Info.SizeMR = double([INFO.Rows, INFO.Columns]);
Info.ImagePositionMR = double(INFO.ImagePositionPatient);

for val = 1 : size(ROI,2)
    if ROI{val}.Enable
        
        ROI{val}.first_next = [];         
        ROI{val}.SliceChoice = [];      
        
        % to clear up ADC related fields
        if isfield(ROI{val},'EnableADC')
            ROI{val} = rmfield(ROI{it},'EnableADC');
        end
        if isfield(ROI{val},'first_next_ADC')
            ROI{val} = rmfield(ROI{val},'first_next_ADC');
        end
        if isfield(ROI{val},'MasksADC')
            ROI{val}.MasksADC = [];
        end
        if isfield(ROI{val},'pos_ADC_masks')
            ROI{val}.pos_ADC_masks = [];
        end
        if isfield(ROI{val},'aux_pos_ls_ADC')
            ROI{val}.aux_pos_ls_ADC = [];
        end
        if isfield(ROI{val},'RoiSegmentationPixelIdxListADC')
            ROI{val}.RoiSegmentationPixelIdxListADC = [];
        end
        if isfield(ROI{val},'FinalMasksADC')
            ROI{val}.FinalMasksADC = [];
        end
        if isfield(ROI{val},'slices_merged') 
            ROI{val} = rmfield(ROI{val},'slices_merged');
        end
        if isfield(ROI{val},'slices_merged_ADC')
            ROI{val} = rmfield(ROI{val},'slices_merged_ADC');
        end
        if isfield(ROI{val},'number_of_slices_after_resize')
            ROI{val} = rmfield(ROI{val},'number_of_slices_after_resize');
        end
        if isfield(ROI{val},'number_of_slices_after_resize_ADC')
            ROI{val} = rmfield(ROI{val},'number_of_slices_after_resize_ADC');
        end
        if isfield(ROI{val},'segmented_slices_adc')
            ROI{val} = rmfield(ROI{val},'segmented_slices_adc');
        end

        SegmentationAuto_MR(val,BedPixelIdxList); 
        
        ROI{val}.Segmented = true;
        temp = true;
    end
    
    VoxelNumber = 0;
    for it_vn = 1 : length(ROI{val}.RoiSegmentationPixelIdxList)
        VoxelNumber = VoxelNumber+length(ROI{val}.RoiSegmentationPixelIdxList{it_vn});
    end
    ROI{val}.VoxelNumberMR = VoxelNumber;
    
end

if temp
    save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');   
end
end
%%
%%- Find_BedPixelIdxList
%%-
function[BedPixelIdxList] = Find_BedPixelIdxList(str)
x1 = 191.57;
y1 = -38.65-3*1.3672;
x2 = 210.25;
y2 = -26.96-3*1.3672;

INFO_ct = dicominfo(str);

np = INFO_ct.Rows;
position = INFO_ct.ImagePositionPatient;
pixel_spacing = INFO_ct.PixelSpacing;
x = position(1)+(0:1:np-1)*pixel_spacing(1);
y = position(2)+(0:1:np-1)*pixel_spacing(2);

bed = zeros(np);
for t = 1:np
    if abs(x(t))<= x1
        temp = (y1+3*1.3672)/x1^2*x(t)^2-3*1.3672;
        [~,ind] = min(abs(y-temp));
    elseif x(t)>x1
        temp = (y2-y1)/(x2-x1)*(x(t)-x1)+y1;
        [~,ind] = min(abs(y-temp));
    else
        temp = -(y2-y1)/(x2-x1)*(x(t)+x1)+y1;
        [~,ind] = min(abs(y-temp));
    end
    bed(ind:end,t) = 1;
end

BedPixelIdxList = find(bed);
end
%%
%%- SegmentationAuto_MR 
%%-
function SegmentationAuto_MR(val,BedPixelIdxList,it_start)

global Info;
global gui_ROI;
global ROI;

if nargin<3, it_start = 1; end

max_its = 50000;
min_its = 10;
alpha = 0.1;%1.1;
cutoff_pixel = 20;

Nit = length(ROI{val}.RoiSlice);
str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' segmenting ROI: ' ROI{val}.Name];
w = waitbar(0,'Segmentation in progress','Name','Segmentation in progress');
waitbar(0, w,str_wbar);

% Counter for continuity between slices: if the algorithm keeps the same
% slice segmentation for more than 2 times, then on the third slice
% segmentation the algorithm will keep the result from the level set
% segmentation, whatever the result (otherwise the risk is to keep the same
% mask for many slices)

count = 0;
max_same_slices = 2;

% For problematic slices 
aux_forward = zeros(1,Nit);  % = 1 when a slice is the same as the previous one (in forward)
aux_backward = zeros(1,Nit); % = 1 when a slice is the same as the previous one (in backward)

%% LEVEL SET SEGMENTATION (CHAN VESE)
% Initializations
ROI{val}.Slices = cell(1,Nit);
ROI{val}.RoiSegmentationPixelIdxList = cell(1,Nit);
ROI{val}.RoiSegmentationPixelIdxForwardList = cell(1,Nit);
ROI{val}.RoiSegmentationPixelIdxBackwardList =  cell(1,Nit);
ROI{val}.MasksSlicesLevelSet = cell(1,Nit);
ROI{val}.MasksSlicesForward = cell(1,Nit);
ROI{val}.MasksSlicesBackward = cell(1,Nit);
ROI{val}.AlternativeSegmentationList = cell(1,Nit);

for it = it_start:Nit
    str_aux = sprintf('MR %s: %d di %d \n',ROI{val}.Name, it, Nit);
    disp(str_aux);
    waitbar(it/Nit, w,str_wbar);

    str = [Info.InputPath, gui_ROI.slash_pc_mac, Info.FileMR(it + ROI{val}.RoiSlice(1)-1).name];
    INFO = dicominfo(str);
    
    % MRI slice
    I0 = double(dicomread(str));
    
    % Save MRI slices
    ROI{val}.Slices{it} = I0;
    
    I = I0(ROI{val}.RoiRegion(it,3):ROI{val}.RoiRegion(it,4),...
        ROI{val}.RoiRegion(it,1):ROI{val}.RoiRegion(it,2));
    
    m = zeros(size(I0));
    m(ROI{val}.RoiPixelIdxList{it}) = 1;
    
    % Mask restricted to the region selected by the user, plus a  
    % 10-pixel-wide band
    mask = m(ROI{val}.RoiRegion(it,3):ROI{val}.RoiRegion(it,4),...
        ROI{val}.RoiRegion(it,1):ROI{val}.RoiRegion(it,2));
    
    if contains(Info.SeriesDescription, 'sag') == 1
        I = double(histeq(uint16(I)));
    end
    
    [seg,iterations.level_set_vertebre{it}] = level_set_segmentation(I,mask,...
        max_its,min_its,alpha);
     
    % Get the segmentation result back to I0 slice dimensions
    mask = zeros(size(I0));
    mask(ROI{val}.RoiRegion(it,3):ROI{val}.RoiRegion(it,4),ROI{val}.RoiRegion(it,1):ROI{val}.RoiRegion(it,2)) = seg;
    
    temp = zeros(size(I0));
    temp(ROI{val}.RoiPixelIdxList{it}) = 1;

    mask = mask.*temp;
   
    % Connected components
    seg_aux = mask;
    CCMask = bwconncomp(seg_aux);
    for it_CCMask = 1 : CCMask.NumObjects
        aux_CC = zeros(size(seg_aux));
        aux_CC(CCMask.PixelIdxList{it_CCMask}) = 1;
        
        % commented
%         if sum(aux_CC(:))<cutoff_pixel 
%             seg_aux(CCMask.PixelIdxList{it_CCMask}) = 0;
%         end
        
    end
    CCMask = bwconncomp(seg_aux);
    
    if CCMask.NumObjects>1
        
        idx = 1;
        for it_CCMask = 2 : CCMask.NumObjects
            if (size(CCMask.PixelIdxList{it_CCMask},1) > size(CCMask.PixelIdxList{it_CCMask-1},1))...
                    && (size(CCMask.PixelIdxList{it_CCMask},1)>size(CCMask.PixelIdxList{idx},1))
                idx = it_CCMask;
            end
        end
        for it_CCMask = 1 : CCMask.NumObjects
            if it_CCMask~=idx
                seg_aux(CCMask.PixelIdxList{it_CCMask}) = 0;
            end
        end
        
    end

    seg = seg_aux;

    mask = seg;
    
    % Save computed masks
    ROI{val}.RoiSegmentationPixelIdxList{it} = find(mask);

end

% Check that the segmentation did not produce empty cells. If it did, fill
% the empty cell with the segmentation in the next cell (previous in the 
% case of last slice).
indici = find(cellfun(@isempty,ROI{val}.RoiSegmentationPixelIdxList));
for i = 1:length(indici)
    indice = indici(i);
    if indice == Nit
        ROI{val}.RoiSegmentationPixelIdxList{indice} =...
            ROI{val}.RoiSegmentationPixelIdxList{indice - 1};
    else
        ROI{val}.RoiSegmentationPixelIdxList{indice} =...
            ROI{val}.RoiSegmentationPixelIdxList{indice + 1};
    end
end
    
for it = it_start:Nit  
    % save post processing in forward and backward  
    ROI{val}.RoiSegmentationPixelIdxForwardList{it} = ROI{val}.RoiSegmentationPixelIdxList{it};
    ROI{val}.RoiSegmentationPixelIdxBackwardList{it} = ROI{val}.RoiSegmentationPixelIdxList{it};
end    

%% POST-PROCESSING - FORWARD

for it=1:Nit

    if (count<max_same_slices...
        && it>=2 ...
        && (length(ROI{val}.RoiSegmentationPixelIdxForwardList{it}) < 0.5*length(ROI{val}.RoiPixelIdxList{it}))...
        && (length(ROI{val}.RoiSegmentationPixelIdxForwardList{it}) < 0.5*length(ROI{val}.RoiSegmentationPixelIdxForwardList{it-1})))...
        || (count<max_same_slices && it>=2 ...
        && (length(ROI{val}.RoiSegmentationPixelIdxForwardList{it}) > 1.8*length(ROI{val}.RoiSegmentationPixelIdxForwardList{it-1})))

        % save which slices have been substituted with forward segmentation  
        aux_forward(1,it) = 1;

        count = count + 1;

        ROI{val}.RoiSegmentationPixelIdxForwardList{it} = ROI{val}.RoiSegmentationPixelIdxForwardList{it-1};

    else
        count = 0;
    end
     
end


%% POST-PROCESSING - BACKWARD
count = 0;

for it = Nit:-1:it_start    
    
    if (count<max_same_slices...
        && it<Nit...
        && (length(ROI{val}.RoiSegmentationPixelIdxBackwardList{it}) < 0.5*length(ROI{val}.RoiPixelIdxList{it}))...
        && (length(ROI{val}.RoiSegmentationPixelIdxBackwardList{it}) < 0.5*length(ROI{val}.RoiSegmentationPixelIdxBackwardList{it+1})))...
        || (count<max_same_slices && it<Nit...
        && (length(ROI{val}.RoiSegmentationPixelIdxBackwardList{it}) > 1.8*length(ROI{val}.RoiSegmentationPixelIdxBackwardList{it+1})))

        % save which slices have been substituted with backward segmentation 
        aux_backward(1,it) = 2;
        
        count = count + 1;

        ROI{val}.RoiSegmentationPixelIdxBackwardList{it} = ROI{val}.RoiSegmentationPixelIdxBackwardList{it+1};

    else
        count = 0;
    end
    
end

% 3D reconstruction forward and backward  
dim_I0 = size(I0);
slices_forward = zeros(dim_I0(1), dim_I0(2), Nit);
slices_backward = zeros(dim_I0(1), dim_I0(2), Nit);
level_set_3d = zeros(dim_I0(1), dim_I0(2), Nit);

for it = it_start:Nit
    
    % Level Set Segmentation - save the masks from Level Set segmentation
    slice_ls = zeros(dim_I0(1), dim_I0(2));
    slice_ls(ROI{val}.RoiSegmentationPixelIdxList{it}) = 1;
    level_set_3d(:,:,it) = slice_ls;
    
    % Forward
    slice_fwd = zeros(dim_I0(1), dim_I0(2));
    slice_fwd(ROI{val}.RoiSegmentationPixelIdxForwardList{it}) = 1;
    slices_forward(:,:,it) = slice_fwd;
    
    % Backward
    slice_bwd = zeros(dim_I0(1), dim_I0(2));
    slice_bwd(ROI{val}.RoiSegmentationPixelIdxBackwardList{it}) = 1;
    slices_backward(:,:,it) = slice_bwd;
    
    % save masks
    ROI{val}.MasksSlicesLevelSet{it} = slice_ls;
    ROI{val}.MasksSlicesForward{it} = slice_fwd;
    ROI{val}.MasksSlicesBackward{it} = slice_bwd;
end

% figure; blockPlot(level_set_3d)%[0,0,0],%'color','r','facealpha',.5,'edgecolor','none')
% figure; blockPlot(slices_forward)
% figure; blockPlot(slices_backward)


% Coefficients that estimate the difference between forward and backward
IoU = zeros(1,Nit);
Dcoeff = zeros(1,Nit);

% jaccard and dice indeces to check the overlapping in consecutive slices 
% IoU_intersection_forward = zeros(1,Nit);
% Dcoeff_intersection_forward = zeros(1,Nit);
% 
% IoU_intersection_backward = zeros(1,Nit);
% Dcoeff_intersection_backward= zeros(1,Nit);
% 
% IoU_union_forward = zeros(1,Nit);
% Dcoeff_union_forward = zeros(1,Nit);
% 
% IoU_union_backward = zeros(1,Nit);
% Dcoeff_union_backward= zeros(1,Nit);

diff_rel_aree_forward = zeros(1,Nit);
diff_rel_aree_backward = zeros(1,Nit);
intersection = zeros(dim_I0(1), dim_I0(2), Nit);
union = zeros(dim_I0(1), dim_I0(2), Nit);

% Vector that stores where the problems are in the slices different between
% backward and forward
aux_IoU = zeros(1,Nit); % = 1 when IoU is different from 1


for it = it_start:Nit
    IoU(1,it) = jaccard(slices_forward(:,:,it), slices_backward(:,:,it));
    Dcoeff(1,it) = dice(slices_forward(:,:,it), slices_backward(:,:,it));
    diff_rel_aree_forward(1,it) = (numel(find(slices_backward(:,:,it)))-numel(find(slices_forward(:,:,it))))/numel(find(slices_forward(:,:,it)));
    diff_rel_aree_backward(1,it) = (numel(find(slices_forward(:,:,it)))-numel(find(slices_backward(:,:,it))))/numel(find(slices_backward(:,:,it)));

    if IoU(1,it) ~= 1
        aux_IoU(1,it) = 1;
    end
    
    slice = zeros(dim_I0(1), dim_I0(2));
    slice(slices_forward(:,:,it) == 1 & slices_backward(:,:,it) == 1) = 1;
    intersection(:,:,it) = slice;
    slice = zeros(dim_I0(1), dim_I0(2));
    slice(slices_forward(:,:,it) == 1 | slices_backward(:,:,it) == 1) = 1;
    union(:,:,it) = slice;
   
%     IoU_intersection_forward(1,it) = jaccard(slices_forward(:,:,it), intersection(:,:,it));
%     IoU_intersection_backward(1,it) = jaccard(intersection(:,:,it), slices_backward(:,:,it));
%     Dcoeff_intersection_forward(1,it) = dice(slices_forward(:,:,it), intersection(:,:,it));
%     Dcoeff_intersection_backward(1,it) = dice(intersection(:,:,it), slices_backward(:,:,it));
%     
%     IoU_union_forward(1,it) = jaccard(slices_forward(:,:,it), union(:,:,it));
%     IoU_union_backward(1,it) = jaccard(union(:,:,it), slices_backward(:,:,it));
%     Dcoeff_union_forward(1,it) = dice(slices_forward(:,:,it), union(:,:,it));
%     Dcoeff_union_backward(1,it) = dice(union(:,:,it), slices_backward(:,:,it));
end

% Problematic slices to show: those which have had a substitution in
% forward or backward
aux_plot = aux_forward + aux_backward;
ROI{val}.AlternativeSegmentationList = aux_plot;

close(w)
end
