#include "SearchHint.h"

SearchHint::SearchHint(QObject *parent) : QObject(parent)
{

}


SearchHint::SearchHint(const QString& title, const int code, const bool is_meta, QObject *parent)
    : QObject(parent)
    , value(title, code, is_meta)
{
}

SearchHint::SearchHint(const ValuePair &value, QObject *parent)
    : QObject(parent)
    , value(value)
{

}
