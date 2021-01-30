#include "tableau.h"
#include <iostream>
#include <string>

using namespace common;

Tableau::Tableau():Valeur(), _values() {

}

std::vector<Valeur*> Tableau::getValues() const {
    return _values;
}

void Tableau::setValues(std::vector<Valeur*> v) {
    _values = v;
}

void Tableau::addValue(Valeur* v) {
    _values.push_back(v);
    Element::ajoutFilsFin(v);
}

void Tableau::reverse() {
    std::reverse(_values.begin(), _values.end());
}


std::string Tableau::toTXT() const {
    std::string output("");

    output = "<TABLEAU>";

    for(auto &e : _fils) {
        output += e->toTXT();
    }

    output += "</TABLEAU>\n";

    return output;
}
