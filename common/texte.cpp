#include "texte.h"
#include <iostream>

using namespace common;

Texte::Texte(const std::string &str):Valeur(), _value(str) {
}

std::string Texte::getValue() const {
    return _value;
}

std::string Texte::toTXT() const {
    std::string output(_value);

    output = "<TEXTE>" + output + "</TEXTE>\n";

    return output;
}
