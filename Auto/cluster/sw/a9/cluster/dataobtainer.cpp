#include "dataobtainer.h"

#include <stdio.h>

DataObtainer::DataObtainer() :
		_dummyRPM(0), _dummySpeed(0) {
}

bool DataObtainer::getValue(const DataTypeEnum& type, uint32_t& value) {
	FILE *procFile = 0;
	switch (type) {
	case RPM:
		procFile = fopen("/proc/bridge_revs", "r+");
		break;

	case SPEED:
		procFile = fopen("/proc/bridge_speed", "r+");
		break;
	}

	if (procFile) {
		rewind(procFile);
		size_t result = fread(&value, 4, 1, procFile);
		fclose(procFile);
		if (result == 1) {
			return true;
		}
	} else {
		switch (type) {
		case RPM:
			_dummyRPM = (_dummyRPM + 100) % 8000;
			value = _dummyRPM;
			return true;
			break;

		case SPEED:
			_dummySpeed = (_dummySpeed + 2) % 140;
			value = _dummySpeed;
			return true;
			break;
		}

	}
	return false;
}

