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
        //bootstrapExpensiveHourR1(kieSession);
        ArrayList<Device> devices = new ArrayList<>();

        Device kettle = new Device("kettle", 1, false, false);
        devices.add(kettle);
        Device washingMachine = new Device("washing machine", 1, false, false);
        devices.add(washingMachine);
        Device fridge = new Device("fridge", 3, true, true);
        devices.add(fridge);
        Device ac = new Device("ac", 90, true, true);
        devices.add(ac);
        Device hairDryer = new Device("hairDryer", 17, false, true);
        devices.add(hairDryer);

        Participant participant = new Participant("1", 0, devices);

        Weather weather = new Weather(30.0, 0.0, 0.0);
        int threshold = FuzzyLogic.fuzzify(weather.getWindSpeedKMH().intValue(), weather.getSolarRadiationWattsM2().intValue());
        weather.setPredictedEnergyScarcity(threshold);

        Battery ev = new Battery(10, 10);
        participant.setEv(ev);
        ev.setThreshold(threshold);

        Pricing p = new Pricing(1000.0);

        kieSession.setGlobal("id", participant.getId());
        kieSession.insert(participant);
        kieSession.insert(weather);
        kieSession.insert(ev);
        kieSession.insert(p);
    }

    private static void bootstrapCommunity(KieSession kieSession) {
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

        Weather weather = new Weather(30.0, 700.0, 20.0);
        int threshold = FuzzyLogic.fuzzify(weather.getWindSpeedKMH().intValue(),weather.getSolarRadiationWattsM2().intValue());
        weather.setPredictedEnergyScarcity(threshold);

        Battery ev = new Battery(90,10);
        participant.setEv(ev);
        ev.setThreshold(threshold);

        Device furnace = new Device("furnace",70, true, false);
        devices = new ArrayList<>();
        devices.add(furnace);

        Participant participant1 = new Participant("2",100, devices);
        ArrayList<Participant> participants = new ArrayList<>();
        participants.add(participant);
        participants.add(participant1);

        Battery bat = new Battery(90,10);
        bat.setThreshold(threshold);
        ArrayList<Battery> batteries = new ArrayList<>();
        batteries.add(bat);

        Period period = new Period("1",participants,batteries);

        Pricing p = new Pricing(1000.0);

        kieSession.setGlobal("id", period.getId());
        kieSession.insert(weather);
        kieSession.insert(period);
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

    public static boolean chooseDevicesTurnOn(Participant participant) {

        boolean hasDevOff = false;
        for (int i = 0; i < participant.getDevices().size(); i++) {
            Device dev = participant.getDevices().get(i);
            if (!dev.isOn()) {
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

    public static void chooseDevicesTurnOff(Participant participant) {
        System.out.println("You can turn off these devices:");

        for (int i = 0; i < participant.getDevices().size(); i++) {
            Device dev = participant.getDevices().get(i);
            if (dev.isOn())
                System.out.printf("%d - %s (%.2f)\n", i, dev.getName(), participant.getProduction() / (participant.getConsumption() - dev.getConsumption()));
        }
        Scanner sc = new Scanner(System.in);
        System.out.println("Which one do you want to turn off?");
        int devi = sc.nextInt();

        Device dev = participant.getDevices().get(devi);
        dev.turnOff();
    }

    public static boolean chooseDevicesNonEssential(Participant participant) {

        boolean hasDevToTurnOff = false;
        System.out.println("-1 - I do not wish to turn off any device.");
        for (int i = 0; i < participant.getDevices().size(); i++) {
            Device dev = participant.getDevices().get(i);
            if (dev.isOn() && !dev.isEssential()) {
                System.out.printf("%d - %s (%.2f)\n", i, dev.getName(), participant.getProduction() / (participant.getConsumption() - dev.getConsumption()));
                hasDevToTurnOff = true;
            }
        }
        if (!hasDevToTurnOff) {
            System.out.println("No devices to turn off :(");
            return false;
        }
        Scanner sc = new Scanner(System.in);
        System.out.println("Which device do you want to turn off?");
        int devi = sc.nextInt();
        if (devi==-1)return false;
        Device dev = participant.getDevices().get(devi);
        dev.turnOn();
        return true;
    }

}