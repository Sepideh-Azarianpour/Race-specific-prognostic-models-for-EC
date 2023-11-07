function [c_index,p]= DrawKM(ECDATA,RiskScore_Code,folder1,CODE)
idx = ECDATA.(CODE);
newtbl=ECDATA(idx>0,:);

timeToEvent=round(table2array(newtbl(:,3))); %% under TTE
labels=table2array(newtbl(:,4));   %% under censor

% R=table2array(newtbl(:,R_IDX))>0; %% binary_risk_score

R=newtbl.(RiskScore_Code); %% binary_risk_score
risk_category={};
risk_category (R,1)={'high risk'};
risk_category (~R,1)={'low risk'};
% [p, fh, stats]=MatSurv3(timeToEvent,labels, risk_category,'TimeUnit','days','Ylabel','survival Probability');
[p]=MatSurv3(timeToEvent,labels, risk_category,'TimeUnit','months','Ylabel','Progression-free Probability','DispHR',1,'DispP',1, 'XMinorTick',3,'CensorInRT',1,'NoPlot',0);
set(gcf,'color','w','Position',  [100, 100, 600, 500]); %% gcf:  Get current figure handle
formatSpec = '%s/km_%s.png';
filename = sprintf(formatSpec,folder1,CODE);
saveas(gcf,filename)



g0=find(R==0); %%index  for low-risk patients
g1=find(R==1); %%index  for high-risk patients
concordent=0;
N_cen=0;
for i=1:length(g0)
    for j=1:length(g1)
        Li=labels(g0(i));
        Lj=labels(g1(j));
        Ti=timeToEvent(g0(i));
        Tj=timeToEvent(g1(j));
        if Li==0  && Lj==0
            N_cen=N_cen+1; %% if both cases are censored, then the pair is censored and the comparison is inconclusive
            
        else
            if Li<Lj || (Li==1 && Lj==1 && Ti>Tj)
        concordent=concordent+1;
            end
        end
        
    end
end
c_index=concordent/(length(g0)*length(g1)-N_cen);
    
    
