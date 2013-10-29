package frequencyagent;

import java.util.ArrayList;
import java.util.HashMap;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.OperationCanceledException;
import org.eclipse.core.runtime.Status;
import org.eclipse.linuxtools.tmf.event.TmfEvent;
import org.eclipse.linuxtools.tmf.event.TmfEventField;
import org.eclipse.linuxtools.tmf.event.TmfNoSuchFieldException;
import org.eclipse.linuxtools.tmf.event.TmfTimeRange;

import com.mentor.embedded.profiler.agent.IDataAcqRequest;
import com.mentor.embedded.profiler.agent.WidgetType;
import com.mentor.embedded.profiler.agent.common.AgentAnalysis;
import com.mentor.embedded.profiler.core.data.EventFilter;
import com.mentor.embedded.profiler.extension.IEventAnalysisDetailInformation;
import com.mentor.jeda.jwdb.JwdbEvent;
import com.mentor.jeda.jwdb.JwdbWf;
import com.mentor.embedded.profiler.extension.FilterType;

public class FunctionRate extends AgentAnalysis implements
IEventAnalysisDetailInformation {
	private JwdbEvent wdbEvent;
	private HashMap<String, JwdbWf> wfFunctionRates;

	@Override
	public WidgetType[] getWidgetTypes() {
		return WidgetType.createWfTypes(WidgetType.ANALOG);
	}

	@Override
	public String getCategory() {
		return "Software"; //$NON-NLS-1$
	}

	@Override
	public IDataAcqRequest[][] getDataAcqRequests() {
		IDataAcqRequest[] reqs = new IDataAcqRequest[] {};

		return new IDataAcqRequest[][] { reqs };
	}

	private JwdbWf getWfFunctionRate(String name) {
		JwdbWf wfFunctionRate = wfFunctionRates.get(name);
		if (wfFunctionRate == null) {
			wfFunctionRate = getWdbWf(name,
					"Calls Per Second", FilterType.analog, 0); //$NON-NLS-1$
			wfFunctionRates.put(name, wfFunctionRate);
		}
		return wfFunctionRate;
	}

	@Override
	public IStatus preProcessing(IProgressMonitor monitor)
			throws OperationCanceledException {
		wdbEvent = new JwdbEvent();
		wfFunctionRates = new HashMap<String, JwdbWf>();

		// filter for events of useful types
		EventFilter ef = new EventFilter();
		EventFilter.Filter f1 = new EventFilter.Filter();
		f1.addEventType("function_rate");
		ef.filters.add(f1);
		setFilter(ef);

		return Status.OK_STATUS;
	}

	private int findHits(long time, ArrayList<Long> list) {
		int hits = 0;
		long backwards = 1000000000;
		long forwards = 1000000000;
		long extra = list.get(list.size() - 1) - time;
		if(extra < 1000000000) {
			backwards += 1000000000 - extra;
		}
		for (int keyIndex = 0; keyIndex < list.size(); keyIndex++) {
			if (list.get(keyIndex) >= (time - backwards)
					&& list.get(keyIndex) <= (time + forwards)) {
				hits++;
			}
		}
		return hits / 2;
	}

	@Override
	public IStatus processData(IProgressMonitor monitor, TmfEvent[] events)
			throws OperationCanceledException {
		HashMap<String, ArrayList<Long>> map = new HashMap<String, ArrayList<Long>>();
		for (TmfEvent event : events) {
			try {
				String name = (String) ((TmfEventField) event.getContent().getField("name")).getValue();
				ArrayList<Long> hitList = map.get(name);
				if (hitList == null) {
					hitList = new ArrayList<Long>();
					map.put(name, hitList);
				}
				hitList.add(event.getTimestamp().getValue());

			} catch (TmfNoSuchFieldException e) {
				e.printStackTrace();
			}
		}

		for (String name : map.keySet()) {
			ArrayList<Long> hitList = map.get(name);
			for (long time = 0; time < hitList.get(hitList.size() - 1); time += (1000000000 / 10)) {
				wdbEvent.setX(time);
				wdbEvent.setIntY(findHits(time, hitList));
				getWfFunctionRate(name).appendWfEvent(wdbEvent);
			}
		}

		return Status.OK_STATUS;
	}

	@Override
	public IStatus postProcessing(IProgressMonitor monitor)
			throws OperationCanceledException {
		wdbEvent = null;
		wfFunctionRates = null;

		return Status.OK_STATUS;
	}

	@Override
	public String[] getDetail(String id, TmfTimeRange timeRange, int maxNum) {
		String msg = "<table><caption>Test</caption>" + "<tr><td>id</td><td>"
				+ id + "</td></tr>" + "<tr><td>timeRange</td><td>"
				+ timeRange.getStartTime().getValue() + "..."
				+ timeRange.getEndTime().getValue() + "</td></tr>"
				+ "<tr><td>maxNum</td><td>" + maxNum + "</td></tr>"
				+ "</table>";
		return new String[] { msg };
	}
}
