#include "cle.h"
#include <iostream>
#include <string>

using namespace common;

Cle::Cle(Texte *t):Element(), _nomCle(t->getValue()) {
    Element::ajoutFilsDebut(t);
}

std::string Cle::getNomCle() const {
    return _nomCle;
}

std::string Cle::toTXT() const {
    std::string output(_nomCle);

    output = "<CLE>" + output + "<CLE>";

    return output;
}
