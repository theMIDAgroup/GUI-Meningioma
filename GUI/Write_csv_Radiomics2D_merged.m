%% Write_csv_Radiomics2D_merged()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function writes the csv file containing the 2D radiomics features
% for each slice associated to a ROI.
% -------------------------------------------------------------------------
%%%% called by: radiomics_merged2D()

function Write_csv_Radiomics2D_merged(number_of_slices_ROIonly_field_name,globalTextures_field_name,...
    matrix_based_textures_field_name, nonTexture_field_name, output_file_name)

global ROI;
global Info;
global radiomics2D_merge;

if ~exist(Info.OutputPathRadiomics,'dir'), mkdir(Info.OutputPathRadiomics); end  

rng('default') % for reproducibility
T = table();

val = Info.district_part1;

% Load number of slices after resize and count them
number_of_slices_after_resize = getfield(ROI{val},number_of_slices_ROIonly_field_name); 

% Convert cell to a table and use first row as variable names
aux1 = getfield(radiomics2D_merge{1},globalTextures_field_name);
aux2 = getfield(radiomics2D_merge{1},nonTexture_field_name);
aux3 = getfield(radiomics2D_merge{1},matrix_based_textures_field_name);

tempTable = table();
tempTable.Patient_ID = Info.PatientID;
tempTable.Family_Name = Info.PatientName.FamilyName;
%         tempTable.Given_Name = Info.PatientName.GivenName;
tempTable.Sex = Info.PatientSex;
tempTable.Age = Info.PatientAge;
tempTable.Weight = Info.PatientWeight;
tempTable.ACQ_DATE = Info.AcquisitionDate;
name = ROI{val}.Name;
name = name(find(~isspace(name)));
tempTable.REGION = name;
for slice = 1:number_of_slices_after_resize
    tempTable.Slice = slice;
    %aux1
    tempTable.Variance = aux1(slice).Variance;
    tempTable.Skewness = aux1(slice).Skewness;
    tempTable.Kurtosis = aux1(slice).Kurtosis;
    %aux2
    %         tempTable.Eccentricity = aux2.Eccentricity;
    %         tempTable.Size = aux2.Size;
    %         tempTable.Solidity = aux2.Solidity;
    tempTable.Area = aux2.Area(slice);
    %aux3
    tempTable.Energy = aux3.glcmTextures(slice).Energy;
    tempTable.Contrast = aux3.glcmTextures(slice).Contrast;
    tempTable.Entropy = aux3.glcmTextures(slice).Entropy;
    tempTable.Homogeneity = aux3.glcmTextures(slice).Homogeneity;
    tempTable.Correlation = aux3.glcmTextures(slice).Correlation;
    tempTable.SumAverage = aux3.glcmTextures(slice).SumAverage;
    tempTable.Variance1 = aux3.glcmTextures(slice).Variance;
    tempTable.Dissimilarity = aux3.glcmTextures(slice).Dissimilarity;
    tempTable.AutoCorrelation = aux3.glcmTextures(slice).AutoCorrelation;

    tempTable.Coarseness = aux3.ngtdmTextures(slice).Coarseness;
    tempTable.Contrast1 = aux3.ngtdmTextures(slice).Contrast;
    tempTable.Busyness = aux3.ngtdmTextures(slice).Busyness;
    tempTable.Complexity = aux3.ngtdmTextures(slice).Complexity;
    tempTable.Strength = aux3.ngtdmTextures(slice).Strength;

    tempTable.SRE = aux3.glrlmTextures(slice).SRE;
    tempTable.LRE = aux3.glrlmTextures(slice).LRE;
    tempTable.GLN = aux3.glrlmTextures(slice).GLN;
    tempTable.RLN = aux3.glrlmTextures(slice).RLN;
    tempTable.RP = aux3.glrlmTextures(slice).RP;
    tempTable.LGRE = aux3.glrlmTextures(slice).LGRE;
    tempTable.HGRE = aux3.glrlmTextures(slice).HGRE;
    tempTable.SRLGE = aux3.glrlmTextures(slice).SRLGE;
    tempTable.SRHGE = aux3.glrlmTextures(slice).SRHGE;
    tempTable.LRLGE = aux3.glrlmTextures(slice).LRLGE;
    tempTable.LRHGE = aux3.glrlmTextures(slice).LRHGE;
    tempTable.GLV = aux3.glrlmTextures(slice).GLV;
    tempTable.RLV = aux3.glrlmTextures(slice).RLV;

    tempTable.SZE = aux3.glszmTextures(slice).SZE;
    tempTable.LZE = aux3.glszmTextures(slice).LZE;
    tempTable.GLN1 = aux3.glszmTextures(slice).GLN;
    tempTable.ZSN = aux3.glszmTextures(slice).ZSN;
    tempTable.ZP = aux3.glszmTextures(slice).ZP;
    tempTable.LGZE = aux3.glszmTextures(slice).LGZE;
    tempTable.HGZE = aux3.glszmTextures(slice).HGZE;
    tempTable.SZLG = aux3.glszmTextures(slice).SZLGE;
    tempTable.SZHGE = aux3.glszmTextures(slice).SZHGE;
    tempTable.LZLGE = aux3.glszmTextures(slice).LZLGE;
    tempTable.LZHGE = aux3.glszmTextures(slice).LZHGE;
    tempTable.GLV1 = aux3.glszmTextures(slice).GLV;
    tempTable.ZSV = aux3.glszmTextures(slice).ZSV;
    T = [T;tempTable];
end

if exist(output_file_name,'file')  
    delete(output_file_name);
end

writetable(T,output_file_name,'Sheet',1,'Range','A1')  

end


