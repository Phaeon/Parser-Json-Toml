#ifndef NOMBRE_H
#define NOMBRE_H

#include "valeur.h"

namespace common {

enum class NombreType { ENTIER, DECIMAL, HEXA, OCTAL, BINAIRE, ERREUR_TYPE };

class Nombre: public Valeur {
public:
    Nombre()=default;
    Nombre(const float &fl);
    Nombre(const float &fl, NombreType type);

    std::string toTXT() const;

    int BinaryToDecimal(int n) const ;

private:
    float _value;
    NombreType _type;
};
}

#endif
