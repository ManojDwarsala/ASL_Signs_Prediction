traindatafiles=dir('TrainData');
testdatafiles=dir('TestData');
regex_list = {'ABOUT', 'AND', 'CAN', 'COP', 'DEAF', 'DECIDE', 'FATHER', 'FIND', 'GO OUT', 'HEARING'};
%Iterate through each class
for class=1:size(regex_list,2)

    for file=1:size(traindatafiles,1) %find the index of datafile for each class
        if contains(traindatafiles(file).name,regex_list{class})
            index=file;
        end
    end
    train_data = xlsread(strcat('TrainData/',traindatafiles(index).name));
    test_data = xlsread(strcat('TestData/',testdatafiles(index).name));

    %Creating model for decision tree based on the training data
    DTreeModel = fitctree(train_data(:,1:30),train_data(:,31));

    %Predicting the output based on test data
    [resultDtree,scoreDtree]=predict(DTreeModel,test_data(:,1:30));

    %Computing the confusion matrix
    [conf,order]=confusionmat(test_data(:,31),resultDtree);

    %calculate accuracy metrics and reports
    [X,Y,T,ROC] = perfcurve(test_data(:,31),resultDtree,1);
    prec = conf(1,1)/(conf(1,1)+conf(2,1));
    recall = conf(1,1)/(conf(1,1)+conf(1,2));
    fscore = harmmean([prec,recall]);
    fprintf('Gesture:%s, Precision: %d, Recall: %d, FScore: %d\n',regex_list{class},prec,recall,fscore);
end



