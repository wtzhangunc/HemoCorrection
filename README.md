# HemoCorrection

This projected is related to the paper published by STAR Protocols

Titled "Simultaneous Recording of Neuronal and Vascular Activity Using Fiber-photometry "

# (1) for the GCamP and tdTomato data, download the following files

   a. SampleDataGCaMPtdTomato.txt, 
   
   b. HemoCalcGreen163.m; BlueSignalsCorrectedbyHb.m; GreenSignalsCorrectedbyHb.m
   
   c. hemo_correction_script163_Github.R 
   
   d. Dual-GCaMP&tdTomato.csv  (for linear unmixing)
   
   e. parameters_Td163.xlsx; parameters_blue4correction.xlsx; parameters_green4correction.xlsx;
   
# (2) edit HemoCalcGreen163.m to fit your own environment
   a. line 6: make sure commend "Rscript" is somewhere in your computer. "/usr/local/bin" is the default directory when I installed the R package
   
   b. line 7: "hemo_correction_script163_github.R" is the R script that you downloaded from step (1). This line defines where you saved it.
   
   c. Double check if the wavelength range defiend in line 10 was the real range in your specfiic spetrometer. It variies from spectrometer A to B, etc.
   
   d. line 14-19 are for linear unmixing. If you already run it, just comments out these lines and read in your coefficients with first ROW containing 
      coefficients of GCaMP and second ROW containing coefficients of tdTomato.

   
# (3) run following commands in MATLAB to fit for the hemodynamic changes (deltaHbO, deltaHbR, and deltaHbT) 

       tmp = detectImportOptions(TextFile);%TextFile is the raw data file
       NumOfHeaderlines = tmp.DataLines(1,1);
       M = dlmread(TextFile,'\t',NumOfHeaderLines,2);
       M = M';
       [Output]=HemoCalcGreen163(M);
       
# (4)  run following commands to get the corrected GCaMP and tdTomato signals   
     (a) Correct the tdTomato signal first
     
       [Td_cor,Td_uncor_perc]=GreenSignalsCorrectedbyHb(Td_uncor,HbO,HbR);

       Check the Td_cor curve to see if it's flat. 
       If not, you may need to adjust the scaling factor in line 19 and 20 in "GreenSingalsCorrectedbyHb". 
       This factor is used to retore the actual amplitude of HbO and HbR, which became smaller by smoothing effect. 
       Currently the scaling factor is set to 1.2, you may try different factors ranging from 1.2- 1.6. 
       
       Once the scaling factor was decided with tdTomato correction, use the SAME scaling factor for next step in "BlueSignalsCorrectedbyHb"
       
      (b) Correct the GCaMP signal
      
       [G_cor,G_uncor_perc]=BlueSignalsCorrectedbyHb(G_uncor,HbO,HbR);
       
      


   
