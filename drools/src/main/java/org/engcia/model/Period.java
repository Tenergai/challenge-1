package org.engcia.model;

import java.util.List;

public class Period {

    private String id;

    private String datetimePeriod;
    private List<Participant> participants;
    Weather weather;
    private List<Battery> batteries;
    Pricing pricing;

    public Period(String id, List<Participant> participants, List<Battery> batteries) {
        this.id = id;
        this.participants = participants;
        this.batteries = batteries;
    }
    public double getRatio(){
        double production = 0;
        double consumption = 0;
        for (Participant participant : this.participants) {
            production += participant.getProduction();
            consumption += participant.getConsumption();
        }
        return production/consumption;
    }

    public boolean communityDemand(){
        for (Participant participant : this.participants) {
            if (participant.getRatio()<1){
                return true;
            }
        }
        return false;
    }

    public boolean participantsWithSurplus(){
        for (Participant participant : this.participants) {
            if (participant.getRatio()>1){
                return true;
            }
        }
        return false;
    }

    public boolean areBatteriesSufficientlyCharged(){
        for (Battery battery: this.batteries) {
            if (!battery.isSufficientlyCharged())
                return false;
        }
        return true;
    }

    public String getId() {
        return this.id;
    }
}
