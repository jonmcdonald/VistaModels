#include <iostream>

#include <QtGui/QtGui>
#include <QtGui/qimage.h>

#include <QtCore/QDebug>

#include <QtCore/qmath.h>

#include "rasterwindow.h"


class DialWindow : public RasterWindow
{
public:
	DialWindow(double limit, double step, double minor, const QString& name, QWindow *parent = 0);

	double target;

protected:
	void timerEvent(QTimerEvent *) Q_DECL_OVERRIDE;
	void render(QPainter *p, QBackingStore* backingStore) Q_DECL_OVERRIDE;
	QPoint pointOnCircle(double radius, double angleInDegrees, const QPoint& origin);
	void renderStatic();

private:
	int m_timerId;

	double lim;
	double step;
	double min;
	QString name;

	double value;

	QImage *backImage;
	QPainter* p;
};

DialWindow::DialWindow(double limit, double step, double minor, const QString& name, QWindow *parent) :
		RasterWindow(parent),
		lim(limit),
		step(step),
		min(minor),
		name(name),
		value(0)
{
	resize(320, 320);
	target = 0;
	m_timerId = startTimer(50); // 20 frames per second

	backImage = new QImage(width(), height(), QImage::Format_ARGB32);
	p = new QPainter();
	renderStatic();
}

void DialWindow::timerEvent(QTimerEvent *event)
{
	if (event->timerId() == m_timerId)
		renderLater();
}

QPoint DialWindow::pointOnCircle(double radius, double angleInDegrees, const QPoint& origin)
{
	// Convert from degrees to radians via multiplication by PI/180
	double x = (radius * qCos(angleInDegrees * M_PI / 180)) + origin.x();
	double y = (radius * qSin(angleInDegrees * M_PI / 180)) + origin.y();
	return QPoint(x, y);
}

void DialWindow::renderStatic()
{
	p->begin(backImage);

	p->setRenderHint(QPainter::Antialiasing);

	QColor backgroundColor(40, 40, 50);
	p->setBrush(backgroundColor);
	QRect rrr(0, 0, width(), height());
	p->fillRect(rrr, p->brush());


	QLinearGradient gradient(0, 0, width(), height());
	gradient.setColorAt(0.0, Qt::darkGray);
	gradient.setColorAt(1.0, Qt::white);

	p->setBrush(gradient);
	p->setPen(Qt::NoPen);
	p->drawEllipse(0, 0, width(), height());

	p->setBrush(Qt::black);
	p->drawEllipse(4, 4, width() - 8, height() - 8);


	double startangle = 90 + 50;
	double anglestep = (360 - (50 * 2)) / (lim / step ) / min;

    QFont font("Bitstream Vera Sans");
    font.setPointSize(10);
    p->setFont(font);
	QRect rt(QPoint(0, height() - 65), QSize(width(), 32));
	p->setPen(Qt::white);

	p->drawText(rt, Qt::AlignCenter, name);


    font.setPointSize(16);
    p->setFont(font);


	QPoint center(width() / 2, height() / 2);
	double radius = (width() / 2) - 7;
    double current = startangle;
    int i = 0;

    QPen bold(Qt::white);
    bold.setWidth(3);
    QPen normal(Qt::gray);
    normal.setWidth(2);

	for(i = 0; i < (lim / step ); i++) {
		p->setPen(bold);
		p->drawLine(pointOnCircle(radius, current, center), pointOnCircle(radius - 17, current, center));
		QPoint tp(pointOnCircle(radius - 38, current, center));
		tp-=QPoint(20,16);
		QRect r(tp, QSize(40, 32));
		p->drawText(r, Qt::AlignCenter, QString::number(i * step));

		current += anglestep;

		for (int j = 0; j < min - 1; j++) {
			p->setPen(normal);
			p->drawLine(pointOnCircle(radius, current, center), pointOnCircle(radius - 10, current, center));
			current += anglestep;
		}
	}
	p->setPen(bold);
	p->drawLine(pointOnCircle(radius, current, center), pointOnCircle(radius - 17, current, center));
	QPoint tp(pointOnCircle(radius - 38, current, center));
	tp-=QPoint(20,16);
	QRect r(tp, QSize(40, 32));
	p->drawText(r, Qt::AlignCenter, QString::number(i * step));


	QLinearGradient gradient2((width() / 2) - 20, (height() / 2) - 20,
			(width() / 2) + 20, (height() / 2) + 20);
	gradient2.setColorAt(0.0, Qt::darkGray);
	gradient2.setColorAt(1.0, Qt::white);

	p->setBrush(gradient2);
	p->setPen(Qt::NoPen);
	p->drawEllipse((width() / 2) - 20, (height() / 2) - 20, 40, 40);
	p->setBrush(Qt::black);
	p->drawEllipse((width() / 2) - 17, (height() / 2) - 17, 34, 34);


	p->end();
}

