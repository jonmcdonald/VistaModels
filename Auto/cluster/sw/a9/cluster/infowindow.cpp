#include "infowindow.h"

#include <QtGui/QtGui>
#include <QtGui/qimage.h>
#include <QtCore/QDebug>
#include <QtCore/qmath.h>

InfoWindow::InfoWindow(QWindow *parent) :
		RasterWindow(parent) {
	resize(160, 320);
	m_timerId = startTimer(1000); // 1 frames per second

	backImage = new QImage(width(), height(), QImage::Format_ARGB32);
	renderStatic();
}

void InfoWindow::timerEvent(QTimerEvent *event) {
	if (event->timerId() == m_timerId)
		renderLater();
}

void InfoWindow::renderStatic() {
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
	_painter->drawRoundedRect(0, 0, width(), height(), 10.0, 10.0);

	_painter->setBrush(Qt::black);
	_painter->drawRoundedRect(4, 4, width() - 8, height() - 8, 10.0, 10.0);

	QFont font("Bitstream Vera Sans");
	font.setPointSize(10);
	_painter->setFont(font);
	QRect rt(QPoint(0, (height() / 2) - 16), QSize(width(), 32));
	_painter->setPen(Qt::white);

	_painter->drawText(rt, Qt::AlignCenter, "Vista Automotive");

	_painter->end();

}

void InfoWindow::render() {
	_painter->begin(_backingStore->paintDevice());
	QRect r(0, 0, width(), height());
	_backingStore->beginPaint(r);

	_painter->drawImage(QPoint(0, 0), *backImage);

	_backingStore->endPaint();
	_backingStore->flush(r);
	_painter->end();
}
