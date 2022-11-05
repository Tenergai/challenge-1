package org.engcia.model;

import java.util.List;

public class Period {

    private String id;

    private String datetimePeriod;

    private List<Participant> participants;

    private double consumption;

    private double production;

    private Weather weather;

    private int threshold;
    private List<Battery> batteries;

    Pricing pricingCommunity;

    Pricing pricingExternalMarket;

    public Period(String id, String datetimePeriod, List<Participant> participants, Weather weather, List<Battery> batteries, Pricing pricingCommunity, Pricing pricingExternalMarket) {
        this.id = id;
        this.datetimePeriod = datetimePeriod;
        this.participants = participants;
        this.weather = weather;
        this.batteries = batteries;
        this.pricingCommunity = pricingCommunity;
        this.pricingExternalMarket = pricingExternalMarket;
        this.getPC();
        this.setCommunityMarketPricing();
    }

    public Period(String id, List<Participant> participants, List<Battery> batteries, Pricing externalMarketPrice, Weather weather,int thresholdNow) {
        this.id = id;
        this.participants = participants;
        this.batteries = batteries;
        this.getPC();
        this.pricingExternalMarket = externalMarketPrice;
        this.setCommunityMarketPricing();
        this.weather = weather;
    }

    public void getPC(){
        double production = 0;
        double consumption = 0;
        for (Participant participant : this.participants) {
            production += participant.getProduction();
            consumption += participant.getConsumption();
        }

        this.setConsumption(consumption);
        this.setProduction(production);
    }
    /*
    This function will return true if all batteries are above the minimum required threshold
     */
    public boolean batAboveT(){
        for (Battery b:
             this.getBatteries()) {
            if (b.getCurrentCharge()<threshold){
                return false;
            }
        }
        return true;
    }
    public double getRatio(){
        return this.getProduction()/this.getConsumption();
    }

    public boolean communityDemand(){
        for (Participant participant : this.participants) {
            if (participant.getRatio()<1){
                return true;
            }
        }
        return false;
    }

    public boolean externalDemand(){
        return pricingExternalMarket.getEnergyPrice() > pricingCommunity.getEnergyPrice();
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

    public void setCommunityMarketPricing(){
        double surplus = this.getProduction()-this.getConsumption();
        System.out.println(surplus);
        if (surplus == 0) this.setPricingCommunity(new Pricing(200.0));
        if (surplus < 0 && surplus > -100) this.setPricingCommunity(new Pricing(220.0));
        if (surplus < -100 && surplus > -500) this.setPricingCommunity(new Pricing(230.0));
        if (surplus < -500) this.setPricingCommunity(new Pricing(250.0));

        if (surplus > 0 && surplus < 100) this.setPricingCommunity(new Pricing(190.0));
        if (surplus > 100 && surplus < 500) this.setPricingCommunity(new Pricing(180.0));
        if (surplus > 500) this.setPricingCommunity(new Pricing(150.0));
    }

    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDatetimePeriod() {
        return datetimePeriod;
    }

    public void setDatetimePeriod(String datetimePeriod) {
        this.datetimePeriod = datetimePeriod;
    }

    public List<Participant> getParticipants() {
        return participants;
    }

    public void setParticipants(List<Participant> participants) {
        this.participants = participants;
    }

    public Weather getWeather() {
        return weather;
    }

    public void setWeather(Weather weather) {
        this.weather = weather;
    }

    public List<Battery> getBatteries() {
        return batteries;
    }

    public void setBatteries(List<Battery> batteries) {
        this.batteries = batteries;
    }

    public Pricing getPricingCommunity() {
        return pricingCommunity;
    }

    public void setPricingCommunity(Pricing pricingCommunity) {
        this.pricingCommunity = pricingCommunity;
    }

    public Pricing getPricingExternalMarket() {
        return pricingExternalMarket;
    }

    public void setPricingExternalMarket(Pricing pricingExternalMarket) {
        this.pricingExternalMarket = pricingExternalMarket;
    }

    public double getConsumption() {
        return consumption;
    }

    public void setConsumption(double consumption) {
        this.consumption = consumption;
    }

    public double getProduction() {
        return production;
    }

    public void setProduction(double production) {
        this.production = production;
    }

    @Override
    public String toString() {
        return "Period{" +
                "id='" + id + '\'' +
                ", datetimePeriod='" + datetimePeriod + '\'' +
                ", participants=" + participants +
                ", weather=" + weather +
                ", batteries=" + batteries +
                ", pricingCommunity=" + pricingCommunity +
                ", pricingExternalMarket=" + pricingExternalMarket +
                '}';
    }


}
