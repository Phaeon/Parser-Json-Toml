#ifndef TABLEAU_H
#define TABLEAU_H

#include "valeur.h"
#include "element.h"
#include <string>
#include <vector>
#include <algorithm>

namespace common {

class Tableau: public Valeur {
public:
    Tableau();

    std::vector<Valeur*> getValues() const;
    void setValues(std::vector<Valeur*> v);
    void addValue(Valeur* v);
    void reverse();

    std::string toTXT() const;
private:
    std::vector<Valeur*> _values;
};
}

#endif
