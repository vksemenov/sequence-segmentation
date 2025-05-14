@echo %time%
rmdir /s /q "D:\klaster\klast_iran\calc\"
timeout /t 2
rmdir /s /q "D:\klaster\klast_iran\result\"
timeout /t 2

mkdir "D:\klaster\klast_iran\calc\"
timeout /t 2
mkdir "D:\klaster\klast_iran\result\"

echo ;accuracy;nb;dicr;tree;knn;svm;ens;;;;precision;nb;dicr;tree;knn;svm;ens;;;;recall;nb;dicr;tree;knn;svm;ens;;;;macro_fscore;nb;dicr;tree;knn;svm;ens;;;; micro_fscore;nb;dicr;tree;knn;svm;ens;;;; RESERV;nb;dicr;tree;knn;svm;ens;;;; RESERV;nb;dicr;tree;knn;svm;ens;;;;> "D:\klaster\klast_iran\result\allresultsqeuclidean.csv"

echo ;accuracy;nb;dicr;tree;knn;svm;ens;;;;precision;nb;dicr;tree;knn;svm;ens;;;;recall;nb;dicr;tree;knn;svm;ens;;;;macro_fscore;nb;dicr;tree;knn;svm;ens;;;; micro_fscore;nb;dicr;tree;knn;svm;ens;;;; RESERV;nb;dicr;tree;knn;svm;ens;;;; RESERV;nb;dicr;tree;knn;svm;ens;;;;> "D:\klaster\klast_iran\result\allresultcityblock.csv"

echo ;accuracy;nb;dicr;tree;knn;svm;ens;;;;precision;nb;dicr;tree;knn;svm;ens;;;;recall;nb;dicr;tree;knn;svm;ens;;;;macro_fscore;nb;dicr;tree;knn;svm;ens;;;; micro_fscore;nb;dicr;tree;knn;svm;ens;;;; RESERV;nb;dicr;tree;knn;svm;ens;;;; RESERV;nb;dicr;tree;knn;svm;ens;;;;> "D:\klaster\klast_iran\result\allresultcosine.csv"

echo ;accuracy;nb;dicr;tree;knn;svm;ens;;;;precision;nb;dicr;tree;knn;svm;ens;;;;recall;nb;dicr;tree;knn;svm;ens;;;;macro_fscore;nb;dicr;tree;knn;svm;ens;;;; micro_fscore;nb;dicr;tree;knn;svm;ens;;;; RESERV;nb;dicr;tree;knn;svm;ens;;;; RESERV;nb;dicr;tree;knn;svm;ens;;;;> "D:\klaster\klast_iran\result\allresultcorrelation.csv"

::echo ;sqeuclidean;nb;dicr;tree;knn;svm;ens;> "D:\klaster\klast_iran\result\allresultsqeuclidean.csv"
::echo ;cityblock;nb;dicr;tree;knn;svm;ens;> "D:\klaster\klast_iran\result\allresultcityblock.csv"
::echo ;cosine;nb;dicr;tree;knn;svm;ens;> "D:\klaster\klast_iran\result\allresultcosine.csv"
::echo ;correlation;nb;dicr;tree;knn;svm;ens;> "D:\klaster\klast_iran\result\allresultcorrelation.csv"



set COUNTER=1


:loop
if %COUNTER%==100 goto end


echo D:\klaster\klast_iran\Data\all_4m.txt> D:\klaster\klast_iran\config\config_num.txt
echo D:\klaster\klast_iran\calc\>> D:\klaster\klast_iran\config\config_num.txt
echo %COUNTER% >> D:\klaster\klast_iran\config\config_num.txt

@echo %time%
rmdir /s /q "D:\klaster\klast_iran\calc\"
timeout /t 2
mkdir "D:\klaster\klast_iran\calc\"
timeout /t 2


@chcp 65001

echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo %  Прогон всей выборки через классификаторы
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
"C:\Program Files\MATLAB\R2021b\bin\matlab.exe" -nodisplay -nosplash -nodesktop -r "try, run('D:\klaster\klast_iran\Code\claster20\RIndex_num.m'), catch me, fprintf('%s / %s\n',me.identifier,me.message), end, exit"



:test01
 if exist D:\klaster\klast_iran\calc\signal_stop_Rindex.txt goto go01
timeout /t 20
goto test01
:go01

echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo %  Вычисление Accuracy классификаторов
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
"C:\Program Files\MATLAB\R2021b\bin\matlab.exe" -nodisplay -nosplash -nodesktop -r "try, run('D:\klaster\klast_iran\Code\Rclassif_b.m'), catch me, fprintf('%s / %s\n',me.identifier,me.message), end, exit"

