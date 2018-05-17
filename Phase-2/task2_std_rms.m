% THIS FILE READS THE DATAFILES FROM 'Group2Assignment2' FOLDER, GENERATE
% PLOTS AND STORE THEM IN THE
% 'Group2Assignment2/Plots/<feature-extraction-method>' FOLDER.
% CHECK THE PLOTS FOLDER FOR VIEWING THE PLOTS FOR EACH FEATURE EXTRACTION
% METHOD.
% OVERLAP_FOLDER = CONTAINS PLOTS FOR SIMILAR ACTIONS/CLASSES

datafiles=dir('Group2Assignment2');
%Directories to be created for storage of plots
mkdir 'Group2Assignment2/Plots/STD'
mkdir 'Group2ASsignment2/Plots/RMS'
mkdir 'Group2Assignment2/Plots/STD/Overlap_Plots'
mkdir 'Group2Assignment2/Plots/RMS/Overlap_Plots'
STDfolder = 'Group2Assignment2/Plots/STD';
RMSfolder = 'Group2Assignment2/Plots/RMS';
STDOverlapfolder='Group2Assignment2/Plots/STD/Overlap_Plots';
RMSOverlapfolder='Group2Assignment2/Plots/RMS/Overlap_Plots';
regex_list = {'About','And', 'Can', 'cop', 'deaf', 'decide', 'father', 'find', 'go out', 'hearing'};
%Datastores to store the global values for each class, used for overlapping
globalMinVals=[];
globalMaxVals=[];
globalSTDVals={};
globalRMSVals={};
%Iterate through each class and generate plots for STD and RMS
for class=1:size(regex_list,2)
    for file=1:size(datafiles,1) %find the index of datafile for each class
        if contains(datafiles(file).name,regex_list{class})
            index=file;
        end
    end
    content=xlsread(strcat('Group2Assignment2/',datafiles(index).name));
    localMinVals=[];
    localMaxVals=[];
    localSTDVals=[];
    localRMSVals=[];
    STDVals=[];
    RMSVals=[];
    tempdata=[];
    for gyro=1:6
        for row=gyro:34:size(content,1)
            tempdata=[tempdata content(row,2:size(content,2))];
            STDVals=[STDVals nanstd(tempdata)];
            tempdata(isnan(tempdata)) = [];
            RMSVals=[RMSVals rms(tempdata)];
            
            localMinVals=[localMinVals; min(tempdata)];
            localMaxVals=[localMaxVals; max(tempdata)];
            tempdata=[];
        end
        localSTDVals=[localSTDVals; STDVals];
        localRMSVals=[localRMSVals; RMSVals];
        STDVals=[];
        RMSVals=[];
    end
    globalMinVals=[globalMinVals; min(localMinVals)];
    globalMaxVals=[globalMaxVals; max(localMaxVals)];
    globalSTDVals{1,class}=localSTDVals;
    globalRMSVals{1,class}=localRMSVals;
    evenlySpacedPoints=linspace(min(localMinVals),max(localMaxVals),size(localSTDVals,2));
    %plotting STD
    plot(evenlySpacedPoints,localSTDVals');
    title([regex_list(class),'-STD Plot for Accelerometer Values',]);
    xlabel('Accelerometer Values');
    ylabel('STD Values');
    legend('ALX','ALY','ALZ','ARX','ARY','ARZ','Location','northeast'); 
    baseFileName =  sprintf('%s_STD_Accelerometer.png', string(regex_list(class)));
    fullFileName = fullfile(STDfolder, baseFileName);
    saveas(gcf,fullFileName);
    %plotting RMS
    plot(evenlySpacedPoints,localRMSVals');
    title([regex_list(class),'-RMS Plot for Accelerometer Values',]);
    xlabel('Accelerometer Values');
    ylabel('RMS Values');
    legend('ALX','ALY','ALZ','ARX','ARY','ARZ','Location','northeast'); 
    baseFileName =  sprintf('%s_RMS_Accelerometer.png', string(regex_list(class)));
    fullFileName = fullfile(RMSfolder, baseFileName);
    saveas(gcf,fullFileName);
end
%plotting for similar actions/classes by overlapping STD, RMS Values
overlap_ind={2,9,3,6,5,10,4,7};
for index=1:2:size(overlap_ind,2)
    STDtab=[];STDleft=[];STDright=[];
    RMStab=[];RMSleft=[];RMSright=[];
    minVal= min(globalMinVals(overlap_ind{index}),globalMinVals(overlap_ind{index+1}));
    maxVal= max(globalMaxVals(overlap_ind{index}),globalMaxVals(overlap_ind{index+1}));
    nc1=size(globalSTDVals{1,overlap_ind{index}});
    nc2=size(globalSTDVals{1,overlap_ind{index+1}});
    STDtab(1:6,1:nc1(2))=[globalSTDVals{1,overlap_ind{index}}];
    STDtab(7:12,1:nc2(2))=[globalSTDVals{1,overlap_ind{index+1}}];
    nc1=size(globalRMSVals{1,overlap_ind{index}});
    nc2=size(globalRMSVals{1,overlap_ind{index+1}});
    RMStab(1:6,1:nc1(2))=[globalSTDVals{1,overlap_ind{index}}];
    RMStab(7:12,1:nc2(2))=[globalSTDVals{1,overlap_ind{index+1}}];
    STDleft=[STDtab(1,:);STDtab(2,:);STDtab(3,:);STDtab(7,:);STDtab(8,:);STDtab(9,:)];
    STDright=[STDtab(4,:);STDtab(5,:);STDtab(6,:);STDtab(10,:);STDtab(11,:);STDtab(12,:)];
    RMSleft=[RMStab(1,:);RMStab(2,:);RMStab(3,:);RMStab(7,:);RMStab(8,:);RMStab(9,:)];
    RMSright=[RMStab(4,:);RMStab(5,:);RMStab(6,:);RMStab(10,:);RMStab(11,:);RMStab(12,:)];
    %plot STD left overlap
    evenlySpacedPoints=linspace(minVal,maxVal,size(STDleft,2));
    plot(evenlySpacedPoints,STDleft');
    title([regex_list(overlap_ind{index}),'&',regex_list(overlap_ind{index+1}),'STD-Left Plot for Accelerometer Values',]);
    xlabel('Accelerometer Values');
    ylabel('STD Values');
    legend('ALX-1','ALY-1','ALZ-1','ALX-2','ALY-2','ALZ-2','Location','northeast'); 
    baseFileName =  sprintf('%s_STD_Left_Accelerometer.png', string(strcat(regex_list(overlap_ind{index}),'-',regex_list(overlap_ind{index+1}))));
    fullFileName = fullfile(STDOverlapfolder, baseFileName);
    saveas(gcf,fullFileName);
    %plot STD Right overlap
    evenlySpacedPoints=linspace(minVal,maxVal,size(STDright,2));
    plot(evenlySpacedPoints,STDright');
    title([regex_list(overlap_ind{index}),'&',regex_list(overlap_ind{index+1}),'STD-Right Plot for Accelerometer Values',]);
    xlabel('Accelerometer Values');
    ylabel('STD Values');
    legend('ARX-1','ARY-1','ARZ-1','ARX-2','ARY-2','ARZ-2','Location','northeast'); 
    baseFileName =  sprintf('%s_STD_Right_Accelerometer.png', string(strcat(regex_list(overlap_ind{index}),'-',regex_list(overlap_ind{index+1}))));
    fullFileName = fullfile(STDOverlapfolder, baseFileName);
    saveas(gcf,fullFileName);
    %plot RMS left overlap
    evenlySpacedPoints=linspace(minVal,maxVal,size(RMSleft,2));
    plot(evenlySpacedPoints,RMSleft');
    title([regex_list(overlap_ind{index}),'&',regex_list(overlap_ind{index+1}),'RMS-Left Plot for Accelerometer Values',]);
    xlabel('Accelerometer Values');
    ylabel('RMS Values');
    legend('ALX-1','ALY-1','ALZ-1','ALX-2','ALY-2','ALZ-2','Location','northeast'); 
    baseFileName =  sprintf('%s_RMS_Left_Accelerometer.png', string(strcat(regex_list(overlap_ind{index}),'-',regex_list(overlap_ind{index+1}))));
    fullFileName = fullfile(RMSOverlapfolder, baseFileName);
    saveas(gcf,fullFileName);
    %plot RMS Right overlap
    evenlySpacedPoints=linspace(minVal,maxVal,size(RMSright,2));
    plot(evenlySpacedPoints,RMSright');
    title([regex_list(overlap_ind{index}),'&',regex_list(overlap_ind{index+1}),'RMS-Right Plot for Accelerometer Values',]);
    xlabel('Accelerometer Values');
    ylabel('RMS Values');
    legend('ARX-1','ARY-1','ARZ-1','ARX-2','ARY-2','ARZ-2','Location','northeast'); 
    baseFileName =  sprintf('%s_RMS_Right_Accelerometer.png', string(strcat(regex_list(overlap_ind{index}),'-',regex_list(overlap_ind{index+1}))));
    fullFileName = fullfile(RMSOverlapfolder, baseFileName);
    saveas(gcf,fullFileName);
end


