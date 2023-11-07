# Race-specific-prognostic-models-for-EC
Computational Image and Molecular Analysis Reveals Unique Prognostic Features of Immune Architecture in African Versus European American Women with Endometrial Cancer


# Abstract

Endometrial cancer (EC) disproportionately affects African American (AA) women in terms of progression and death. Existing risk prediction models do not account for population-based variations or differences. In our study, we sought to employ computerized image and bioinformatic analysis to tease out morphologic and molecular differences in EC between AA and European-American (EA) populations. Specifically, we focused on extracting quantitative immune cell architecture features from the tumor epithelial nests and surrounding stroma from EC images and trained population-specific and population-agnostic classifiers for survival prediction pre-chemo/radiation. We interrogated the association of morphological differences in immune cell spatial patterns between AA and EA populations with markers of tumor biology, including histologic and molecular subtypes. The models performed best when they were trained and validated using data from the same population (MAA and MEA). The population-specific risk prediction models were also notable in the types of features that were included as prognostic: only stromal features contributed to MAA, whereas both stromal and epithelial features contributed to the MEA and MPA models. Unsupervised clustering revealed a distinct association between immune cell features and known molecular subtypes of endometrial cancer (such as high chromosomal copy number alterations, low copy number alterations, microsatellite instability, and mutations in POLE) that varied between AA and EA populations. Our genomic analysis revealed two distinct and novel gene sets, with their mutations being associated with improved prognosis in AA and EA patients. Our study findings suggest the need for population-specific risk prediction models for women with endometrial cancer.


The main steps involved in the race-specific prognostic models for EC are as follows:

* Preprocessing steps (Extracting tiles from H&E-stained Whole Slide Images, Epithelium/Stroma segmentation, Nuclei segmentation)
* Tissue Phenotyping
* Capturing quantitative immune profiles 
* Model Construction 
* Evaluating population-specific versus population-agnostic prognostic models in AA and EA women
* Molecular subtypes
* Consensus clustering
* Univariate and multivariable models controlling the clinicopathological factors
* Genomic and Bioinformatics Analysis

To start running the workflow, follow the instructions.
 

# Tissue Phenotyping
	## Extracting tiles from H&E-stained Whole Slide Images:

This process involves extracting tiles from the whole slide image, each of size 3000x3000 pixels. To execute this task, please run the 'extract_tiles.py' file. Make sure to specify the 'input_path' to indicate the location where your whole slide images are stored and the 'output_path' where you want the extracted tiles to be saved.

![S06-1150-B2_24000_84000_0](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/a8a1fa4a-51f6-4f49-a202-f77ad5bca062)
<img width="359" alt="S06-1150-B2_24000_84000_0" src="https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/a8a1fa4a-51f6-4f49-a202-f77ad5bca062">

