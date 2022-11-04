package org.engcia.sample;

//import org.drools.core.rule.builder.dialect.asm.ClassGenerator;

import org.engcia.fuzzy.FuzzyLogic;
import org.engcia.model.*;
import org.engcia.view.UI;
import org.kie.api.KieServices;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.kie.api.runtime.rule.LiveQuery;
import org.kie.api.runtime.rule.Row;
import org.kie.api.runtime.rule.ViewChangedEventListener;

import java.io.BufferedReader;
import java.util.ArrayList;
import java.util.Map;
import java.util.Scanner;
import java.util.TreeMap;


/**
 * This is a sample class to launch a rule.
 */
public class DroolsTest {
    public static KieSession KS;
    public static BufferedReader BR;
    public static TrackingAgendaEventListener agendaEventListener;
    public static Map<Integer, Justification> justifications;

    public static final void main(String[] args) {
        UI.uiInit();
        runEngine();
        UI.uiClose();
    }

    private static void bootstrap(KieSession kieSession) {
        ArrayList<Device> devices = new ArrayList<>();

        Device kettle = new Device("kettle", 1, false, true);
        devices.add(kettle);
        Device washingMachine = new Device("washing machine", 1, false, true);
        devices.add(washingMachine);
        Device fridge = new Device("fridge", 3, true, true);
        devices.add(fridge);
        Device ac = new Device("ac", 40, true, true);
        devices.add(ac);
        Device aird = new Device("aird", 15, false, true);
        devices.add(aird);

        Participant participant = new Participant("1",100,devices);
        kieSession.setGlobal("participantId", participant.getId());

        Weather weather = new Weather(30.0, 700.0, 20.0);
        int threshold = FuzzyLogic.fuzzify(weather.getWindSpeedKMH().intValue(),weather.getSolarRadiationWattsM2().intValue());
        weather.setPredictedEnergyScarcity(threshold);

        Battery ev = new Battery(90,10);
        //participant.setEv(ev);
        //ev.setThreshold(threshold);

        Pricing p = new Pricing(1000.0);

        kieSession.insert(participant);
        kieSession.insert(weather);
        kieSession.insert(ev);
        kieSession.insert(p);
    }

    private static void runEngine() {
        try {

            DroolsTest.justifications = new TreeMap<Integer, Justification>();

            // load up the knowledge base
            KieServices ks = KieServices.Factory.get();
            KieContainer kContainer = ks.getKieClasspathContainer();
            final KieSession kSession = kContainer.newKieSession("community-rules");
            DroolsTest.KS = kSession;
            DroolsTest.agendaEventListener = new TrackingAgendaEventListener();
            kSession.addEventListener(agendaEventListener);

            // Query listener
            ViewChangedEventListener listener = new ViewChangedEventListener() {
                @Override
                public void rowDeleted(Row row) {
                }

                @Override
                public void rowInserted(Row row) {
                    Conclusion conclusion = (Conclusion) row.get("$conclusion");
                    System.out.println(">>>" + conclusion.toString());

                    //System.out.println(DroolsTest.justifications);
                    How how = new How(DroolsTest.justifications);
                    System.out.println(how.getHowExplanation(conclusion.getId()));

                    // stop inference engine after as soon as got a conclusion
                    kSession.halt();

                }

                @Override
                public void rowUpdated(Row row) {
                }

            };

            LiveQuery query = kSession.openLiveQuery("Conclusions", null, listener);

            bootstrap(kSession);

            kSession.fireAllRules();
            kSession.dispose();
            // kSession.fireUntilHalt();

            query.close();

        } catch (Throwable t) {
            t.printStackTrace();
        }
    }

    public static boolean chooseDevicesTurnOn(Participant participant){

        boolean hasDevOff =false;
        for(int i = 0; i < participant.getDevices().size(); i++){
            Device dev = participant.getDevices().get(i);
            if(!dev.isOn()) {
                System.out.printf("%d - %s (%.2f)\n", i, dev.getName(), participant.getProduction() / (participant.getConsumption() + dev.getConsumption()));
                hasDevOff = true;
            }
        }
        if (!hasDevOff) {
            System.out.println("No devices to turn on :(");
            return false;
        }
        Scanner sc = new Scanner(System.in);
        System.out.println("Which device do you want to turn on?");
        int devi = sc.nextInt();

        Device dev = participant.getDevices().get(devi);
        dev.turnOn();
        return true;
    }
    public static void chooseDevicesTurnOff(Participant participant){
        System.out.println("You can turn off these devices:");

        for(int i = 0; i<participant.getDevices().size(); i++){
            Device dev = participant.getDevices().get(i);
            if(dev.isOn())
                System.out.printf("%d - %s (%.2f)\n", i, dev.getName(), participant.getProduction()/(participant.getConsumption()+ dev.getConsumption()));
        }
        Scanner sc = new Scanner(System.in);
        System.out.println("Which one do you want to turn off?");
        int devi = sc.nextInt();

        Device dev = participant.getDevices().get(devi);
        dev.turnOff();
    }

