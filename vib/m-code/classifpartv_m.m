%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ver 1.0  15.03.2025  ISL
%  Вычисление значений классификаторов на информационной последовательности
%  Прогон всех файлов разрезанной выборки через классификаторы
%  Вход : информация по выборке через config файл D:\vib\Calc\conf_temp1_.txt
%  Выход: результаты работы классификаторов для всех файлов D:\vib\Calc\result.txt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

set(gcf,'Visible','off')              % turns current figure "off"
set(0,'DefaultFigureVisible','off');  % all subsequent figures "off"

fid = fopen('D:\vib\Calc\conf_temp1_.txt');  %  Вход : информация по выборке через config файл
catalog = fgetl(fid) % каталог

sname="D:\vib\Calc\result.txt";              %  Выход: результаты работы классификаторов
fileID = fopen(sname,'w');
fprintf(fileID,'    acc     prec    recall  macro_F micro_F Kol\n'  );

num = 0;
while ~feof(fid)                             %  чтение конфигурационного файла с информацией по выборкам
    filename = fgetl(fid);
    gr = str2num(fgetl(fid));
    if isempty(filename) || strncmp(filename,'%',1) || ~ischar(filename)
        continue
    end
    num = num + 1;

    disp("\n->");
    disp(num);
    disp(filename);                           % текущий файл с выборкой

delimiterIn = ' ';                            % разделитель "пробел"
A = importdata(filename,delimiterIn); %,headerlinesIn);

i=0;
for k = [1:(gr-1)]                            % загрузка предикторов
 X=A(:,k);                                    % последний столбец - метка
end


y = categorical(A(:,gr));                     % обработка меток
labels = categories(y);


% работа классификаторов и вывод результатов

classifier_name = {'Naive Bayes','Discriminant Analysis','Classification Tree','Nearest Neighbor','SVM','Ansamble'};


res = classification_fun(X,y,1);
fprintf(fileID,'NB %f %f %f %f %f %d ', res  ); disp(res);
res = classification_fun(X,y,2);
fprintf(fileID,'DiSkr %f %f %f %f %f %d ', res  );disp(res);
res = classification_fun(X,y,3);
fprintf(fileID,'DTree %f %f %f %f %f %d ', res  );disp(res);
res = classification_fun(X,y,4);
fprintf(fileID,'KNN %f %f %f %f %f %d ', res  );disp(res);
res = classification_fun(X,y,5);
fprintf(fileID,'SVM %f %f %f %f %f %d ', res  );disp(res);
res = classification_fun(X,y,6);
fprintf(fileID,'ENS %f %f %f %f %f %d ', res  );disp(res);

end
fclose(fileID);
fclose(fid);
fileID = fopen("signal_stop.txt",'w');
fprintf(fileID,"Process Stop"  );
fclose(fileID);

fileID = fopen("signal_stop1.txt",'w');
fprintf(fileID,"Process Stop"  );
fclose(fileID); 
fclose('all');

