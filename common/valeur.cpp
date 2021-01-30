#include "valeur.h"
#include <iostream>
#include <string>

using namespace common;

Valeur::Valeur(Element *v):Element(),_valeur(v) {
}

Valeur::Valeur(Valeur *t):Element(), _valeur(t->_valeur) {
    Element::ajoutFilsDebut(t);
}

Element* Valeur::getValue() const {
    return _valeur;
}

std::string Valeur::toTXT() const {
    std::string output("");

    output = "<VALUE>\n";

    for(auto &e : _fils) {
        output += e->toTXT();
    }

    output += "</VALUE>";

    return output;
}
