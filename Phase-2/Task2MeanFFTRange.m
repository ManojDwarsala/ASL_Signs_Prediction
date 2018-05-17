% THIS FILE READS THE DATAFILES FROM 'Group2Assignment2' FOLDER, GENERATE
% PLOTS AND STORE THEM IN THE
% 'Group2Assignment2/Plots/<feature-extraction-method>' FOLDER.
% CHECK THE PLOTS FOLDER FOR VIEWING THE PLOTS FOR EACH FEATURE EXTRACTION
% METHOD.

datafiles=dir('Group2Assignment2');
%Directories to be created for storage of plots
mkdir 'Group2Assignment2/Plots/Mean'
mkdir 'Group2ASsignment2/Plots/FFT'
mkdir 'Group2ASsignment2/Plots/Range'
FFTfolder = 'Group2Assignment2/Plots/FFT';
Meanfolder = 'Group2Assignment2/Plots/Mean';
Rangefolder = 'Group2Assignment2/Plots/Range';
regex_list = {'About','And', 'Can', 'cop', 'deaf', 'decide', 'father', 'find', 'go out', 'hearing'};
%Datastores to store the global values for each class, used for overlapping
globalMinVals=[];
globalMaxVals=[];
globalFFTVals=[];
globalMeanVals=[];
globalRangeVals=[];
%Iterate through each class and generate plots for FFT,Mean and Range
for class=1:size(regex_list,2)
    for file=1:size(datafiles,1) %find the index of datafile for each class
        if contains(datafiles(file).name,regex_list{class})
            index=file;
        end
    end
    content=xlsread(strcat('Group2Assignment2/',datafiles(index).name));
    localMinVals=[];
    localMaxVals=[];
    localFFTVals=[];
    localMeanVals=[];
    localRangeVals=[];
    FFTVals=[];
    canMean=[];
    deafMean=[];
    RangeVals=[];
    MeanVals=[];
    tempdata=[];
    for gyro=1:6
        for row=gyro:34:size(content,1)
            tempdata=[tempdata content(row,2:size(content,2))];
            FFTVals=[FFTVals (abs(fft(tempdata)))];
            range=max(tempdata)-min(tempdata);
            RangeVals=[RangeVals range];
            MeanVals=[MeanVals nanmean(tempdata)];
            localMinVals=[localMinVals; min(tempdata)];
            localMaxVals=[localMaxVals; max(tempdata)];
            tempdata=[];
            range=0;
        end
        localFFTVals=[localFFTVals; FFTVals];
        localMeanVals=[localMeanVals; MeanVals];
        localRangeVals=[localRangeVals; RangeVals];
        FFTVals=[];
        RangeVals=[];
        MeanVals=[];
    end
    globalMinVals=[globalMinVals; min(localMinVals)];
    globalMaxVals=[globalMaxVals; max(localMaxVals)];
    globalFFTVals=[globalFFTVals localFFTVals];
    globalMeanVals{1,class}=localMeanVals;
    %globalMeanVals=[globalMeanVals localMeanVals];
    globalRangeVals=[globalRangeVals localRangeVals];
    evenlySpacedPoints=linspace(min(localMinVals),max(localMaxVals),size(localFFTVals,2));
    %plotting FFT
    plot(evenlySpacedPoints,localFFTVals');
    title([regex_list(class),'-FFT Plot for Accelerometer Values',]);
    xlabel('Accelerometer Values');
    ylabel('FFT Values');
    legend('ALX','ALY','ALZ','ARX','ARY','ARZ','Location','northeast'); 
    baseFileName =  sprintf('%s_FFT_Accelerometer.png', string(regex_list(class)));
    fullFileName = fullfile(FFTfolder, baseFileName);
    saveas(gcf,fullFileName);
    
    %plotting Mean
    
    evenlySpacedPoints=linspace(min(localMinVals),max(localMaxVals),size(localMeanVals,2));
    plot(evenlySpacedPoints,localMeanVals');
    
    title([regex_list(class),'-Mean Plot for Accelerometer Values',]);
    xlabel('Accelerometer Values');
    ylabel('Mean Values');
    legend('ALX','ALY','ALZ','ARX','ARY','ARZ','Location','northeast'); 
    baseFileName =  sprintf('%s_Mean_Accelerometer.png', string(regex_list(class)));
    fullFileName = fullfile(Meanfolder, baseFileName);
    saveas(gcf,fullFileName);
    
%     %plotting Range
    evenlySpacedPoints=linspace(min(localMinVals),max(localMaxVals),size(localRangeVals,2));
    plot(evenlySpacedPoints,localRangeVals');
    title([regex_list(class),'-Range Plot for Accelerometer Values',]);
    xlabel('Accelerometer Values');
    ylabel('Range Values');
    legend('ALX','ALY','ALZ','ARX','ARY','ARZ','Location','northeast'); 
    baseFileName =  sprintf('%s_Range_Accelerometer.png', string(regex_list(class)));
    fullFileName = fullfile(Rangefolder, baseFileName);
    saveas(gcf,fullFileName);
    end