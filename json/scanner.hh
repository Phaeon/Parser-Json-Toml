#pragma once

#if ! defined(yyFlexLexerOnce)
#undef yyFlexLexer
#define yyFlexLexer Json_FlexLexer
#include <FlexLexer.h>
#endif

#include "json_parser.hpp"
#include "location.hh"

namespace json {

    class scanner : public Json_FlexLexer {
    public:
        scanner(std::istream &in, std::ostream &out) : Json_FlexLexer(in, out) {
        }

        ~scanner() {
        }

        //get rid of override virtual function warning
        using Json_FlexLexer::yylex;

        virtual
        int yylex(json::parser::semantic_type *const lval,
                  json::parser::location_type *location);

    private:
        json::parser::semantic_type *yylval = nullptr;

    };
}