:test11
 if exist D:\klaster\klast_iran\calc\signal_stop_Rclassif.txt goto go11
timeout /t 20
goto test11
:go11

echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo %  Формирование общего файла метрик по  классификаторам
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
start "" D:\klaster_c\app_c\ConsoleApplication442\Debug\ConsoleApplication442.exe D:\\klaster\\klast_iran\\calc\\
timeout /t 2



echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo %  Формирование сегментов по расстояниям
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
start "" D:\klaster_c\app_c\ConsoleApplication1\Debug\ConsoleApplication1.exe D:\\klaster\\klast_iran\\calc\\ "D:\\klaster\\klast_iran\\Data\\all_4m.txt
timeout /t 2


start "" D:\klaster_c\app_c\ConsoleApplication161\Debug\ConsoleApplication161.exe D:\\klaster\\klast_iran\\calc\\numklast_sqeuclidean.txt.res numklast_sqeuclidean.txt %COUNTER% 
timeout /t 2

start "" D:\klaster_c\app_c\ConsoleApplication161\Debug\ConsoleApplication161.exe D:\\klaster\\klast_iran\\calc\\numklast_cityblock.txt.res numklast_cityblock.txt %COUNTER% 
timeout /t 2
 
start "" D:\klaster_c\app_c\ConsoleApplication161\Debug\ConsoleApplication161.exe D:\\klaster\\klast_iran\\calc\\numklast_cosine.txt.res numklast_cosine.txt %COUNTER% 
timeout /t 2


start "" D:\klaster_c\app_c\ConsoleApplication161\Debug\ConsoleApplication161.exe D:\\klaster\\klast_iran\\calc\\numklast_correlation.txt.res numklast_correlation.txt %COUNTER% 

timeout /t 2


type nul > D:\klaster\klast_iran\calc\conf_temp.txt
echo D:\klaster\klast_iran\calc\numklast_sqeuclidean.txt.res\ >> D:\klaster\klast_iran\calc\conf_temp.txt
dir /B D:\klaster\klast_iran\calc\numklast_sqeuclidean.txt.res\res_0_1_num_*.txt >> D:\klaster\klast_iran\calc\conf_temp.txt
timeout /t 2

"C:\Program Files\MATLAB\R2021b\bin\matlab.exe" -nodisplay -nosplash -nodesktop -r "try, run('D:\klaster\klast_iran\Code\Rsegclassiv_mb.m'), catch me, fprintf('%s / %s\n',me.identifier,me.message), end, exit"


:test1
 if exist D:\klaster\klast_iran\calc\numklast_sqeuclidean.txt.res\signal_stop.txt goto go1
timeout /t 1
 if exist D:\klaster\klast_iran\calc\numklast_sqeuclidean.txt.res\signal_stop1.txt goto go1
timeout /t 20
goto test1
:go1


start "" D:\klaster_c\app_c\ConsoleApplication553\Debug\ConsoleApplication553.exe D:\\klaster\\klast_iran\\calc\\numklast_sqeuclidean.txt.res\\ D:\\klaster\\klast_iran\\calc\\conf_temp.txt
timeout /t 2

echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo %  Формирование результатов при евклидовой форме кластеров sqeuclidean
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
start "" D:\klaster_c\app_c\ConsoleApplication612\Debug\ConsoleApplication612.exe D:\\klaster\\klast_iran\\calc\\numklast_sqeuclidean.txt.res\\  D:\\klaster\\klast_iran\\calc\\allres.txt D:\\klaster\\klast_iran\\calc\\res.txt D:\\klaster\\klast_iran\\calc\\result.txt D:\\klaster\\klast_iran\\result\\allresultsqeuclidean.csv 

timeout /t 2


::set /A COUNTER=COUNTER+1

::pause

::goto loop


type nul > D:\klaster\klast_iran\calc\conf_temp.txt
echo D:\klaster\klast_iran\calc\numklast_cityblock.txt.res\ >> D:\klaster\klast_iran\calc\conf_temp.txt
dir /B D:\klaster\klast_iran\calc\numklast_cityblock.txt.res\res_0_1_num_*.txt >> D:\klaster\klast_iran\calc\conf_temp.txt
timeout /t 2

"C:\Program Files\MATLAB\R2021b\bin\matlab.exe" -nodisplay -nosplash -nodesktop -r "try, run('D:\klaster\klast_iran\Code\Rsegclassiv_mb.m'), catch me, fprintf('%s / %s\n',me.identifier,me.message), end, exit"


:test2
 if exist D:\klaster\klast_iran\calc\numklast_cityblock.txt.res\signal_stop.txt goto go2
timeout /t 1
 if exist D:\klaster\klast_iran\calc\numklast_cityblock.txt.res\signal_stop1.txt goto go2
