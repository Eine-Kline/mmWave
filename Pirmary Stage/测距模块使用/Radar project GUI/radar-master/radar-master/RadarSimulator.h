#ifndef RADARSIMULATOR_H
#define RADARSIMULATOR_H

#include <QWidget>
#include <QPainter>
#include <QtDebug>
#include "qmath.h"
#include <QPen>
#include <QPushButton>
#include <QTimer>
#define  PI 3.1415926
class RadarSimulator : public QWidget
{
    Q_OBJECT
public:
    explicit RadarSimulator(QWidget *parent = 0);
signals:
public slots:
    void closeExp();
    void RadarData();
protected:
    void paintEvent(QPaintEvent *e);
public:
    void drawInit();
    void drawRadar(QPainter *painter);
    void drawLine();
    void drawObject();
    void drawText(QPainter *painter);
public:
    void SerialOpen();
private:
    QPushButton *btnExit;
    QFont  font_title;
    QPen   pen_draw;
    QFont  font_Reslt;
    QFont font_txt;
private:
    QTimer *date_maker;
    QVector<QLineF> veclines;
    QVector<QLineF> vecObjlines;
private:
    int width;
    int height;
    int iDistance;
    int iAngle;
    bool bseqflow;
    bool bRecyle;//反向扫描一次
    bool bNeedErase;
};

#endif // RADARSIMULATOR_H
