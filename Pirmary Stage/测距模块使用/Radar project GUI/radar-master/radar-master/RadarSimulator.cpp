#include "RadarSimulator.h"
#include <QDesktopWidget>
#include <QApplication>
#include <QFontDatabase>
RadarSimulator::RadarSimulator(QWidget *parent) : QWidget(parent)
{
     iDistance = 0;
     iAngle = 0;
     setWindowFlags(Qt::FramelessWindowHint);
     QDesktopWidget *desktop = QApplication::desktop();
     QRect screen = desktop->availableGeometry ();
     width = screen.width();
     height = screen.height();
     resize(width,height);
     setAutoFillBackground(true);
     setStyleSheet("background-color: rgb(31,31,31)");

     int fontId = QFontDatabase::addApplicationFont(":/resfile/SourceHanSansCN-Bold.otf");
     if(fontId != -1) {
         QStringList androidFont = QFontDatabase::applicationFontFamilies(fontId);
         if(androidFont.size() != 0) {
             font_title = androidFont.at(0);
             font_title.setPointSize(20);
         }
     }

     QColor color(98,245,31);
     pen_draw.setWidthF(2);
     pen_draw.setColor(color);

     font_txt.setPointSize(16);
     font_Reslt.setPointSize(20);

     btnExit = new QPushButton(this);
     btnExit->setIcon(QIcon(":/resfile/exit.png"));
     btnExit->setIconSize(QSize(104, 48));
     btnExit->setStyleSheet("background:transparent");
     btnExit->setAttribute(Qt::WA_DeleteOnClose);
     connect(btnExit, SIGNAL(clicked()), this, SLOT(closeExp()));
     btnExit->move(width-110, 10);
     SerialOpen();

     bseqflow = false;
     bRecyle = false;
     bNeedErase = false;
}

void RadarSimulator::SerialOpen()
{
    date_maker=new QTimer;
    connect(date_maker, SIGNAL(timeout()), this, SLOT(RadarData()));
    date_maker->start(20);
}

void RadarSimulator::RadarData()
{
    if(!bseqflow){
      iAngle += 1;
      if(iAngle >= 180){
         bseqflow = true;
         bRecyle = true;
      }
    }
    else{
        iAngle -= 1;
        if(iAngle <= 0){
           bseqflow = false;
           bRecyle = true;
        }
    }

    if(iAngle > 30 && iAngle < 120 ){//扫描角度
//        iDistance ++;
//        if(iDistance >= 80)
          iDistance = 60;//扫描距离
    }else
        iDistance = 0;
   // qDebug("Distance:%d, Angle:%d", iDistance, iAngle);

    update();
}

void RadarSimulator::closeExp()
{
    close();
}

void RadarSimulator::drawInit()
{
    QPainter *painter = new QPainter(this);
    painter->setRenderHint(QPainter::Antialiasing);
    painter->setRenderHint(QPainter::SmoothPixmapTransform);
    painter->setRenderHint(QPainter::TextAntialiasing);

    painter->save();
    painter->setPen(pen_draw);
    painter->setFont(font_title);
    painter->drawText(10, height*0.043, "雷达模拟实验");
    painter->restore();

    drawRadar(painter);

    drawText(painter);//角度刻度

    delete painter;
}

void RadarSimulator::paintEvent( QPaintEvent *e )
{
    drawInit();
    drawLine();
    drawObject();
}