timeout /t 20
goto test2
:go2

start "" D:\klaster_c\app_c\ConsoleApplication553\Debug\ConsoleApplication553.exe D:\\klaster\\klast_iran\\calc\\numklast_cityblock.txt.res\\ D:\\klaster\\klast_iran\\calc\\conf_temp.txt
timeout /t 2

echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo %  Формирование результатов при манхеттенском расстоянии кластеров citiblok
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

start "" D:\klaster_c\app_c\ConsoleApplication612\Debug\ConsoleApplication612.exe D:\\klaster\\klast_iran\\calc\\numklast_cityblock.txt.res\\  D:\\klaster\\klast_iran\\calc\\allres.txt D:\\klaster\\klast_iran\\calc\\res.txt D:\\klaster\\klast_iran\\calc\\result.txt D:\\klaster\\klast_iran\\result\\allresultcityblock.csv 

type nul > D:\klaster\klast_iran\calc\conf_temp.txt
echo D:\klaster\klast_iran\calc\numklast_cosine.txt.res\ >> D:\klaster\klast_iran\calc\conf_temp.txt
dir /B D:\klaster\klast_iran\calc\numklast_cosine.txt.res\res_0_1_num_*.txt >> D:\klaster\klast_iran\calc\conf_temp.txt
timeout /t 2

"C:\Program Files\MATLAB\R2021b\bin\matlab.exe" -nodisplay -nosplash -nodesktop -r "try, run('D:\klaster\klast_iran\Code\Rsegclassiv_mb.m'), catch me, fprintf('%s / %s\n',me.identifier,me.message), end, exit"

:test3
 if exist D:\klaster\klast_iran\calc\numklast_cosine.txt.res\signal_stop.txt goto go3
timeout /t 1
 if exist D:\klaster\klast_iran\calc\numklast_cosine.txt.res\signal_stop1.txt goto go3
timeout /t 20
goto test3
:go3

start "" D:\klaster_c\app_c\ConsoleApplication553\Debug\ConsoleApplication553.exe D:\\klaster\\klast_iran\\calc\\numklast_cosine.txt.res\\ D:\\klaster\\klast_iran\\calc\\conf_temp.txt
timeout /t 2

echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo %  Формирование результатов при косинусном расстоянии кластеров cosinus
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

start "" D:\klaster_c\app_c\ConsoleApplication612\Debug\ConsoleApplication612.exe D:\\klaster\\klast_iran\\calc\\numklast_cosine.txt.res\\  D:\\klaster\\klast_iran\\calc\\allres.txt D:\\klaster\\klast_iran\\calc\\res.txt D:\\klaster\\klast_iran\\calc\\result.txt D:\\klaster\\klast_iran\\result\\allresultcosine.csv 



type nul > D:\klaster\klast_iran\calc\conf_temp.txt
echo D:\klaster\klast_iran\calc\numklast_correlation.txt.res\ >> D:\klaster\klast_iran\calc\conf_temp.txt
dir /B D:\klaster\klast_iran\calc\numklast_correlation.txt.res\res_0_1_num_*.txt >> D:\klaster\klast_iran\calc\conf_temp.txt
timeout /t 2

"C:\Program Files\MATLAB\R2021b\bin\matlab.exe" -nodisplay -nosplash -nodesktop -r "try, run('D:\klaster\klast_iran\Code\Rsegclassiv_mb.m'), catch me, fprintf('%s / %s\n',me.identifier,me.message), end, exit"
 
:test4
 if exist D:\klaster\klast_iran\calc\numklast_correlation.txt.res\signal_stop.txt goto go4
timeout /t 1
 if exist D:\klaster\klast_iran\calc\numklast_correlation.txt.res\signal_stop1.txt goto go4
timeout /t 20
goto test4
:go4

start "" D:\klaster_c\app_c\ConsoleApplication553\Debug\ConsoleApplication553.exe D:\\klaster\\klast_iran\\calc\\numklast_correlation.txt.res\\ D:\\klaster\\klast_iran\\calc\\conf_temp.txt
timeout /t 2

echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo %  Формирование результатов при корреляционном расстоянии кластеров corelation
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

start "" D:\klaster_c\app_c\ConsoleApplication612\Debug\ConsoleApplication612.exe D:\\klaster\\klast_iran\\calc\\numklast_correlation.txt.res\\  D:\\klaster\\klast_iran\\calc\\allres.txt D:\\klaster\\klast_iran\\calc\\res.txt D:\\klaster\\klast_iran\\calc\\result.txt D:\\klaster\\klast_iran\\result\\allresultcorrelation.csv 
timeout /t 2


set /A COUNTER=COUNTER+1


goto loop

:end



