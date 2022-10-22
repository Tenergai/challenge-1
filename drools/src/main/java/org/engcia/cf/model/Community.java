package org.engcia.cf.model;

import java.util.List;

public class Community {

    private List<Participant> participants;

    private List<Battery> batteries;

    public Community(List<Participant> participants, List<Battery> batteries) {
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
}
