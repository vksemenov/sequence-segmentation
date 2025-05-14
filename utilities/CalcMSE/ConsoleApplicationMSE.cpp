
#include <iostream>
#include <vector>
#include <fstream>




float mse(const float* a, const float* b, const size_t n) {
    float sum = 0;
    for (size_t i = 0; i < n; ++i) {
        float diff = a[i] - b[i];
        sum += diff * diff;
    }

    return sum / (float)n;
}

int main() {
 
  
    std::ifstream file("res1.txt");

    std::vector<float> a;
    std::vector<float> b;
    float str;

  
    while (file >> a) {
     
        a.push_back(str);
    }
    std::ifstream file("res2.txt");

   


    while (file >> str) {

        b.push_back(str);
    }

    float value = mse(a.data(), b.data(), a.size());
    std::cout << value;

    return 0;
}
