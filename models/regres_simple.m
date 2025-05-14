%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Вычисление значений 
%  Прогон всех файлов всех сегментов
%  Вход : файл выборки через config файл D:\r\config\config.txt
%  Выход: результаты работы регрессоров для всех файлов последовательностей:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
set(gcf,'Visible','off');
set(0,'DefaultFigureVisible','off');

clear all;
rng('default');

fid = fopen('D:\r\Calc\conf_temp.txt');
catalog = fgetl(fid) % каталог

num = 0;
summa=0.0;
summasvm=0.0;
summagr=0.0;
summatree=0.0;
summanet=0.0;

fileID = fopen("D:\r\Res\resname.txt",'w');
fclose(fileID);

while ~feof(fid)
    filename = fgetl(fid);
    if isempty(filename) || strncmp(filename,'%',1) || ~ischar(filename)
        continue
    end
    num = num + 1;


delimiterIn = ' ';
%headerlinesIn = 1;

filename = strcat(catalog,filename);
A = importdata(filename,delimiterIn); %,headerlinesIn);



i=0;
%for k = 2:15
% X(:,k-1)=A(:,k);
%end

y = A(:,3);

X(:,1)=A(:,1)
X(:,2)=A(:,2)

%[Mdl,FitInfo] = fitrlinear(X,A(:,3));
%mdl = fitlm(X,y,'Categorical',[1,2]);
mdl = fitlm(X,y);
fprintf("RMSE = %f",mdl.RMSE);

Mdlsvm = fitrsvm(X,y);
msesvm = sqrt(resubLoss(Mdlsvm));

gprMdl = fitrgp(X,y);
msegr = sqrt(resubLoss(gprMdl));

tree = fitrtree(X,y);
msetree = sqrt(resubLoss(tree));

Mdlnet = fitrnet(X,y)

fileID = fopen("D:\r\Res\resname.txt",'a');
fprintf(fileID,'%d %f %f %f %f %f\n', num, mdl.RMSE, msesvm, msegr, msetree, Mdlnet.TrainingHistory.ValidationLoss);
fclose(fileID);
summa=summa+mdl.RMSE;
summasvm=summasvm+msesvm;
summagr=summagr+msegr;
summatree=summatree+msetree;
%summanet=summanet+Mdlnet.TrainingHistory.ValidationLoss;
end

summa=summa/num;
summasvm=summasvm/num;
summagr=summagr/num;
summatree=summatree/num;
%summanet=summanet/num;

fileID = fopen("D:\r\Res\resname.txt",'a');
fprintf(fileID,'Total= %f %f \n', summa, summasvm);
fclose(fileID)

fileID = fopen("D:\r\Res\result.csv",'a');
fprintf(fileID,'%d;%f;%f;%f;%f \n',num, summa, summasvm,summagr,summatree );
fclose(fileID)

fileID = fopen("D:\r\Calc\signal_stop.txt",'w');
fprintf(fileID,"Process Stop"  );
fclose(fileID);

fileID = fopen("D:\r\Calc\signal_stop1.txt",'w');
fprintf(fileID,"Process Stop"  );
fclose(fileID); 

fclose(fid);