    //This scenario assumes r>1, pes yes, has ev no
    private static void bootstrapSTC0(KieSession kieSession) {
        ArrayList<Device> devices = new ArrayList<>();

        Device kettle = new Device("kettle", 15, false, false);
        devices.add(kettle);
        Device washingMachine = new Device("washing machine", 15, false, true);
        devices.add(washingMachine);
        Device fridge = new Device("fridge", 30, true, true);
        devices.add(fridge);
        Device ac = new Device("ac", 40, true, true);
        devices.add(ac);
        Device aird = new Device("aird", 15, false, false);
        devices.add(aird);

        Participant participant = new Participant("1",100,devices);
        kieSession.setGlobal("participantId", participant.getId());

        Weather weather = new Weather(30.0, 300.0, 12.0);
        int threshold = FuzzyLogic.fuzzify(weather.getWindSpeedKMH().intValue(),weather.getSolarRadiationWattsM2().intValue());
        weather.setPredictedEnergyScarcity(threshold);

        Battery ev = new Battery(30,10);
        //participant.setEv(ev);

        Pricing p = new Pricing(1000.0);

        kieSession.insert(participant);
        kieSession.insert(weather);
        kieSession.insert(ev);
        kieSession.insert(p);
    }
    //This scenario assumes r>1, pes yes, has ev yes, suff charged yes
    private static void bootstrapSTC1(KieSession kieSession) {
        ArrayList<Device> devices = new ArrayList<>();

        Device kettle = new Device("kettle", 15, false, false);
        devices.add(kettle);
        Device washingMachine = new Device("washing machine", 15, false, true);
        devices.add(washingMachine);
        Device fridge = new Device("fridge", 30, true, true);
        devices.add(fridge);
        Device ac = new Device("ac", 40, true, true);
        devices.add(ac);
        Device aird = new Device("aird", 15, false, false);
        devices.add(aird);

        Participant participant = new Participant("1",100,devices);
        kieSession.setGlobal("participantId", participant.getId());

        Weather weather = new Weather(30.0, 300.0, 12.0);
        int threshold = FuzzyLogic.fuzzify(weather.getWindSpeedKMH().intValue(),weather.getSolarRadiationWattsM2().intValue());
        weather.setPredictedEnergyScarcity(threshold);

        Battery ev = new Battery(90,10);
        participant.setEv(ev);

        Pricing p = new Pricing(1000.0);

        kieSession.insert(participant);
        kieSession.insert(weather);
        kieSession.insert(ev);
        kieSession.insert(p);
    }

    //This scenario assumes r>1, pes yes, has ev yes, suff charged no (charge battery)

    private static void bootstrapCB0(KieSession kieSession) {
        ArrayList<Device> devices = new ArrayList<>();

        Device kettle = new Device("kettle", 15, false, false);
        devices.add(kettle);
        Device washingMachine = new Device("washing machine", 15, false, true);
        devices.add(washingMachine);
        Device fridge = new Device("fridge", 30, true, true);
        devices.add(fridge);
        Device ac = new Device("ac", 40, true, true);
        devices.add(ac);
        Device aird = new Device("aird", 15, false, false);
        devices.add(aird);

        Participant participant = new Participant("1",100,devices);
        kieSession.setGlobal("participantId", participant.getId());

        Weather weather = new Weather(30.0, 300.0, 12.0);
        int threshold = FuzzyLogic.fuzzify(weather.getWindSpeedKMH().intValue(),weather.getSolarRadiationWattsM2().intValue());
        weather.setPredictedEnergyScarcity(threshold);

        Battery ev = new Battery(10,10);
        participant.setEv(ev);
        ev.setThreshold(threshold);

        Pricing p = new Pricing(1000.0);

        kieSession.insert(participant);
        kieSession.insert(weather);
        kieSession.insert(ev);
        kieSession.insert(p);
    }

}
