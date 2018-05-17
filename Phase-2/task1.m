mkdir Group2Assignment2; %This directory stores all the output files
dirs=[05,08,07,10,15]; %Datasets used
header_in_file = importdata('E:/MATLAB/R2017b/bin/phase2/DM01/About100233AM.csv',' ',1);
sensor_names = strsplit(header_in_file{1},',');
final_sensor_names = sensor_names(1,1:34);%stores the names of sensors
regex_list = {'About','And','Can','cop','deaf','decide','father','find','go out','hearing'};
for sensor=1:size(regex_list,2)
    metadata=[];%stores the action and sensor names
    final_output = []; %transpose of sensor values
    required_data = []; %stores the sensor values
    n=1; %to keep track of number of rows in each file
    action(1:34,1) = string(regex_list{sensor});
    for d=1:size(dirs,2)
        dirPath=strcat('E:/MATLAB/R2017b/bin/phase2/DM',sprintf('%02d',dirs(d)),'/');
        dirContent=dir(dirPath);
        disp(dirPath)
        for fn=1:size(dirContent,1)%loop through all the files in the given dataset
            if contains(dirContent(fn).name,regex_list{sensor},'IgnoreCase',true)
                raw_data_each_file = xlsread(strcat(dirPath,dirContent(fn).name));
                required_data = [raw_data_each_file(:,1:34)];
                final_output(n:n+33,1:size(required_data,1))=[required_data'];
                metadata=[metadata; action final_sensor_names'];
                n=n+34;
            end
        end
    end
    [rows,cols]=size(final_output);
    for r=1:rows
        for c=cols:-1:1
            if(final_output(r,c)==0)
                final_output(r,c)=99999;
            else
                break;
            end
        end
    end
    result=[final_output];
    result(result==99999)=NaN;
    res=num2cell(result);
    res(isnan(result))={'NaN'};
    %name of the output file
    filename = strcat('Group2Assignment2/output_', regex_list{sensor},'.xlsx');
    xlswrite(filename,metadata,'Sheet1','A1');
    xlswrite(filename,res,'Sheet1','C1');
    fprintf('Completed - %s\n',regex_list{sensor});
end
