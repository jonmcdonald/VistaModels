
#ifndef INFOWINDOW_H_
#define INFOWINDOW_H_

#include "rasterwindow.h"

class InfoWindow: public RasterWindow {
public:
	InfoWindow(QWindow *parent = 0);

protected:
	void timerEvent(QTimerEvent *) Q_DECL_OVERRIDE;
	void render() Q_DECL_OVERRIDE;
	void renderStatic();

private:
	int m_timerId;

	QImage *backImage;
};


#endif /* INFOWINDOW_H_ */
