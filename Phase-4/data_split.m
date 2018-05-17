datafiles=dir('NewFeatureMatrix');
%Directories to be created for storage of plots
mkdir 'TrainData';
mkdir 'TestData';
regex_list = {'ABOUT', 'AND', 'CAN', 'COP', 'DEAF', 'DECIDE', 'FATHER', 'FIND', 'GO OUT', 'HEARING'};

%Iterate through each class and generate plots for FFT,Mean and Range
for class=1:size(regex_list,2)
    pure_count_train=0;
    impure_count_train=0;
    pure_count_test=0;
    impure_count_test=0;
    train_data = [];
    test_data = [];
    for file=1:size(datafiles,1) %find the index of datafile for each class
        if contains(datafiles(file).name,regex_list{class})
            index=file;
        end
    end
    content=xlsread(strcat('NewFeatureMatrix/',datafiles(index).name));
    for row = 1:5:1000
        data_row = cat(2, content(row,1:6), content(row+1,1:6));
        data_row = cat(2, data_row, content(row+2,1:6));
        data_row = cat(2, data_row, content(row+3,1:6));
        data_row = cat(2, data_row, content(row+4,1:6));
        train_data = [train_data; data_row];
        pure_count_train=pure_count_train+1;
    end
    for row = 1001:5:1500
        data_row = cat(2, content(row,1:6), content(row+1,1:6));
        data_row = cat(2, data_row, content(row+2,1:6));
        data_row = cat(2, data_row, content(row+3,1:6));
        data_row = cat(2, data_row, content(row+4,1:6));
        test_data = [test_data; data_row];
        pure_count_test=pure_count_test+1;
    end
    

    classlabel_train = ones(pure_count_train,1);
    classlabel_test = ones(pure_count_test,1);
    
    for noclass = 1:size(regex_list,2)
        if(noclass~=class)
            for file=1:size(datafiles,1) %find the index of datafile for each class
                if contains(datafiles(file).name,regex_list{noclass})
                    index=file;
                end
            end
            content=xlsread(strcat('NewFeatureMatrix/',datafiles(index).name));
            for row = 1:5:110
                data_row = cat(2, content(row,1:6), content(row+1,1:6));
                data_row = cat(2, data_row, content(row+2,1:6));
                data_row = cat(2, data_row, content(row+3,1:6));
                data_row = cat(2, data_row, content(row+4,1:6));
                train_data = [train_data; data_row];
                impure_count_train=impure_count_train+1;
            end
            for row = 1001:5:1055
                data_row = cat(2, content(row,1:6), content(row+1,1:6));
                data_row = cat(2, data_row, content(row+2,1:6));
                data_row = cat(2, data_row, content(row+3,1:6));
                data_row = cat(2, data_row, content(row+4,1:6));
                test_data = [test_data; data_row]; 
                impure_count_test=impure_count_test+1;
            end
        end    
    end
    
    classlabel_train = [classlabel_train; zeros(impure_count_train,1)];
    classlabel_test = [classlabel_test; zeros(impure_count_test,1)];
    
    train_data = [train_data classlabel_train];
    test_data = [test_data classlabel_test];
    
    filename = strcat('TrainData/TrainData_', regex_list{class},'.xlsx');
    xlswrite(filename,train_data(:,:));
    filename = strcat('TestData/TestData_', regex_list{class},'.xlsx');
    xlswrite(filename,test_data(:,:));
end