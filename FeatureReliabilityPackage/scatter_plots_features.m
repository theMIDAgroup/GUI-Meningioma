%% scatter_plots_features()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------

function scatter_plots_features(T_all_patients)

max_aux = 0;
[sortedDice, sortIndexDice] = sort(T_all_patients{:,1});
sortedDice_90 = find(sortedDice>=0.9);
for j = 1:44
    
    all_patients = T_all_patients{:,j+3};
    all_patients = all_patients';
    
    infinite_values = isinf(all_patients);
    all_patients(infinite_values == 1) = max(all_patients(infinite_values ~= 1))+5;
    
    sortedFeature = all_patients(sortIndexDice);
    
    all_patients_10 = sortedFeature(sortedDice_90);
    all_patients_10_count(j) = length(find(all_patients_10<0.1));
    all_patients_perc(j) = all_patients_10_count(j)/ size(T_all_patients,1)*100;


end


max_aux = max(all_patients_10_count);
%%

fig = figure;
fig.Position = [10 10 1200 550];
t = tiledlayout(4,4, 'Padding', 'compact', 'TileSpacing', 'compact');
b = [0.2,0.2,0.7];
for j = 1:16
    
    all_patients = T_all_patients{:,j+3};
    all_patients = all_patients';
    
    perc_aux = all_patients_10_count(j)/length(all_patients);
    infinite_values = isinf(all_patients);
    all_patients(infinite_values == 1) = max(all_patients(infinite_values ~= 1))+5;
    
    sortedFeature = all_patients(sortIndexDice);
    h(j) = nexttile;
    hold on
    plot(sortedDice,sortedFeature,'.','Color', b)
    caxis([0 1])

    yline(0.1,'r', LineWidth=1)
    yline(0.2,'r',LineWidth=1)
    xline(0.9,'r',LineWidth=1)
    xline(0.8,'r',LineWidth=1)
    title(T_all_patients.Properties.VariableNames{j+3},'FontSize',20,'FontWeight','normal');
    hold off
    axis([0 1 0 1])
    ylabel(t,' ','FontSize',20);
    xlabel(t,' ','FontSize',20);
    xticklabels({' ',' ',' '})
    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',13)

end

%%

fig = figure;
fig.Position = [10 10 1200 550];
t1 = tiledlayout(4,4, 'Padding', 'compact', 'TileSpacing', 'compact');
for j = 17:32
    
    all_patients = T_all_patients{:,j+3};
    all_patients = all_patients';
    
    perc_aux = all_patients_10_count(j)/length(all_patients);

    infinite_values = isinf(all_patients);
    all_patients(infinite_values == 1) = max(all_patients(infinite_values ~= 1))+5;
    
    sortedFeature = all_patients(sortIndexDice);

    h(j) = nexttile;
    hold on
    plot(sortedDice,sortedFeature,'.','Color',b)
    caxis([0 1])
    yline(0.1,'r',LineWidth=1)
    yline(0.2,'r',LineWidth=1)
    xline(0.9,'r',LineWidth=1)
    xline(0.8,'r',LineWidth=1)
    title(T_all_patients.Properties.VariableNames{j+3},'FontSize',20,'FontWeight','normal');
    hold off
    axis([0 1 0 1])
    ylabel(t1,'Relative error in absolute value','FontSize',20);
    xlabel(t1,' ','FontSize',20);
    xticklabels({' ',' ',' '})
    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',13)

end

%%

fig = figure;
fig.Position = [332,212,1200,424]; 
t2 = tiledlayout(3,4, 'Padding', 'compact', 'TileSpacing', 'compact');
for j = 33:44
    
    all_patients = T_all_patients{:,j+3};
    all_patients = all_patients';
    
    perc_aux = all_patients_10_count(j)/length(all_patients);
    infinite_values = isinf(all_patients);
    all_patients(infinite_values == 1) = max(all_patients(infinite_values ~= 1))+5;
    
    sortedFeature = all_patients(sortIndexDice);
    h(j) = nexttile;
    hold on
    plot(sortedDice,sortedFeature,'.','Color',b)
    caxis([0 1])
    yline(0.1,'r',LineWidth=1)
    yline(0.2,'r',LineWidth=1)
    xline(0.9,'r',LineWidth=1)
    xline(0.8,'r',LineWidth=1)
    title(T_all_patients.Properties.VariableNames{j+3},'FontSize',20,'FontWeight','normal');
    hold off
    axis([0 1 0 1])
    ylabel(t2,' ','FontSize',20);
    xlabel(t2,'Dice coefficient','FontSize',20);

    if j<41
        xticklabels({' ',' ',' '})
    end
    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',13)

end
end