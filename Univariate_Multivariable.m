clc
clear
close all
DATA=xlsread('../../data.xlsx');


data=DATA(:,3:end);%%don't include cohort as a variables
event=DATA(c:ohort,1);
timeEvent=DATA(:,2);

runMultivariateAnalysis(data,event,timeEvent)
