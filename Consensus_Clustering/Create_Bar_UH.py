# -*- coding: utf-8 -*-
"""
Created on Wed Aug  3 09:42:38 2022

@author: Sepideh Azarianpour
"""




import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import numpy as np
from scipy.stats import mode
from PIL import Image

pd.set_option('display.max_columns', 10000) 
pd.set_option('expand_frame_repr', False)

def apply_label(k):
    if k==1:
        out = 'CNH'
    elif k==2:
        out = 'CNL'
    elif k==3:
        out = 'MSI'
    # elif k==4:
    #     out = 'POLE'
    return out


df = pd.read_csv(r'D:\ep_cc\Rcodes\output_values.txt',header=None,sep='\t')
gf = [129,124,103,57]
clusters = np.array(df.iloc[:,0].unique())
bf = df.groupby(1,sort=False).count()
cf = df.groupby(0,sort=False).count()
clusters_number = list(cf[1])    # number of samples per cluster

TP = []
FP = []
FN = []
TN = []
ACC = []
Recall = []
Precision = []
ClassNumber = []
ClassName = []
PredClassCount = []
RealClassCount = []
for i in clusters:
# for i in range(1,5):
    p = i
    a = df.loc[df.iloc[:,0] == p]
    b = mode(a.iloc[:,1])
    tp = b[1][0]
    fp = len(a) - tp
    gt = b[0][0]
    
    c = df.loc[df.iloc[:,1] == gt]
    fn = len(c) - tp
    tn = len(df) - len(a) - len(c) + tp
    acc = (tp+tn)/(tp+tn+fp+fn)
    recall = tp/(tp+fn)
    precision = tp/(tp+fp)
    TP.append(tp)
    FP.append(fp)
    FN.append(fn)
    TN.append(tn)
    ACC.append(acc)
    Recall.append(recall)
    Precision.append(precision)
    ClassNumber.append(p)
    ClassName.append(apply_label(gt))
    PredClassCount.append(len(a))
    RealClassCount.append(len(c))


report = pd.DataFrame(np.array([ClassNumber,ClassName,PredClassCount,RealClassCount,TP,FP,TN,FN,np.round(ACC,2),np.round(Recall,2),np.round(Precision,2)]).T,
                      columns=['ClassNumber','ClassName','PredClassCount','RealClassCount','TP','FP','TN','FN','ACC','Recall','Precision'])


print(report)
# report.to_excel(r'D:\ep_cc\Rcodes\results\All\report.xlsx', index = None, header=True)
# report.to_excel(r'D:\ep_cc\Rcodes\results\AA\report.xlsx', index = None, header=True)
report.to_excel(r'D:\ep_cc\Rcodes\results\CA\report.xlsx', index = None, header=True)


data = df[[1]]


ClassNumber.reverse()

sorterIndex = dict(zip(ClassNumber, range(1,len(ClassNumber)+1)))

data['Tm_Rank'] =  data[1].map(sorterIndex)

final = data[['Tm_Rank']]
reversed_final = final.iloc[::-1]


# colors = ["red","green","blueviolet","dodgerblue"] ##ALL
# colors = ["blueviolet","red","dodgerblue","green"]  ##AA
# colors = ["green","blueviolet","dodgerblue","red"]  ##CA



cbar_kws = {"shrink":1, 'ticks': [1, 2, 3, 4]}
grid_kws = {"width_ratios": (0.02, .05),'wspace':2}
# f, (ax, cbar_ax) = plt.subplots(1,2,gridspec_kw=grid_kws,figsize=(1,5))
# # ax = sns.heatmap(reversed_final, ax=ax, 
# #                   xticklabels=False, yticklabels=False,
# #                   cmap=colors)

# ax = sns.heatmap(reversed_final, ax=ax,xticklabels=False, yticklabels=False,cmap=colors, linewidths=0,vmin=0.5, vmax=4.5,
#                   cbar_ax=cbar_ax,
#                   cbar_kws=cbar_kws)

# cbar_ax.set_yticklabels(ClassName) 

# # ClassName.reverse()


fig = plt.figure(figsize=(1,5))
sns.heatmap(reversed_final,xticklabels=False, yticklabels=False,cmap=colors, linewidths=0,vmin=0.5, vmax=4.5,cbar=False)
# plt.savefig(r"D:\ep_cc\Rcodes\results\All\2.png", bbox_inches = 'tight', pad_inches = 0)
# plt.savefig(r"D:\ep_cc\Rcodes\results\AA\2.png", bbox_inches = 'tight', pad_inches = 0)
plt.savefig(r"D:\ep_cc\Rcodes\results\CA\2.png", bbox_inches = 'tight', pad_inches = 0)
# 

# ######## cropping
file = r'D:\ep_cc\Rcodes\saved_folder\consensus003.png'
im = Image.open(file)
im1 = im.crop((64, 0, 373, 431)) 
# im1.save(r"D:\ep_cc\Rcodes\results\All\3.png")
# im1.save(r"D:\ep_cc\Rcodes\results\AA\3.png")
im1.save(r"D:\ep_cc\Rcodes\results\CA\3.png")





