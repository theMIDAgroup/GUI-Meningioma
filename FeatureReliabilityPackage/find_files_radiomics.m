%% find_files_radiomics()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% str = '\Users\Utente\Desktop\lavoro\NEW_GUI_Meningioma';
% % folder = 'truth';
% folder = 'auto';
% 
% quantAlgo = 'noQuant';
% 
% % id={'M002';'M003';'M004';'M005';'M006';
% %     'M008';'M009';'M010';'M011';'M012';
% %     'M013';'M014';'M017';
% %     'M018';'M019';'M021';'M022'; %'M020';
% %     'M025';'M026';'M027';
% %     'M028';'M029';'M030';'M031';'M032';
% %     'M033';'M034';'M035';'M037';
% %     'M038';'M039';'M040';
% %     'M043';'M044';'M045';
% %     'M046';'M048';};
% % id = {'M001';'M004';'M009';'M020';};
% id = {'M001';'M020';};

function [files,patients,subj_names] = find_files_radiomics(folder,str,id)

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

%per selezionare solo i merged o i non-merged
% wanted_mask = ~contains(placenames,'merged');
% wanted_mask = contains(placenames,'radiomics');
% patients_in_folder = patients_in_folder(wanted_mask);
% patients = numel(patients_in_folder);

for p = 1 : patients

    subj  = selected_members(p).name;

    % Load Info and ROI for the desired patient
    % Load from T1_MAT Info.mat and ROI.mat
    load([str,'/', subj, '/T1_MAT/Info.mat']);
    load([str,'/', subj, '/T1_MAT/ROI.mat']);

    if isfield(Info,'district_part1')

        val = Info.district_part1;

        if isfield(Info,'district_part3')
            %carico radiomics merged 3
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
