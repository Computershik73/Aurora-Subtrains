#ifndef VALUEPAIR_H
#define VALUEPAIR_H

#include <QString>

struct ValuePair
{
public:
    ValuePair();
    ValuePair(const QString& string, const QString& code, bool is_meta);
    ValuePair(const ValuePair& other);
    ValuePair& operator=(const ValuePair& other);

    QString string;
    QString code;
    bool is_meta;
};

#endif // VALUEPAIR_H
