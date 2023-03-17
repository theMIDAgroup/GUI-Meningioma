%% Write_csv_Radiomics()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function writes the csv file containing the radiomics features
% associated to each ROI.
% -------------------------------------------------------------------------
%%%% called by: radiomics_general()

function Write_csv_Radiomics(globalTextures_field_name,...
    matrix_based_textures_field_name, nonTexture_field_name, output_file_name,enable_field_name)

global ROI;
global Info;
global radiomics;

if ~exist(Info.OutputPathRadiomics,'dir'), mkdir(Info.OutputPathRadiomics); end 

rng('default') % for reproducibility
T = table();

Nval = length(ROI);

for val = 1 : Nval
    enable = getfield(ROI{val},enable_field_name);  

    if enable

        % Convert cell to a table and use first row as variable names
        aux1 = getfield(radiomics{1,val},globalTextures_field_name);
        aux2 = getfield(radiomics{1,val},nonTexture_field_name);
        aux3 = getfield(radiomics{1,val},matrix_based_textures_field_name);
        
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
        %aux1
        tempTable.Variance = aux1.Variance;
        tempTable.Skewness = aux1.Skewness;
        tempTable.Kurtosis = aux1.Kurtosis;
        %aux2
        tempTable.Eccentricity = aux2.Eccentricity;
        tempTable.Size = aux2.Size;
        tempTable.Solidity = aux2.Solidity;
        tempTable.Volume = aux2.Volume;
        %aux3
        tempTable.Energy = aux3.glcmTextures.Energy;
        tempTable.Contrast = aux3.glcmTextures.Contrast;
        tempTable.Entropy = aux3.glcmTextures.Entropy;
        tempTable.Homogeneity = aux3.glcmTextures.Homogeneity;
        tempTable.Correlation = aux3.glcmTextures.Correlation;
        tempTable.SumAverage = aux3.glcmTextures.SumAverage;
        tempTable.Variance1 = aux3.glcmTextures.Variance;
        tempTable.Dissimilarity = aux3.glcmTextures.Dissimilarity;
        tempTable.AutoCorrelation = aux3.glcmTextures.AutoCorrelation;
        
        tempTable.Coarseness = aux3.ngtdmTextures.Coarseness;
        tempTable.Contrast1 = aux3.ngtdmTextures.Contrast;
        tempTable.Busyness = aux3.ngtdmTextures.Busyness;
        tempTable.Complexity = aux3.ngtdmTextures.Complexity;
        tempTable.Strength = aux3.ngtdmTextures.Strength;
        
        tempTable.SRE = aux3.glrlmTextures.SRE;
        tempTable.LRE = aux3.glrlmTextures.LRE;
        tempTable.GLN = aux3.glrlmTextures.GLN;
        tempTable.RLN = aux3.glrlmTextures.RLN;
        tempTable.RP = aux3.glrlmTextures.RP;
        tempTable.LGRE = aux3.glrlmTextures.LGRE;
        tempTable.HGRE = aux3.glrlmTextures.HGRE;
        tempTable.SRLGE = aux3.glrlmTextures.SRLGE;
        tempTable.SRHGE = aux3.glrlmTextures.SRHGE;
        tempTable.LRLGE = aux3.glrlmTextures.LRLGE;
        tempTable.LRHGE = aux3.glrlmTextures.LRHGE;
        tempTable.GLV = aux3.glrlmTextures.GLV;
        tempTable.RLV = aux3.glrlmTextures.RLV;
 
        tempTable.SZE = aux3.glszmTextures.SZE;
        tempTable.LZE = aux3.glszmTextures.LZE;
        tempTable.GLN1 = aux3.glszmTextures.GLN;
        tempTable.ZSN = aux3.glszmTextures.ZSN;
        tempTable.ZP = aux3.glszmTextures.ZP;
        tempTable.LGZE = aux3.glszmTextures.LGZE;
        tempTable.HGZE = aux3.glszmTextures.HGZE;
        tempTable.SZLG = aux3.glszmTextures.SZLGE;
        tempTable.SZHGE = aux3.glszmTextures.SZHGE;
        tempTable.LZLGE = aux3.glszmTextures.LZLGE;
        tempTable.LZHGE = aux3.glszmTextures.LZHGE;
        tempTable.GLV1 = aux3.glszmTextures.GLV;
        tempTable.ZSV = aux3.glszmTextures.ZSV;
        T = [T;tempTable];
    end

end

if exist(output_file_name,'file')  
    delete(output_file_name);
end
writetable(T,output_file_name)

end


