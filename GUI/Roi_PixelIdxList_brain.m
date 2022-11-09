%% Roi_PixelIdxList_brain()
% LISCOMP Lab 2021 - 2022 https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function sets in the struct ROI the pixels associated to the 'val' 
% ROI.
% -------------------------------------------------------------------------
%%%% called by: Save_All()
%%%% call: Roi_Fill_PixelIdxList()

function Roi_PixelIdxList_brain()
global ROI;
global Info;

[xgrid,ygrid] = meshgrid(1:1:Info.NumCol,1:1:Info.NumRow);
Nval = length(ROI);
for val  =  1 : Nval
    if ~ROI{val}.RoiEmpty
        Nit = length(ROI{val}.RoiSlice);
        
        ROI{val}.RoiPixelIdxList = cell(1,Nit);
        
        for it  =  1 : Nit
            RoiKind = ROI{val}.RoiKind{it};
            RoiPosition = ROI{val}.RoiPosition{it};
            temp = Roi_Fill_PixelIdxList(RoiKind,RoiPosition,xgrid,ygrid);
            
            tempRemove = [];
            
            ROI{val}.RoiPixelIdxList{it} = setdiff(temp,tempRemove);
        end
    end
end
end
