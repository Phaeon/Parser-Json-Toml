#ifndef BOOLEEN_H
#define BOOLEEN_H

#include "valeur.h"

namespace common {

class Booleen: public Valeur {
public:
    Booleen()=default;
    Booleen(const bool &bl);
    Booleen(Booleen *b);

    std::string toTXT() const;

private:
    bool _boolean;
};
}

#endif
