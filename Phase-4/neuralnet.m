traindatafiles=dir('TrainData');
testdatafiles=dir('TestData');
%Directories to be created for storage of plots
regex_list = {'ABOUT', 'AND', 'CAN', 'COP', 'DEAF', 'DECIDE', 'FATHER', 'FIND', 'GO OUT', 'HEARING'};
%Iterate through each class and generate plots for FFT,Mean and Range
for class=1:size(regex_list,2)

    for file=1:size(traindatafiles,1) %find the index of datafile for each class
        if contains(traindatafiles(file).name,regex_list{class})
            index=file;
        end
    end
    train_data = xlsread(strcat('TrainData/',traindatafiles(index).name));
    test_data = xlsread(strcat('TestData/',testdatafiles(index).name));
    
    %prepare training data and class labels
    temp = train_data(:,1:30);
    x=transpose(temp);
    
    temp=transpose(train_data(:,31));
    t=zeros(2,size(x,2));
    pos=find(temp==1,1,'last');
    t(1,1:pos)=1;
    t(2,pos+1:size(x,2))=1;
    
    %prepare test data and class labels
    temp = test_data(:,1:30);
    testX=transpose(temp);
    
    temp=transpose(test_data(:,31));
    testT=zeros(2,size(testX,2));
    pos=find(temp==1,1,'last');
    testT(1,1:pos)=1;
    testT(2,pos+1:size(testX,2))=1;
    
    %configure the neural network
    net = newff(x, t, [10 10 10 10 10 10 10 10 10 10]);
    net = train(net, x, t);
    op=net(testX);
    op=round(op);
    
    %find the confusion matrix
    [misclassified, confmats] = confusion(op, testT);
       
    %calculate performance metrics and report
    prec = confmats(1,1)/(confmats(1,1)+confmats(2,1));
    recall = confmats(1,1)/(confmats(1,1)+confmats(1,2));
    fscore = harmmean([prec,recall]);
    acc=1-misclassified;
    fprintf('Gesture:%s, Accuracy:%f,Precision: %f, Recall: %f, FScore: %f\n',regex_list{class},acc,prec,recall,fscore);
end