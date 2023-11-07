
clc
clear
close all
folder='C:\Users\sxa786\Desktop\New folder';
ECDATA = readtable([folder,'\patient_info.xlsx']);


%% African American model
folder1=[folder, '/km/AAM'];

RiskScore_Code='AA_Binary_risk_score';
CODE='AAT0'; [c11, p11]=DrawKM_for_Disparity_Version5_draw(ECDATA,RiskScore_Code,folder1,CODE);

CODE='AAT1';  [c12 , p12 ]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='EAT1';  [c13,p13]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='T1';    [c14,p14]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='AAT2';  [c15,p15]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='EAT2';  [c16,p16]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='T2';    [c17,p17]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);





%% population-agnostic model
folder1=[folder, '/km/PAM'];
RiskScore_Code='PA_Binary_risk_score';


CODE='T0'; [c21, p21]=DrawKM_for_Disparity_Version5_draw(ECDATA,RiskScore_Code,folder1,CODE);

CODE='AAT1';  [c22,p22]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='EAT1';  [c23,p23]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='T1';    [c24,p24]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='AAT2';  [c25,p25]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='EAT2';  [c26,p26]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='T2';    [c27,p27]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);





%% European (Caucasian) American model
folder1=[folder, '/km/CAM'];
RiskScore_Code='CA_Binary_risk_score';

CODE='EAT0'; [c31, p31]=DrawKM_for_Disparity_Version5_draw(ECDATA,RiskScore_Code,folder1,CODE);

CODE='AAT1';  [c32,p32]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='EAT1';  [c33,p33]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='T1';    [c34,p34]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='AAT2';  [c35,p35]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='EAT2';  [c36,p36]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
CODE='T2';    [c37,p37]=DrawKM(ECDATA,RiskScore_Code,folder1,CODE);
writetable(ECDATA, [folder ,'/patient_info_all.xlsx'])
save('ECDATA.mat','ECDATA')


