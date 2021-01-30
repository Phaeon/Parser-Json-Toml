#include <fstream>
#include "tomlParser.hh"

#include "scanner.hh"

common::Document* parseTOML(const std::string &filename) {
    auto input = std::ifstream(filename);
    common::driver driver;
    toml::scanner scanner(input, std::cout);
    toml::parser parser(scanner, driver);

    if (!input.good()) {
        std::cerr << "impossible de lire le fichier : " << filename << std::endl;
        return driver.get_racine();
    }

    parser.set_debug_level(false);
    if (parser.parse()) {
        std::cerr << "erreur de parsing du fichier" << std::endl;
        return nullptr;
    }

    input.close();

    return driver.get_racine();
}
