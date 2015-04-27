#include "rasterwindow.h"

#include <QtGui/QLinearGradient>

RasterWindow::RasterWindow(QWindow *parent) :
		QWindow(parent), m_update_pending(false), _flush(true) {
	_backingStore = new QBackingStore(this);

	create();

	setGeometry(0, 0, 800, 320);
	setMaximumSize(size());
	setMinimumSize(size());

	setTitle("Cluster");

	_painter = new QPainter();

}

void RasterWindow::render()
{
}

bool RasterWindow::event(QEvent *event) {
	if (event->type() == QEvent::UpdateRequest) {
		renderNow();
		m_update_pending = false;
		return true;
	}
	return QWindow::event(event);
}

void RasterWindow::renderLater() {
	if (!m_update_pending) {
		m_update_pending = true;
		QCoreApplication::postEvent(this, new QEvent(QEvent::UpdateRequest));
	}
}

void RasterWindow::resizeEvent(QResizeEvent *resizeEvent) {
	_backingStore->resize(resizeEvent->size());
	if (isExposed())
		renderNow();
}

void RasterWindow::exposeEvent(QExposeEvent *) {
	if (isExposed()) {
		renderNow();
		_flush = true;
	}
}

void RasterWindow::renderNow() {
	if (!isExposed())
		return;

	render();
}

