#include "booleen.h"
#include <iostream>
#include <sstream>

using namespace common;

Booleen::Booleen(const bool &bl):Valeur(),_boolean(bl) {
}

Booleen::Booleen(Booleen *b):Valeur(),_boolean(true) {
    Element::ajoutFilsDebut(b);
}

std::string Booleen::toTXT() const {
    std::string output("");

    output += "<BOOLEEN>" + std::to_string(_boolean) + "</BOOLEEN>\n";

    return output;
}
