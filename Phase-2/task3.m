% THIS FILE READS THE DATAFILES FROM 'Group2Assignment2' FOLDER, GENERATE
% PLOTS AND STORE THEM IN THE
% 'Group2Assignment2/Plots/<feature-extraction-method>' FOLDER.
% CHECK THE PLOTS FOLDER FOR VIEWING THE PLOTS FOR EACH FEATURE EXTRACTION
% METHOD.

datafiles=dir('Group2Assignment2');
%Directories to be created for storage of plots
mkdir 'Group2Assignment2/Plots/Mean'
mkdir 'Group2ASsignment2/Plots/BeforePCA'
mkdir 'Group2ASsignment2/Plots/AfterPCA'
mkdir 'Group2ASsignment2/Plots/Range'
BeforePCA = 'Group2Assignment2/Plots/BeforePCA';
AfterPCA = 'Group2Assignment2/Plots/AfterPCA';
Meanfolder = 'Group2Assignment2/Plots/Mean';
Rangefolder = 'Group2Assignment2/Plots/Range';
regex_list = {'ABOUT', 'AND', 'CAN', 'COP', 'DEAF', 'DECIDE', 'FATHER', 'FIND', 'GO OUT', 'HEARING'};
%Datastores to store the global values for each class, used for overlapping
globalMinVals=[];
globalMaxVals=[];
globalFFTVals=[];
globalMeanVals=[];
globalRangeVals=[];
feature_matrix = zeros(585,34,10);
pca_output = zeros(585,34,10);
pca_input = [];
global_mean = 0;
global_max = 0;
global_min = 0;
global_rms = 0;
global_pk = 0;
global_std = 0;
a = 1;
%Iterate through each class and generate plots for FFT,Mean and Range
for class=1:size(regex_list,2)
    for file=1:size(datafiles,1) %find the index of datafile for each class
        if contains(datafiles(file).name,regex_list{class})
            index=file;
            a = 0;
        end
    end
    content=xlsread(strcat('Group2Assignment2/',datafiles(index).name));
    tempdata=[];
    T = 3;
    dt = 3/46;
    F = 1/dt;
    L = 46;
    n = 512;
    range_value = 0;
    mean_value = 0;
    %Iterating through all sensors
    for gyro=1:34
        i=1;
        for row=gyro:34:size(content,1)
            tempdata=[tempdata content(row,1:45)];
            fft_value = abs(fft(tempdata, n));
            %stem((0:n-1)*(F/L), fft_value);
            %hold on,
            [pk,MaxFreq] = findpeaks(fft_value,'NPeaks',1,'SortStr','descend');
            pk,
            if isempty(pk)
                pk = 0;
            end
			%Storing features in matrix
            feature_matrix(i,gyro,class) = rms(tempdata);
            feature_matrix(i+1,gyro,class) = max(tempdata)-min(tempdata);
            feature_matrix(i+2,gyro,class) = mean(tempdata);
            feature_matrix(i+3,gyro,class) = std(tempdata);
            feature_matrix(i+4,gyro,class) = pk;
            tempdata = [];
            i=i+5;
        end
    end

	%Plotting feature matrix data
    figure,
    plot(feature_matrix(1:500,:,class));
    hold on,
    title([regex_list(class),'Features before PCA - All Sensors',]);
    xlabel('Features');
    ylabel('Feature Values');
    legend('ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG1L','EMG2L','EMG3L','EMG4L','EMG5L','EMG6L','EMG7L','EMG0R','EMG1R','EMG2R','EMG3R','EMG4R','EMG5R','EMG6R','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORL','OPL','OYL','ORR','OPR','OYR','Location','northeast');
    baseFileName =  sprintf('%s_features.png', string(regex_list(class)));
    fullFileName = fullfile(BeforePCA, baseFileName);
    saveas(gcf,fullFileName);
    
    pca_input = [pca_input; feature_matrix(:,:,class)];
end

%Computing PCA
[coeff, score, latent, tsquared, explained] = pca(pca_input);

%Drawing scatter plot
figure,
scatter3(score(:,1),score(:,2),score(:,3))
hold on,
axis equal
title('Scatter Plot');
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
zlabel('3rd Principal Component')


for class=1:size(regex_list,2)    
    pca_output(:,:,class) = feature_matrix(:,:,class)*coeff;
    
	%Plotting new feature matrix data
    figure,
    plot(pca_output(1:500,:,class));
    hold on,
    title([regex_list(class),'-Features after PCA - All Sensors',]);
    xlabel('Features');
    ylabel('Feature Values');
    legend('ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG1L','EMG2L','EMG3L','EMG4L','EMG5L','EMG6L','EMG7L','EMG0R','EMG1R','EMG2R','EMG3R','EMG4R','EMG5R','EMG6R','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORL','OPL','OYL','ORR','OPR','OYR','Location','northeast'); 
    baseFileName =  sprintf('%s_features.png', string(regex_list(class)));
    fullFileName = fullfile(AfterPCA, baseFileName);
    saveas(gcf,fullFileName);
end