#ifndef OBJET_H
#define OBJET_H

#include "element.h"
#include "valeur.h"
#include "cle.h"
#include <string>
#include <algorithm>
#include <map>

namespace common {

class Objet: public Valeur {
public:
    Objet();
    void ajoutElement(Cle* str, Valeur* v);
    bool contains(Cle* c);

    std::map<Cle*, Valeur*> getLignes();
    void setLignes(std::map<Cle*, Valeur*> l);

    Cle* getCle(std::string cle);

    std::string toTXT() const override;

private:
    std::map<Cle*, Valeur*> _lignes;
};
}

#endif // OBJET_H