void RadarSimulator::drawRadar(QPainter *painter)
{
    painter->save();
    painter->setPen(pen_draw);

    painter->translate(width/2,0);
    double dOrigpos = height-height*0.074;
    painter->drawArc(-(width-width*0.0825)/2, dOrigpos-(width-width*0.0825)/2,(width-width*0.0825),(width-width*0.0825),0*16,180* 16);
    painter->drawArc(-(width-width*0.27)/2,dOrigpos-(width-width*0.27)/2,(width-width*0.27),(width-width*0.27),0*16,180* 16);
    painter->drawArc(-(width-width*0.479)/2,dOrigpos-(width-width*0.479)/2,(width-width*0.479),(width-width*0.479),0*16,180* 16);
    painter->drawArc(-(width-width*0.687)/2,dOrigpos-(width-width*0.687)/2,(width-width*0.687),(width-width*0.687),0*16,180* 16);
    painter->drawArc(-(width-width*0.887)/2,dOrigpos-(width-width*0.887)/2,(width-width*0.887),(width-width*0.887),0*16,180* 16);
    painter->restore();

    painter->save();
    painter->setPen(pen_draw);
    painter->translate(width/2,height-height*0.074);

    painter->drawLine(-width/2,0,width/2,0);
    double dRadius = width/2*0.96;

    painter->drawLine(0,0,(-dRadius)*qCos(qDegreesToRadians(30.0)), (-dRadius)*qSin(qDegreesToRadians(30.0)));
    painter->drawLine(0,0,(-dRadius)*qCos(qDegreesToRadians(60.0)), (-dRadius)*qSin(qDegreesToRadians(60.0)));
    painter->drawLine(0,0,(-dRadius)*qCos(qDegreesToRadians(90.0)), (-dRadius)*qSin(qDegreesToRadians(90.0)));
    painter->drawLine(0,0,(-dRadius)*qCos(qDegreesToRadians(120.0)),(-dRadius)*qSin(qDegreesToRadians(120.0)));
    painter->drawLine(0,0,(-dRadius)*qCos(qDegreesToRadians(150.0)),(-dRadius)*qSin(qDegreesToRadians(150.0)));
    painter->drawLine((-dRadius)*qCos(qDegreesToRadians(30.0)),0,dRadius,0);
    painter->restore();
}

//实时扫描
void RadarSimulator::drawLine()
{
    QPainter *painter = new QPainter(this);
    painter->save();

    QPen pen;
    QColor color(30,250,60);
    pen.setWidthF(16);
    pen.setColor(color); //添加线的颜色
    painter->setPen(pen);
    painter->translate(width/2,height-height*0.074);
    // draws the line according to the angle
    //painter->drawLine(0,0,(height-height*0.12)*qCos(qDegreesToRadians((double)iAngle)),-(height-height*0.12)*qSin(qDegreesToRadians((double)iAngle)));

    if(bRecyle){
        veclines.clear();
        bRecyle = false;
        bNeedErase = true;
    }
    if(veclines.size() >= 30){
        veclines.pop_front();
    }
    QLineF line(0, 0,(height-height*0.12)*qCos(qDegreesToRadians((double)iAngle)),
                -(height-height*0.12)*qSin(qDegreesToRadians((double)iAngle)));
    veclines.push_back(line);
   //qDebug("***DrawLine:Angle:%d", iAngle);
    int line_cnt = veclines.size();
    for(int num = 0; num < line_cnt; num++)
    {
        float opc = 0.3;
        if(num != 0){
          opc = (float)2.0*num / line_cnt;
          if(opc <= 0.3)
              opc = 0.3;
        }
        painter->setOpacity(opc);
        painter->drawLine(veclines[num]);
    }

   // painter->drawLines(veclines);

    painter->restore();
    delete(painter);
}

//绘制扫描的物体
void RadarSimulator::drawObject()
{
    QPainter *painter = new QPainter(this);
    painter->save();
    QPen pen;
    QColor color(255,10,10);
    pen.setWidthF(16);
    pen.setColor(color); //添加线的颜色
    painter->setPen(pen);

    painter->translate(width/2,height-height*0.074); // moves the starting coordinats to new location
    float pixsDistance = iDistance*((height-height*0.1666)*1/180); // covers the distance from the sensor from cm to pixels
    // limiting the range to 40 cms

    if(iDistance<180 && iDistance > 0)
    {
        if(bNeedErase){
            vecObjlines.clear();
            bNeedErase = false;
        }

        QLineF line(pixsDistance*qCos(qDegreesToRadians((double)iAngle)),
                    -pixsDistance*qSin(qDegreesToRadians((double)iAngle)),
                    (width-width*0.538)*qCos(qDegreesToRadians((double)iAngle)),
                    -(width-width*0.538)*qSin(qDegreesToRadians((double)iAngle)));
        vecObjlines.push_back(line);
    }

    int line_cnt = vecObjlines.size();
    for(int num = 0; num < line_cnt; num++)
    {
        float opc = 0.3;
        if(num != 0){
          opc = (float)2.0*num / line_cnt;
          if(opc <= 0.3)
              opc = 0.3;
        }
        painter->setOpacity(opc);
        painter->drawLine(vecObjlines[num]);
    }

   // painter->drawLines(vecObjlines);
    painter->restore();
    delete(painter);
}

