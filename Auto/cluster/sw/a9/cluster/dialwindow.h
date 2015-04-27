
#ifndef DIALWINDOW_H_
#define DIALWINDOW_H_

#include "rasterwindow.h"
#include "dataobtainer.h"

class DialWindow: public RasterWindow {
public:
	DialWindow(const DataObtainer::DataTypeEnum &type, double limit, double step, double minor,
			double textscale, const QString& name, QWindow *parent = 0);

	double target;

protected:
	void timerEvent(QTimerEvent *) Q_DECL_OVERRIDE;
	void render() Q_DECL_OVERRIDE;
	QPoint pointOnCircle(double radius, double angleInDegrees,
			const QPoint& origin);
	void renderStatic();

private:
	int m_timerId;

	double lim;
	double step;
	double min;
	double textscale;
	QString name;

	double value;

	QImage *backImage;
	QPainter* p;

	QVector<QPoint> needlePointsVec;

	DataObtainer::DataTypeEnum _dataType;
};


#endif /* DIALWINDOW_H_ */
