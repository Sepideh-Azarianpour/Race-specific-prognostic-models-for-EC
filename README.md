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
•	Extracting tiles from H&E-stained Whole Slide Images: This process involves extracting tiles from the whole slide image, each of size 3000x3000 pixels. To execute this task, please run the 'extract_tiles.py' file. Make sure to specify the 'input_path' to indicate the location where your whole slide images are stored and the 'output_path' where you want the extracted tiles to be saved.
<img src="[https://github.com/favicon.ico](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/a8a1fa4a-51f6-4f49-a202-f77ad5bca062)" width="48">

![S06-1150-B2_24000_84000_0](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/a8a1fa4a-51f6-4f49-a202-f77ad5bca062)






dvghsdv
![S06-1150-B2_24000_84000_1](https://github.com/Sepideh-Azarianpour/Race-specific-prognostic-models-for-EC/assets/87716968/4da7d5a7-5732-4393-b52f-c408a2c8e678)
