%% Write_Dicom_brain()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION:
% This function produces and saves a dicom file for each non empty slice
% of the volume mask associated to each ROI (T1). It saves the global
% variable 'ROI' in .mat format.
% -------------------------------------------------------------------------
%%%% called by: Save_Last_Slice()

function Write_Dicom_brain()

global ROI;
global Info;
global gui_ROI;

warning off;

Nval = length(ROI);

for val = 1 : Nval

    if ROI{val}.Enable
        if ROI{val}.OutputDicom
            output_directory = [Info.OutputPathDICOM gui_ROI.slash_pc_mac  'ROI_' regexprep(ROI{val}.Name,'[^\w'']','')];

            if ~exist(output_directory,'dir'), mkdir(output_directory); end
            Nit = length(ROI{val}.RoiSlice);
            for it = 1 : Nit

                str = [Info.InputPath, gui_ROI.slash_pc_mac, Info.FileMR(it+ ROI{val}.RoiSlice(1)-1).name];
                INFO_MR = dicominfo(str);
                I_Mr = double(dicomread(str));

                I_MRcompact = zeros(Info.SizeMR);
                PixelIdxList   =  [];
                PixelIdxList   = ROI{val}.RoiSegmentationPixelIdxList{it};
                I_MRcompact(PixelIdxList)= I_Mr(PixelIdxList);
                I_MRcompact = uint16(I_MRcompact);
                str_save = [output_directory gui_ROI.slash_pc_mac , Info.FileMR(it+ ROI{val}.RoiSlice(1)-1).name];
                dicomwrite(I_MRcompact,str_save,INFO_MR,'CreateMode','copy');
            end
            ROI{val}.DicomWrittenMR = true;
        end
    end

end

warning on;

save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');

end