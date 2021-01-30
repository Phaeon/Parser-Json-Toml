#ifndef VALEUR_H
#define VALEUR_H

#include "element.h"
#include <string>

namespace common {

class Valeur: public Element {
public:
    Valeur()=default;
    Valeur(Element *e);
    Valeur(Valeur *v);

    Element* getValue() const;

    std::string toTXT() const;

protected:
    Element* _valeur;
};
}

#endif
