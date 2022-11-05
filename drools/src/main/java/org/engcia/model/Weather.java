package org.engcia.model;

public class Weather {
    private Double temperatureC;
    private Double solarRadiationWattsM2;
    private Double windSpeedKMH;
    private String predictedEnergyScarcity;

    public Weather(Double temperatureC, Double solarRadiationWattsM2, Double windSpeedKMH) {
        this.temperatureC = temperatureC;
        this.solarRadiationWattsM2 = solarRadiationWattsM2;
        this.windSpeedKMH = windSpeedKMH;
    }

    public Double getTemperatureC() {
        return temperatureC;
    }

    public void setTemperatureC(Double temperatureC) {
        this.temperatureC = temperatureC;
    }

    public Double getSolarRadiationWattsM2() {
        return solarRadiationWattsM2;
    }

    public void setSolarRadiationWattsM2(Double solarRadiationWattsM2) {
        this.solarRadiationWattsM2 = solarRadiationWattsM2;
    }

    public Double getWindSpeedKMH() {
        return windSpeedKMH;
    }

    public void setWindSpeedKMH(Double windSpeedKMH) {
        this.windSpeedKMH = windSpeedKMH;
    }
    
    public String getPredictedEnergyScarcity(){
        return this.predictedEnergyScarcity;
    }

    public int getThreshold(){
        switch (this.predictedEnergyScarcity) {
            case "extreme":
                return 85;
            case "extreme-high":
                return 75;
            case "high-medium":
                return 65;
            case "medium-low":
                return 45;
            case "low-none":
                return 25;
            case "none":
                return 18;
        }
        return 0;
    }

    public void setPredictedEnergyScarcity(int threshold) {
        switch (threshold) {
            case 85:
                this.predictedEnergyScarcity = "extreme";
                break;
            case 75:
                this.predictedEnergyScarcity = "extreme-high";
                break;
            case 65:
                this.predictedEnergyScarcity = "high-medium";
                break;
            case 45:
                this.predictedEnergyScarcity = "medium-low";
                break;
            case 25:
                this.predictedEnergyScarcity = "low-none";
                break;
            case 18:
                this.predictedEnergyScarcity = "none";
                break;
            default:
                System.out.println("Error");
        }
    }

    public boolean evaluatePredictedEnergyScarcity() {
        switch (this.predictedEnergyScarcity) {
            case "extreme":
            case "extreme-high":
            case "high-medium":
                return true;
            case "medium-low":
            case "low-none":
            case "none":
                return false;
        }
        return false;
    }
}
