/*
*创建人    李冲
*创建时间  2017年9月
*功能      绘制雷达扫描图
*/
#include <QApplication>
#include "RadarSimulator.h"
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
//    MainWindow w;
//    w.setMinimumSize(400,400);
//    w.resize(800,600);
//    w.show();

    RadarSimulator sim;
    sim.show();

    return a.exec();
}
