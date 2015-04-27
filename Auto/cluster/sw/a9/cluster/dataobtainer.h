#ifndef DATAOBTAINER_H_
#define DATAOBTAINER_H_

#include <stdint.h>

class DataObtainer {
public:
	DataObtainer();
	static DataObtainer& getInstance() {
		static DataObtainer instance;
		return instance;
	}

	enum DataTypeEnum { RPM, SPEED };
	bool getValue(const DataTypeEnum& type, uint32_t& value);

private:
	DataObtainer(DataObtainer const&);
	void operator=(DataObtainer const&);

private:
	uint32_t _dummyRPM, _dummySpeed;
};

#endif /* DATAOBTAINER_H_ */
