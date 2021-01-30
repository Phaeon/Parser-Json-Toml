#pragma once

#if ! defined(yyFlexLexerOnce)
#undef yyFlexLexer
#define yyFlexLexer Toml_FlexLexer
#include <FlexLexer.h>
#endif

#include "toml_parser.hpp"
#include "location.hh"

namespace toml {

    class scanner : public Toml_FlexLexer {
    public:
        scanner(std::istream &in, std::ostream &out) : Toml_FlexLexer(in, out) {
        }

        ~scanner() {
        }

        //get rid of override virtual function warning
        using Toml_FlexLexer::yylex;

        virtual
        int yylex(parser::semantic_type *const lval,
                  parser::location_type *location);

    private:
        parser::semantic_type *yylval = nullptr;

    };
}