void DialWindow::render(QPainter *p, QBackingStore* backingStore)
{
	p->begin(m_backingStore->paintDevice());
	p->drawImage(QPoint(0, 0), *backImage);

	double oldvalue=value;

	if(target > value) {
		value += (lim / 50);
		if(value > target) {
			value = target;
		}
	}
	else if(target < value) {
		value -= (lim / 50);
		if(value < target) {
			value = target;
		}
	}

	if(value == target) {
		target = (qrand() % (((int) lim + 1)));
	}


	if(value > lim) {
		value = lim;
	}
	if(value < 0) {
		value = 0;
	}
	double startangle = 90 + 50;

	double needleAngle = startangle + (260.0 * (value / lim));
	QPoint center(width() / 2, height() / 2);
	double radius = (width() / 2) - 7;

	double oldneedleAngle = startangle + (260.0 * (oldvalue / lim));

	QPoint needle[3] = {
			pointOnCircle(radius, needleAngle, center),
			pointOnCircle(21, needleAngle+12, center),
			pointOnCircle(21, needleAngle-12, center)
	};

	QVector<QPoint> points;
	if(_flush) {
		points.append(QPoint(0, 0));
		points.append(QPoint(width(), 0));
		points.append(QPoint(width(), height()));
		points.append(QPoint(0, height()));
_flush = false;
	}
	else {
if(oldneedleAngle < needleAngle) {
		points.append(pointOnCircle(radius+2, oldneedleAngle-7, center));
	points.append(pointOnCircle(radius+2, needleAngle+7, center));
	points.append(pointOnCircle(20, needleAngle+20, center));
	points.append(pointOnCircle(20, oldneedleAngle-20, center));
}
else {
	points.append(pointOnCircle(radius+2, oldneedleAngle+7, center));
points.append(pointOnCircle(radius+2, needleAngle-7, center));
points.append(pointOnCircle(20, needleAngle-20, center));
points.append(pointOnCircle(20, oldneedleAngle+20, center));

	}
}
	QPolygon poly(points);
	QRegion region(poly);

	backingStore->beginPaint(region);

	QRect r(0, 0, width(), height());
	backingStore->beginPaint(r);


	p->setPen(Qt::red);
	p->setBrush(Qt::red);
	p->drawConvexPolygon(needle, 3);


	backingStore->endPaint();
	backingStore->flush(region);

p->end();
}


class InfoWindow : public RasterWindow
{
public:
	InfoWindow(QWindow *parent = 0);

protected:
	void timerEvent(QTimerEvent *) Q_DECL_OVERRIDE;
	void render(QPainter *p, QBackingStore* backingStore) Q_DECL_OVERRIDE;
	void renderStatic();

private:
	int m_timerId;

	QImage *backImage;
	QPainter* p;
};

InfoWindow::InfoWindow(QWindow *parent) :
		RasterWindow(parent)
{
	resize(160, 320);
	m_timerId = startTimer(1000); // 1 frames per second

	backImage = new QImage(width(), height(), QImage::Format_ARGB32);
	p = new QPainter();
	renderStatic();
}

void InfoWindow::timerEvent(QTimerEvent *event)
{
	if (event->timerId() == m_timerId)
		renderLater();
}

void InfoWindow::renderStatic()
{
	p->begin(backImage);

	p->setRenderHint(QPainter::Antialiasing);

	QColor backgroundColor(40, 40, 50);
	p->setBrush(backgroundColor);
	QRect rrr(0, 0, width(), height());
	p->fillRect(rrr, p->brush());

	QLinearGradient gradient(0, 0, width(), height());
	gradient.setColorAt(0.0, Qt::darkGray);
	gradient.setColorAt(1.0, Qt::white);

	p->setBrush(gradient);
	p->setPen(Qt::NoPen);
	p->drawRoundedRect(0, 0, width(), height(), 10.0, 10.0);

	p->setBrush(Qt::black);
	p->drawRoundedRect(4, 4, width() - 8, height() - 8, 10.0, 10.0);

    QFont font("Bitstream Vera Sans");
    font.setPointSize(10);
    p->setFont(font);
	QRect rt(QPoint(0, (height() / 2) - 16), QSize(width(), 32));
	p->setPen(Qt::white);

	p->drawText(rt, Qt::AlignCenter, "Vista Automotive");


	p->end();

}

void InfoWindow::render(QPainter *p, QBackingStore* backingStore)
{
	p->begin(m_backingStore->paintDevice());
	QRect r(0, 0, width(), height());
	backingStore->beginPaint(r);

	p->drawImage(QPoint(0, 0), *backImage);

	backingStore->endPaint();
	backingStore->flush(r);
	p->end();
}

int main(int argc, char **argv)
{
	QGuiApplication app(argc, argv);

	RasterWindow top;

	DialWindow dial1(8, 1 , 5, "1/min x 1000", &top);
	DialWindow dial2(140, 10, 2, "km/h", &top);
	dial2.setFramePosition(QPoint(480, 0));

	InfoWindow info1(&top);
	info1.setFramePosition(QPoint(320, 0));

	dial1.show();
	dial2.show();
	info1.show();

	top.show();

	return app.exec();
}
