%matrices to store the accuracy metrics
PrecisionVals=zeros(10,1);
RecallVals=zeros(10,1);
F1scores=zeros(10,1);
%Different categories of data
classes={'ABOUT', 'AND', 'CAN', 'COP', 'DEAF', 'DECIDE', 'FATHER', 'FIND', 'GO OUT', 'HEARING'};
for i=1:size(classes,2)
    trainingDM=xlsread(strcat('TrainData/TrainData_',classes{i},'.xlsx'));
    trainingData=trainingDM(:,1:size(trainingDM,2)-1);
    trainingLbls=trainingDM(:,size(trainingDM,2));
    %construct SVM model based on training data and its labels
    SVMModel=fitcsvm(trainingData,trainingLbls);
    testDM=xlsread(strcat('TestData/TestData_',classes{i},'.xlsx'));
    testData=testDM(:,1:size(testDM,2)-1);
    testLbls=testDM(:,size(testDM,2));
    %predict the testdata
    [resultLbls,score]=predict(SVMModel,testData);
    %calculate tp,fp,tn
    tp=0;
    fp=0;
    fn=0;
    for j=1:size(resultLbls,1)
        if (resultLbls(j)==1)&& (resultLbls(j)==testLbls(j))
            tp=tp+1;
        end
        if (resultLbls(j)==1) &&(testLbls(j)==0)
            fp=fp+1;
        end
        if (resultLbls(j)==0) &&(testLbls(j)==1)
            fn=fn+1;
        end
    end
    % Calculate precision
    PrecisionVals(i)=tp/(tp+fp);
    % Calculate Recall
    RecallVals(i)=tp/(tp+fn);
    % Calculate f1-score
    F1scores(i)=2*RecallVals(i)*PrecisionVals(i)/(PrecisionVals(i)+RecallVals(i));
end


