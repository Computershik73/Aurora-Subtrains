#include "ValuePair.h"

ValuePair::ValuePair()
    : code("")
{
}

ValuePair::ValuePair(const QString& string, const QString& code, bool is_meta)
    : string(string), code(code), is_meta(is_meta)
{
}


ValuePair::ValuePair(const ValuePair &other)
    : string(other.string), code(other.code), is_meta(other.is_meta)
{
}

ValuePair &ValuePair::operator=(const ValuePair &other)
{
    if (&other == this) {
        return *this;
    }

    string = other.string;
    code = other.code;
    is_meta = other.is_meta;

    return *this;
}
