//********************************************************************************
// ver 1.0  15.03.2025 ISL
// Формирование выборки, нарезка окон и выполнение внутри них сдвигов
// Вход : информация по выборке через config файл D : \vib\Calc\conf_temp1_.txt
// Выход: формирование конфигурационного файла "D\\vib\\calc\\conf_temp1_.txt"
//        формирование выборок в каталог D:\\vib\\Calc\\
//                           v<N>sdv<i>.txt , где <N>-длина окна,  <i> - номер сдвига
//
//********************************************************************************

#include <iostream>
#include <fstream>
#include <string>     // для std::getline
#include <iostream>
#include <string>


//#define LENGTH 20  // длина окна для нарезки выборки - максимальная длина нарезки

int main()
{
    std::string line; //поля класса - значения
    std::string line1;//поля класса - значения
    std::string line_class;//поля класса - номер класса
    std::string line_vr;
    std::string line_c;
    std::string name_v;
    std::string s;
    std::string s1;
    int count = 0;
    int kol1 = 0;
    int kol2 = 0;
    int sdv = 0;


    int LENGTH = 20;

    std::cout << "Window Length -> ";
    std::cin >> LENGTH;

    std::ofstream out_conf;                   // поток для записи , конфигурационный файл для функций Matlab
    s = "D\\vib\\calc\\conf_temp1_.txt";

    out_conf.open(s);                         // открываем файл для записи
    if (!out_conf.is_open())
    {
        std::cout << "Файл для записи conf_temp1.txt не может быть открыт!\n"; // сообщить об этом
    }
    else
    {
        s1 = "D:\\vib\\Calc\\";
        out_conf << s1;
        out_conf << "\n";
    }


    for (int N = 2; N < LENGTH; N++)   // N- длина окна 
    {
        for (int j = 0; j < N; j++)
        {

            std::ofstream out;          // поток для записи
            name_v = "";

            name_v = "v" + std::to_string(N) + "sdv" + std::to_string(j) + ".txt";
            out.open("D:\\vib\\Calc\\" + name_v);                       // открываем файл для записи
            if (!out.is_open())
            {
                std::cout << "Файл для записи не может быть открыт!\n"; // сообщить об этом
            }
            else                                                        // формируем "D:\\vib\\calc\\conf_temp1.txt"
            {
                std::cout << line_class << std::endl;
                s1 = "";
                s1 = "D:\\vib\\Calc\\" + name_v;
                out_conf << s1;
                out_conf << "\n";
                out_conf << std::to_string(N*2 + 1);
                out_conf << "\n";
                kol1 = 0;
                kol2 = 0;
            }


            line_vr = "";
            line = "";
            line1 = "";
            line_class = "";

            setlocale(LC_ALL, "rus");
            std::ifstream in("D:\\vib\\data\\datarf.txt"); // окрываем файл для чтения
            sdv = 0; // сдвиг в окне
            count = 0;
            if (in.is_open())
            {
                while (in >> line && in >> line1 && in >> line_class)
                {
                    while (sdv < j)
                    {
                        sdv++;
                        in >> line;
                        in >> line1;
                        in >> line_class;
                    }
                    std::cout << line << " ";
                    line_vr = line_vr + " " + line + " " + line1;
                    if (count == 0)
                    {
                        line_c = line_class;
                    }
                    else
                    {
                        if (line_c != line_class)
                        {
                            count = 0;
                            line_vr = "";
                            continue;
                        }
                    }
                    count++;
                    if (count == N)
                    {
                        std::cout << line_class << std::endl;
                        count = 0;
                        out << line_vr;
                        out << " ";
                        out << line_class;
                        out << "\n";
                        line_vr = "";
                    }
                }
            }
            else
                std::cout << "Файл c выборкой не может быть открыт!\n"; // сообщить об этом
            in.close();     // закрываем файл
            out.close();

        }
    }  // cдвижка
    out_conf.close();
}
