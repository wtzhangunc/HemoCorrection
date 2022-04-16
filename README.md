# HemoCorrection
# This projected is related to the paper published by STAR Protocols
# Titled "Simultaneous Recording of Neuronal and Vascular Activity Using Fiber-photometry "

# (1) for the GCamP and tdTomato data, download the following files
#   a. SampleDataGCaMPtdTomato.txt, 
#   b. HemoCalcGreen163.m; BlueSignalsCorrectedbyHb.m; GreenSignalsCorrectedbyHb.m
#   c. hemo_correction_script163_Github.R 
#   d. Dual-GCaMP&tdTomato.csv
#   e. parameters_Td163.xlsx; parameters_blue4correction.xlsx; parameters_green4correction.xlsx;
# (2) run following commands in MATLAB to fit for the hemodynamic changes (deltaHbO, deltaHbR, and deltaHbT) 
#       M = dlmread(textfile,'\t',15,2); 
#       M = M';
#       [Output]=HemoCalcGreen163(M);
# (3)  run following commands to get the corrected GCaMP and tdTomato signals    
#       [G_cor,G_uncor_perc]=BlueSignalsCorrectedbyHb(G_uncor,HbO,HbR);
#       [Td_cor,Td_uncor_perc]=GreenSignalsCorrectedbyHb(Td_uncor,HbO,HbR);



   
