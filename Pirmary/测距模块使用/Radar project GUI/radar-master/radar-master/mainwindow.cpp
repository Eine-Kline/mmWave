#include "QWidget"
#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "radar.h"
#include "QPushButton"
#include "QVBoxLayout"
#include "QSize"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    radar=new Radar;
    radar->setBaseSize(600,600);
    radar->setMinimumSize(300,300);
    QPushButton *start = new QPushButton(QString("&start scan"));
    QPushButton *stop = new QPushButton(QString("&stop scan"));
    QPushButton *end = new QPushButton(QString("&end"));
    QWidget* mainWidget = new QWidget;
    QGridLayout *layout=new QGridLayout(this);
    layout->addWidget(radar,0,0,1,3);
    layout->addWidget(start,1,0,1,1);
    layout->addWidget(stop,1,1,1,1);
    layout->addWidget(end,1,2,1,1);
    mainWidget->setLayout(layout);
    this->setCentralWidget(mainWidget);
    connect(start,SIGNAL(clicked(bool)),this,SLOT(start()));
    connect(stop,SIGNAL(clicked(bool)),this,SLOT(stop()));
    connect(end,SIGNAL(clicked(bool)),this,SLOT(end()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::paintEvent( QPaintEvent *e )
{
// 	QPainter *painter = new QPainter(this);
// 	painter->setRenderHint(QPainter::Antialiasing);
// 	painter->setRenderHint(QPainter::SmoothPixmapTransform);
//
// 	QRect rect(100,100,300,300);
// 	QColor color(136,68,255);
// 	color.setAlpha(10);
// 	QLinearGradient lineGradient(rect.bottomLeft(), rect.bottomRight());
// 	lineGradient.setColorAt(0, color.dark(180));
// 	lineGradient.setColorAt(0.48, color.lighter(150));
// 	lineGradient.setColorAt(0.52, color.lighter(150));
// 	lineGradient.setColorAt(1.0, color.dark(180));
// 	painter->setBrush(lineGradient);
//
// 	painter->drawRect(rect);
}

void MainWindow::start()
{
    radar->startScan();
}

void MainWindow::stop()
{
    radar->stopScan();
}

void MainWindow::end()
{
    radar->end();
}




