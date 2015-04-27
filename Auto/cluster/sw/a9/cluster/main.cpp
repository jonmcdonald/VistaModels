
#include <QtGui/QtGui>

#include "infowindow.h"
#include "dialwindow.h"
#include "dataobtainer.h"


int main(int argc, char **argv) {
	QGuiApplication app(argc, argv);

	RasterWindow top;

	DialWindow dial1(DataObtainer::RPM, 8000, 1000, 5, 1000, "1/min x 1000",
			&top);
	DialWindow dial2(DataObtainer::SPEED, 140, 10, 2, 1, "km/h", &top);
	dial2.setFramePosition(QPoint(480, 0));

	InfoWindow info1(&top);
	info1.setFramePosition(QPoint(320, 0));

	dial1.show();
	dial2.show();
	info1.show();

	top.show();

	return app.exec();
}
