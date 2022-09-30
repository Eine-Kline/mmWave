#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "radar.h"
#include <QMainWindow>

namespace Ui {
class MainWindow;
}


class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
signals:
private slots:
    void start();
    void stop();
    void end();

private slots:
//    void on_comboBox_currentIndexChanged ( int index );
//    void on_comboBox_2_currentIndexChanged ( int index );

protected:
    void paintEvent(QPaintEvent *e);

private:
    Ui::MainWindow *ui;
    Radar *radar;
};


#endif // MAINWINDOW_H