void RadarSimulator::drawText(QPainter *painter)
{
    painter->save();
    painter->setBrush(Qt::black);
    painter->drawRect(0,height-height*0.070,width,height*0.070);
    painter->restore();

    painter->save();
    QString noObject;
    if(iDistance>180 || iDistance <=  2) {
        noObject = "超出范围";
    }
    else {
        noObject = "已探测到";
    }

    painter->setPen(pen_draw);
    painter->setFont(font_txt);
    painter->drawText(width-width*0.4754, height-height*0.0833, "20cm");
    painter->drawText(width-width*0.3854, height-height*0.0833, "60cm");
    painter->drawText(width-width*0.281,  height-height*0.0833, "100cm");
    painter->drawText(width-width*0.177,  height-height*0.0833, "140cm");
    painter->drawText(width-width*0.0799, height-height*0.0833, "180cm");

    painter->setFont(font_Reslt);
    painter->drawText(width-width*0.915, height-height*0.0260, "目标: " + noObject);
    QString angle_ = QString::number(iAngle);
    painter->drawText(width-width*0.53, height-height*0.0260,  "角度: " + angle_ +" °");
    QString dis = QString::number(iDistance);
    painter->drawText(width-width*0.30, height-height*0.0260,  "距离: " + dis + " cm");
    painter->restore();

    painter->save();
    painter->setPen(pen_draw);
    painter->setFont(font_txt);
    painter->translate((width-width*0.5094)+width/2*qCos(qDegreesToRadians(30.0)),(height-height*0.0700)-width/2*qSin(qDegreesToRadians(30.0)));
    painter->rotate(-qDegreesToRadians(-60.0));
    painter->drawText(0, 0, "30°");
    painter->restore();

    painter->save();
    painter->setPen(pen_draw);
    painter->setFont(font_txt);
    painter->translate((width-width*0.509)+width/2*qCos(qDegreesToRadians(60.0)),(height-height*0.0650)-width/2*qSin(qDegreesToRadians(60.0)));
    painter->rotate(-qDegreesToRadians(-30.0));
    painter->drawText(0,0, "60°");
    painter->restore();

    painter->save();
    painter->setPen(pen_draw);
    painter->setFont(font_txt);
    painter->translate((width-width*0.507)+width/2*qCos(qDegreesToRadians(90.0)),(height-height*0.0433)-width/2*qSin(qDegreesToRadians(90.0)));
    painter->rotate(qDegreesToRadians(0.0));
    painter->drawText(0,0, "90°");
    painter->restore();

    painter->save();
    painter->setPen(pen_draw);
    painter->setFont(font_txt);
    painter->translate(width-width*0.503+width/2*qCos(qDegreesToRadians(120.0)),(height-height*0.06129)-width/2*qSin(qDegreesToRadians(120.0)));
    painter->rotate(qDegreesToRadians(-30.0));
    painter->drawText(0,0, "120°");
    painter->restore();

    painter->save();
    painter->setPen(pen_draw);
    painter->setFont(font_txt);
    painter->translate((width-width*0.5104)+width/2*qCos(qDegreesToRadians(150.0)),(height-height*0.0574)-width/2*qSin(qDegreesToRadians(150.0)));
    painter->rotate(qDegreesToRadians(-60.0));
    painter->drawText(0,0, "150°");
    painter->restore();

}


