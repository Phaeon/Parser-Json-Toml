#ifndef CLE_H
#define CLE_H

#include "element.h"
#include "texte.h"
#include <string>

namespace common {

class Cle: public Element {
public:
    Cle(Texte *t);
    void ajoutFilsDebut(Element *e);
    void ajoutFilsFin(Element *e);

    std::string getNomCle() const;

    std::string toTXT() const;
protected:
    std::string _nomCle;
};
}

#endif
