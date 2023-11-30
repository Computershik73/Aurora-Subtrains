#ifndef SEARCHHINT_H
#define SEARCHHINT_H

#include <QObject>
#include "ValuePair.h"

class SearchHint : public QObject
{
     Q_OBJECT
     Q_PROPERTY(QString title READ title)
     Q_PROPERTY(int code READ code)
     Q_PROPERTY(bool is_meta READ is_meta)

 public:
     explicit SearchHint(QObject *parent = 0);
     SearchHint(const QString& title, const int code, const bool is_meta, QObject *parent = 0);
     SearchHint(const ValuePair& value, QObject* parent = 0);
 public slots:
     QString title() { return value.string; }
     int code() { return value.code; }
     bool is_meta() { return value.is_meta; }

 private:
     ValuePair value;
};

#endif // SEARCHHINT_H
