package org.engcia.model;

import org.engcia.sample.DroolsTest;
public class Conclusion extends Fact{
    public static final String CHARGE_BATTERY = "Charge Battery";
    public static final String SELL_COMMUNITY_MARKET = "Sell to the community market";
    public static final String SEND_GRID = "Send to the grid";
    public static final String USE_BATTERY = "Use Battery's Energy";
    public static final String BUY_EXTERNAL_MARKET = "Buy from external market";
    public static final String SELL_EXTERNAL_MARKET = "Sell to the external market";
    public static final String BALANCE_R = "Balance R";
    public static final String ADJUST_THRESHOLD = "ADJUST_THRESHOLD";
    public static final String SHIFT_LOAD_ESSENTIAL = "Shift load to essential consumption";
    public static final String LOAD_SHIFTED = "Shift load";
    public static final String BUY_CHEAPEST_MARKET = "Buy from the cheapest market";
    public static final String KEEP_BUYING = "Keep buying energy";
    public static final String IMPROVE_R = "Improve Ratio (Produciton/Consumption)";
    public static final String NO_OPERATION_NEEDED = "No operation needed";

    private String description;

    public Conclusion(String description) {
        super();
        this.description = description;
        DroolsTest.agendaEventListener.addRhs(this);
    }

    public String getDescription() {
        return description;
    }

    public String toString() {
        return "Decision: " + description;
    }
}