## HistoQC:
 This is an open-source quality control tool designed to identify unsuitable-quality tiles in digital pathology slides. It helps detect issues such as blurriness, cracked tissue portions, and artifacts from the scanning process [https://github.com/choosehappy/HistoQC].
![HistoQC_PAIR](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/5890e997-8ffb-425f-bc76-9e7cf4e20f26)


 ## Segmenting Tissue within a Tile into Epithelial and Stromal Compartments:
Execute the U-Net model by running the 'epithelium_stroma_segmentation.py' file on the previously extracted tiles. Ensure that the model weights file is accessible at 'code/preprocessing/epi_seg_unet.pth' and specify the 'input_path' and the 'output_path' parameter to indicate the location where the extracted tiles are stored and where you want to save the generated epithelium/stroma segmentation masks.


![Epi_stroma](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/754947e9-04ad-4d76-86f6-f7e79c8a1288)


## 	Nuclei Segmentation:
For nuclei segmentation and classification, we employed the HoverNet model, a state-of-the-art algorithm. The specific model checkpoint used is the PanNuke checkpoint, which contains the necessary model weights and configurations. You can access the HoverNet model and its PanNuke checkpoint on the following GitHub repository: [https://github.com/vqdang/hover_net].

![Nuc_mask](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/8dc788ff-28e0-43fb-af0e-cf489776a96a)


 ## Identifying tumor-infiltrating lymphocyte (TIL):
After segmentation, an SVM image-driven model was applied for TIL detection. Nuclei features, including shape, color, and texture, were used to classify each segmented nucleus as TIL or non-TIL. The model located at ‘SVM_TIL_Detection_Model\ lymp_svm_matlab_wsi.mat’

![TILdetection](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/79f3aa55-c2a3-4533-886b-6da86591eac6)




# Capturing quantitative immune profiles 

In this step, we utilize the coordinates of four distinct cell families, namely stromal non-TILs (dark blue), stromal TILs (cyan), epithelial non-TILs (orange), and epithelial TILs (green), to extract spatial graph features.


*	Cell Cluster Subgraphs: The code constructs subgraphs of neighboring cells based on specific cell coordinates. Each cell subgraph effectively represents interactions among the contributing cells.
*	Threshold Distance: The threshold distance plays a pivotal role and is meticulously chosen to align with the optimal distance required to create an immune cell death domain, thereby inducing immunologic memory and triggering death domains. In this context, a proximity criterion of 80 pixels is employed, which is equivalent to 20 microns at 40X magnification. 
*	Edge Creation: Edges are established between vertices (nuclei centroids) if their separation is less than the defined threshold of 80 pixels. If the distance between two nuclei centroids exceeds this threshold, no connections are established between them.
*	Spatial Distribution: For each cell family, cell subgraphs are distributed across an image tile. Proximal nuclei form colonies within these subgraphs, while distal nuclei remain isolated.

To do this, please execute "Per_tile_quantitative_immune_profiles.m" As a result, a total of 350 quantitative features for each tile will be generated. The comprehensive list of these features can be accessed in "GraphFeatureDescription.mat". 



![Graphs](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/5ecbb997-1e29-4fe1-b91e-10a60f50f6fb)



Per-tile features will be employed to calculate per-patient features using six statistics (mean, median, minimum, maximum, range, and variance) on all stromal and epithelial tiles represented for a patient, yielding 4200 features per patient

# Model Construction 
The least shrinkage and selection operator (LASSO) in conjunction with the Cox proportional hazards regression model, was employed to establish prognostic models for progression-free survival (PFS) in the context of MAA, MEA, and MPA. These models, trained on T0_AA, T0_EA, and T0, yield risk scores comprising a sparse set of features, each assigned a weight (beta). The risk score thus is the linear combination of these feature values.


To distinguish cases into high- vs low-risk patients, three threshold values, namely thres_AAM, thres_EAM, and thres_PAM (-2.36, -0.64, and -0.39, respectively) were obtained to define these risk categories. 

The associated features contributing to each model are outlined in the table below, where stromal features are denoted in pink, and epithelial features in purple rows. A hazard ratio greater than 1 (beta greater than 0) indicates that the feature is elevated in the high-risk category (red), while a hazard ratio less than 1 (beta less than 0) implies the opposite (blue).

<img width="859" alt="Tab2" src="https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/a052a44c-cf6c-4930-9db6-ef5bbff15ccc">


# Evaluating population-specific versus population-agnostic prognostic models in AA and EA women
MAA and MEA models were developed using T0AA and T0EA, respectively, while the MPA model utilized the entirety of T0 data to predict progression-free survival (PFS). Subsequently, these models—MAA, MEA, and MPA—were assessed on T1, T1AA, T1EA, T2, T2AA, and T2EA datasets, resulting in 18 evaluations. Kaplan-Meier analysis was conducted for each evaluation, stratifying risk groups based on the respective model. The analysis included p-values, hazard ratios (HR), 95% confidence intervals (CI), and c-index values. The MATLAB code 'Disparity_immune_risk_KM' automates these analyses for MAA, MEA, and MPA across different cohorts, including racial subsets, generating Kaplan-Meier curves for high- and low-risk groups and drawing KM graphs with stratification tables.
![KM_TCGA](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/dbe3832a-f013-41d6-b06e-33478bd97151)
![KM_UH](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/7d2f986e-68ac-4397-9e8f-220129fb469c)



# Molecular subtypes
To observe how genomic subtypes (CNH, CNL, MSI, and POLE) affect progression in endometrial cancer and their respective Kaplan-Meier survival curves, you can execute 'Disparity_KM_forGenomic_subtypes_TCGA' and 'Disparity_KM_forGenomic_subtypes_TCGA'.

These codes will provide you with the Kaplan-Meier survival curves that illustrate the influence of CNH, CNL, MSI, and POLE genomic subtypes on PFS. there should be seen a trend of improving outcomes from CNH to POLE.

# Consensus clustering
To explore potential associations between endometrial cancer (EC) genomic subtypes and the list of contributing morphological features to MPA using an unsupervised clustering technique, follow these steps:

Run the 'Consensus_Clustering/main.R' script: Please modify the 'cluster_labels' and 'cluster_values' variables in lines 707 and 721 to suit your analysis. These variables define the cluster labels and values for your specific experiment.
If you are interested in a subset of AA or EA data. load the appropriate subset of data before conducting the analysis.
After completing the clustering analysis, you will have a clusterogram and unsupervised clustering results.

Next, you can use a Python code to measure the precision and recall of these identified clusters with the pre-existing molecular subtypes. Use the 'Create_Bar_TCGA.py' and 'Create_Bar_UH' scripts for this purpose. Adjust the appropriate variable names in the following lines as needed: 138, 151, 102-104. 

As a result of running these Python scripts, you will generate the following output files:
*	A cropped version of the consensus clusterogram.
*	A bar plot displaying the true labels.
*	An xlsx report file containing the evaluation results, (precision and recall and a few other metrics).



![Consensus](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/da142719-f338-4d39-82f4-79a604811085)


#  Univariate and multivariable models controlling the clinicopathological factors
The 'Univariate_Multivariable.m' script performs univariate and multivariable Cox regression analyses to assess whether the prognostic value of MAA and MEA risk scores remains significant when considering clinicopathological variables, confounding factors (e.g., age, grade, stage, histotypes, genomic subtypes, and imaging risk scores), requiring a significance level of p < 0.05.


#  Genomic and Bioinformatics Analysis

 
