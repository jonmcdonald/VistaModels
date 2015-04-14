#ifndef RASTERWINDOW_H
#define RASTERWINDOW_H

#include <QtGui/QtGui>

class RasterWindow : public QWindow
{
	Q_OBJECT
public:
	explicit RasterWindow(QWindow *parent = 0);

	virtual void render(QPainter *, QBackingStore*) { };

	public slots:
	void renderLater();
	void renderNow();

	protected:
	bool event(QEvent *event) Q_DECL_OVERRIDE;

	void resizeEvent(QResizeEvent *event) Q_DECL_OVERRIDE;
	void exposeEvent(QExposeEvent *event) Q_DECL_OVERRIDE;



	public:
	QBackingStore *m_backingStore;
	QPainter* _painter;
	bool m_update_pending;
public:
	bool _flush;
};

#endif // RASTERWINDOW_H
