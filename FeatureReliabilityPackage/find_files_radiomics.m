%% find_files_radiomics()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------

function [files,patients,subj_names] = find_files_radiomics(folder,str,id)

% Change names accordingly
if strcmp(folder,'auto')
    str = [str '/Data_auto'];
else
    str = [str '/Data'];
end

% Load relative error file for the desired patient
patients_in_folder = dir(str);
while patients_in_folder(1).name(1) == '.'
    patients_in_folder = patients_in_folder(2:end);
end

placenames = {patients_in_folder.name};

if nargin < 3
    selected_members = patients_in_folder;
else
    wanted_mask = ismember(placenames, id);
    selected_members = patients_in_folder(wanted_mask);
end

patients = numel(selected_members);

for p = 1 : patients

    subj  = selected_members(p).name;

    load([str,'/', subj, '/MAT_FILES/Info.mat']);
    load([str,'/', subj, '/MAT_FILES/ROI.mat']);

    if isfield(Info,'district_part1')

        val = Info.district_part1;

        if isfield(Info,'district_part3')
            radiomics_file2D = [Info.OutputPathRadiomics '/' subj '_radiomics2D_merged3.xlsx'];
        else
            radiomics_file2D = [Info.OutputPathRadiomics '/' subj '_radiomics2D_merged.xlsx'];
        end

    else
        radiomics_file2D = [Info.OutputPathRadiomics '/' subj '_radiomics2D.xlsx'];
    end
    files{p} = radiomics_file2D;
    subj_names{p} = subj;
end

end
