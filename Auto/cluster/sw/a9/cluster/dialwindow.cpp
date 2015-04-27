#include "dialwindow.h"


#include <iostream>

#include <QtGui/QtGui>
#include <QtGui/qimage.h>
#include <QtCore/QDebug>
#include <QtCore/qmath.h>

DialWindow::DialWindow(const DataObtainer::DataTypeEnum &type, double limit,
		double step, double minor, double textscale, const QString& name,
		QWindow *parent) :
		RasterWindow(parent), lim(limit), step(step), min(minor), textscale(
				textscale), name(name), value(0), _dataType(type) {
	resize(320, 320);
	target = 0;
	m_timerId = startTimer(50); // 20 frames per second

	backImage = new QImage(width(), height(), QImage::Format_ARGB32);
	p = new QPainter();
	renderStatic();
}

void DialWindow::timerEvent(QTimerEvent *event) {
	if (event->timerId() == m_timerId)
		renderLater();
}

QPoint DialWindow::pointOnCircle(double radius, double angleInDegrees,
		const QPoint& origin) {
	// Convert from degrees to radians via multiplication by PI/180
	double x = (radius * qCos(angleInDegrees * M_PI / 180)) + origin.x();
	double y = (radius * qSin(angleInDegrees * M_PI / 180)) + origin.y();
	return QPoint(x, y);
}

void DialWindow::renderStatic() {
	_painter->begin(backImage);

	_painter->setRenderHint(QPainter::Antialiasing);

	QColor backgroundColor(40, 40, 50);
	_painter->setBrush(backgroundColor);
	QRect rrr(0, 0, width(), height());
	_painter->fillRect(rrr, _painter->brush());

	QLinearGradient gradient(0, 0, width(), height());
	gradient.setColorAt(0.0, Qt::darkGray);
	gradient.setColorAt(1.0, Qt::white);

	_painter->setBrush(gradient);
	_painter->setPen(Qt::NoPen);
	_painter->drawEllipse(0, 0, width(), height());

	_painter->setBrush(Qt::black);
	_painter->drawEllipse(4, 4, width() - 8, height() - 8);

	double startangle = 90 + 50;
	double anglestep = (360 - (50 * 2)) / (lim / step) / min;

	QFont font("Bitstream Vera Sans");
	font.setPointSize(10);
	_painter->setFont(font);
	QRect rt(QPoint(0, height() - 65), QSize(width(), 32));
	_painter->setPen(Qt::white);

	_painter->drawText(rt, Qt::AlignCenter, name);

	font.setPointSize(16);
	_painter->setFont(font);

	QPoint center(width() / 2, height() / 2);
	double radius = (width() / 2) - 7;
	double current = startangle;
	int i = 0;

	QPen bold(Qt::white);
	bold.setWidth(3);
	QPen normal(Qt::gray);
	normal.setWidth(2);

	for (i = 0; i < (lim / step); i++) {
		_painter->setPen(bold);
		_painter->drawLine(pointOnCircle(radius, current, center),
				pointOnCircle(radius - 17, current, center));
		QPoint tp(pointOnCircle(radius - 38, current, center));
		tp -= QPoint(20, 16);
		QRect r(tp, QSize(40, 32));
		_painter->drawText(r, Qt::AlignCenter,
				QString::number((i * step) / textscale));

		current += anglestep;

		for (int j = 0; j < min - 1; j++) {
			_painter->setPen(normal);
			_painter->drawLine(pointOnCircle(radius, current, center),
					pointOnCircle(radius - 10, current, center));
			current += anglestep;
		}
	}
	_painter->setPen(bold);
	_painter->drawLine(pointOnCircle(radius, current, center),
			pointOnCircle(radius - 17, current, center));
	QPoint tp(pointOnCircle(radius - 38, current, center));
	tp -= QPoint(20, 16);
	QRect r(tp, QSize(40, 32));
	_painter->drawText(r, Qt::AlignCenter, QString::number((i * step) / textscale));

	QLinearGradient gradient2((width() / 2) - 20, (height() / 2) - 20,
			(width() / 2) + 20, (height() / 2) + 20);
	gradient2.setColorAt(0.0, Qt::darkGray);
	gradient2.setColorAt(1.0, Qt::white);

	_painter->setBrush(gradient2);
	_painter->setPen(Qt::NoPen);
	_painter->drawEllipse((width() / 2) - 20, (height() / 2) - 20, 40, 40);
	_painter->setBrush(Qt::black);
	_painter->drawEllipse((width() / 2) - 17, (height() / 2) - 17, 34, 34);

	_painter->end();
}

void DialWindow::render() {
	double oldvalue = value;

	uint32_t data = 0;
	if (DataObtainer::getInstance().getValue(_dataType, data)) {
		value = data;
	}

	if (value > lim) {
		value = lim;
	} else if (value < 0) {
		value = 0;
	}

	if (value == oldvalue && !_flush) {
		return;
	}

	double startangle = 90 + 50;

	QPoint center(width() / 2, height() / 2);
	double radius = (width() / 2) - 7;

	double needleAngle = startangle + (260.0 * (value / lim));

	if (_flush) {
		needlePointsVec.clear();
		needlePointsVec.append(QPoint(0, 0));
		needlePointsVec.append(QPoint(width(), 0));
		needlePointsVec.append(QPoint(width(), height()));
		needlePointsVec.append(QPoint(0, height()));
		_flush = false;
	}

	_painter->begin(_backingStore->paintDevice());
//	_painter->setRenderHint(QPainter::Antialiasing, false);

	QPolygon poly(needlePointsVec);
	QRegion region(poly.boundingRect());
	_backingStore->beginPaint(region);
	_painter->drawImage(QPoint(0, 0), *backImage);
	_backingStore->flush(region);

	needlePointsVec.clear();
	needlePointsVec.append(pointOnCircle(radius, needleAngle, center));
	needlePointsVec.append(pointOnCircle(21, needleAngle + 12, center));
	needlePointsVec.append(pointOnCircle(21, needleAngle - 12, center));

	QPolygon poly2(needlePointsVec);
	QRegion region2(poly2.boundingRect());
	_backingStore->beginPaint(region2);
	_painter->setPen(Qt::red);
	_painter->setBrush(Qt::red);
	_painter->drawConvexPolygon(needlePointsVec.constData(), 3);
	_backingStore->flush(region2);
	_backingStore->endPaint();

	_painter->end();
}
