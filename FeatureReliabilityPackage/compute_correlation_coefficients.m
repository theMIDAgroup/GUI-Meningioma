function T_metrics = compute_correlation_coefficients(T_all_patients,M_quality,M,M_robustness,M_instability)
index = zeros(1,44);
index_robustness = zeros(1,44);
index_instability = zeros(1,44);
index_quality = zeros(1,44);

XTickLabel = [];
neglected_slices = zeros(44, 1);
xedges = [0:0.1:1];
yedges = [0:0.1:1];

for j = 1:44

    % VC, IC: DA INSERIRE CONTROLLO SU RELATIVE ERROR PER CALCOLARE IL NUOVO
    % INDICE, per ogni feature, selezionare fette con rel error <=1
    ind = find(T_all_patients{:,j+3}<=1); 
%     disp('neglected slices with relative error > 1')
    neglected_slices(j)=size(T_all_patients{:,j+3},1)-size(ind,1);
%     disp(size(T_all_patients{:,j+3})-size(ind))
    feature_values = T_all_patients{ind,j+3};

    % compute histogram
    %figure
    h = histogram2(T_all_patients{ind,1},feature_values,xedges,yedges,'FaceColor','flat');%,'Normalization','probability');
    ztix = get(gca, 'ZTick');
    %set(gca, 'ZTick',ztix, 'ZTickLabel',ztix*100)
    title(T_all_patients.Properties.VariableNames{j+3},'FontSize',25)
    xlabel('Dice coefficient'); ylabel('Relative error on feature'), zlabel('Percentage of slices')
    counts = rot90(h.Values);   % rotate the matrix 90 degrees 
    % (per far venire la matrice dei valori dell'istogramma moltiplicabile nel verso giusto)
    
    % compute indeX
    % /sum(T_all_patients{:,1}) LA SOMMA è FATTA SU TUTTE LE FETTE
    %counts_vector = counts(:)/sum(counts(:));  % VC, IC: trasformare in percentuale/frazione?  
    counts_vector = counts(:)./sum(counts(:));%length(T_all_patients{:,1}); %IC
    counts_perc = counts./sum(counts(:))*100;%length(T_all_patients{:,1})*100; %IC
    counts_da_controllare(j) = counts(10,10);

    % LA SOMMA è FATTA SULLE FETTE CON ERRORE RELATIVO <=1
    M_vector_robustness = M_robustness(:);%/sum(M(:));
    index_robustness(j) = counts_vector'*M_vector_robustness;
    
    M_vector = M(:);%/sum(M(:));
    index(j) = counts_vector'*M_vector;

    M_vector_instability = M_instability(:);
    index_instability(j) = counts_vector'*M_vector_instability;
    index_quality(j) = counts_perc(10,10)./100;
    XTickLabel = [XTickLabel convertCharsToStrings(T_all_patients.Properties.VariableNames{j+3})];
end

%APPROSSIMO TUTTO PER DIFETTO, PER FAR VENIRE LA MARGINALE PARI A UN NUMERO
%<=1!!! NEGLI STACKED BAR CHART DEL PAPER
index = floor(index*100)/100;
index_robustness = floor(index_robustness*100)/100;
index_instability = floor(index_instability*100)/100;
index_quality = floor(index_quality*100)/100;

T_consistency = table(index','RowNames',XTickLabel','VariableNames',{'Consistency'});
T_robustness = table(index_robustness','VariableNames',{'Robustness'});
T_instability = table(index_instability','VariableNames',{'Instability'});
T_quality = table(index_quality','VariableNames',{'Quality'});

%TABELLA CON TUTTI GLI INDICI!!!!!
T_metrics = [T_quality,T_consistency,T_robustness,T_instability];
T_metrics.Marginal = T_metrics.Consistency+T_metrics.Robustness+T_metrics.Instability+T_metrics.Quality;

writetable(T_metrics,'table_correlation_coefficients.xlsx','WriteRowNames',true) 
end