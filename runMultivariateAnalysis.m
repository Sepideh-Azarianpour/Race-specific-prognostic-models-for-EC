function runMultivariateAnalysis(data,event,timeEvent)
%RUNMULTIVARIATEANALYSIS Summary of this function goes here
%   Detailed explanation goes here

n=size(data,2);


[~,~,~,stats] = coxphfit(data,timeEvent,'censoring',~event);



for i=1:n

fprintf('p=%.50f,HR ratio(95CI)=%.2f(%.2f-%.2f)\n', stats.p(i),...
        exp(stats.beta(i)),exp(stats.beta(i)-1.96*stats.se(i)),...
        exp(stats.beta(i)+1.96*stats.se(i)));

end

end

