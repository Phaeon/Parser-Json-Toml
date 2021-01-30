#include "nombre.h"
#include <iostream>
#include <sstream>

using namespace common;

Nombre::Nombre(const float &fl):Valeur(),_value(fl),_type(NombreType::DECIMAL) {
}

Nombre::Nombre(const float &fl, NombreType type):Valeur(),_value(fl),_type(type) {
}

int Nombre::BinaryToDecimal(int n) const {
   int decimal = 0;
   int base = 1;
   int temp = n;
   while (temp) {
      int dernierChiffre = temp % 10;
      temp = temp/10;
      decimal += dernierChiffre*base;
      base *= 2;
   }

   return decimal;
}

std::string Nombre::toTXT() const {
    std::string output(std::to_string(_value));

    switch(_type) {
        case NombreType::ENTIER:
            output = "<NOMBRE>" + std::to_string(std::atoi(output.c_str())) + "</NOMBRE>\n";
            break;
        case NombreType::DECIMAL:
            output = "<NOMBRE>" + output + "</NOMBRE>\n";
            break;
        case NombreType::HEXA:
            float hexToDeci;
            std::istringstream(output) >> std::hex >> hexToDeci;
            output = "<NOMBRE>" + std::to_string(std::atoi(std::to_string(static_cast<float>(hexToDeci)).c_str())) + "</NOMBRE>\n";
            break;
        case NombreType::OCTAL:
            int octToDeci;
            std::istringstream(output) >> std::oct >> octToDeci;
            output = "<NOMBRE>" + std::to_string(static_cast<int>(octToDeci)) + "</NOMBRE>\n";
            break;
        case NombreType::BINAIRE:
            int binToDeci;
            binToDeci = Nombre::BinaryToDecimal(std::stoi(output));
            output = "<NOMBRE>" + std::to_string(binToDeci) + "</NOMBRE>\n";
            break;
        case NombreType::ERREUR_TYPE:
            output = "<NOMBRE>ERROR</NOMBRE>\n";
            break;
        default:
            break;
    }

    for(auto &e : _fils) {
        output += e->toTXT();
    }

    return output;
}
