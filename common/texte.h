#ifndef TEXTE_H
#define TEXTE_H

#include "valeur.h"

namespace common {

class Texte: public Valeur {
public:
    Texte()=default;
    Texte(const std::string &str);
    Texte(const Texte &t)=default;

    std::string getValue() const;

    std::string toTXT() const;

protected:
    std::string _value;
};
}

#endif
