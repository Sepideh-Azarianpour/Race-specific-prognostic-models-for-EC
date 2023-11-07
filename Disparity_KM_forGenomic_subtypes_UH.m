clear, clc, close all
folder='C:\Users\sxa786\Desktop\New folder/';
save_folder=[folder, '/genomic_KM_UH/'];

%%(make sure the excel cells with NA values are specified as empty)
% endpoint = input('Enter number for DSS (1) ,PFS(2), or OS(3): ');
% population_code = input('Enter number for All (1) ,AA(2), or CA(3): ');





for endpoint = 1:2
    for population= 1:3
        
        newtbl=readtable([folder,'KM_Curves_genomic_UH.xlsx']);

        switch population
            case 1
                population_code='All';
            case 2
                population_code='AA';
                newtbl.race = categorical(newtbl.race);
                idx = newtbl.race == 'black or african american';
                newtbl = newtbl(idx,:);
            case 3
                population_code='CA';
                newtbl.race = categorical(newtbl.race);
                idx = newtbl.race == 'white';
                newtbl = newtbl(idx,:);
        end
        switch endpoint
            case 1
                code_word='Progression-free survival probability';
                %%Disease-free Survival [month] (0:ALIVE OR DEAD TUMOR FREE) (1:DEAD WITH TUMOR)
                timeToEvent=( table2array(newtbl(:,3)));
                status=table2array(newtbl(:,4));
            
            case 2
                code_word='Overall survival probability';
                %%overall survival [days], STATUS:Vital status (0:LIVING, 1:DECEASED)
                timeToEvent=( table2array(newtbl(:,5)));
                status=table2array(newtbl(:,6));
        end
        
        
        risk_category=table2array(newtbl(:,7));
        k=4;   %% number of xTicks and table points
        
        interval=30;
        
        [p, fh, stats]=MatSurv3_4level(timeToEvent,status, risk_category,'TimeUnit','months','Ylabel',code_word,...
            'XMinorTick',3,'CensorInRT',1,...
            'TimeMax',120,...
            'legend', 0, ...
            'XTicks',[0:interval:k*interval])
        set(gcf,'color','w','Position',  [100, 100, 980, 700]); %% gcf:  Get current figure handle
        
        saveas(gcf,[save_folder,'/km_',code_word,'_',population_code,'.png'])
    end
end

