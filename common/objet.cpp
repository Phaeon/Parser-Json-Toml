#include "objet.h"
#include "nombre.h"
#include <iostream>
#include <string>
#include <map>

using namespace common;

Objet::Objet():Valeur(), _lignes() {

}

void Objet::ajoutElement(Cle* str, Valeur* v) {
    _lignes.insert({str, v});
    Element::ajoutFilsFin(str);
    Element::ajoutFilsFin(v);
}

bool Objet::contains(Cle* c) {
    for (auto i : getLignes()) {
        if (i.first->getNomCle() == c->getNomCle()) return true;
    }

    return false;
}

std::map<Cle*, Valeur*> Objet::getLignes()  {
    return _lignes;
}

void Objet::setLignes(std::map<Cle*, Valeur*> l) {
    _lignes = l;
}

Cle* Objet::getCle(std::string cle) {
    for (auto c : getLignes()) {
        if (c.first->getNomCle() == cle) return c.first;
    }
    return nullptr;
}


std::string Objet::toTXT() const {
    std::string output("\n<OBJET>\n");

    for(auto &e : _fils) {
        output += e->toTXT() + "\n";
    }

    output += "</OBJET>\n";

    return output;
}
