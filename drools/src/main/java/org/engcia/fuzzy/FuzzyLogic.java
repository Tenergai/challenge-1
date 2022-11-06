package org.engcia.fuzzy;

import net.sourceforge.jFuzzyLogic.FIS;
import net.sourceforge.jFuzzyLogic.plot.JFuzzyChart;
import net.sourceforge.jFuzzyLogic.rule.LinguisticTerm;
import net.sourceforge.jFuzzyLogic.rule.Variable;
import net.sourceforge.jFuzzyLogic.rule.Rule;

import java.util.HashMap;

//import net.sourceforge.jFuzzyLogic.rule.FuzzyRuleSet;

public class FuzzyLogic {

    public static int fuzzify(int windPower, int solarPower) {
        // Load from 'FCL' file
        String fileName = "src/main/resources/org/engcia/scarcity.fcl";
        FIS fis = FIS.load(fileName,true);

        // Error while loading?
        if( fis == null ) {
            System.err.println("Can't load file: '" + fileName + "'");
            return 0;
        }

        // Show
        JFuzzyChart.get().chart(fis);

        // Set inputs////########################################
        fis.setVariable("wind_power", windPower);//wind power
        fis.setVariable("solar_power", solarPower);//solar power

        // Evaluate
        fis.evaluate();

        // Show output variable's chart
        Variable energy_scarcity = fis.getVariable("energy_scarcity");
        JFuzzyChart.get().chart(energy_scarcity, energy_scarcity.getDefuzzifier(), false);
        double output = energy_scarcity.defuzzify();
        String PES = "";
        // Show output variable value
        System.out.println("Output value: " + output);

        if (output >= 0 && output < 3){
            PES = "extreme";
        } else if (output >= 3 && output < 6) {
            PES = "extreme-high";
        } else if (output >= 6 && output <9 ) {
            PES = "high-medium";
        } else if (output >= 9 && output <12 ) {
            PES = "medium-low";
        }else if (output >= 12 && output <15 ) {
            PES = "low-none";
        }else if (output >= 15 && output <30 ) {
            PES = "none";
        } else {
            PES ="error";
        }
        int threshold = 0;

        switch (PES) {
            case "extreme":
                threshold = 85;
                break;
            case "extreme-high":
                threshold = 75;
                break;
            case "high-medium":
                threshold = 65;
                break;
            case "medium-low":
                threshold = 45;
                break;
            case "low-none":
                threshold = 25;
                break;
            case "none":
                threshold = 18;
                break;
            default:
                System.out.println("Error");
        }

        System.out.println("\nLevel of scarcity: " + PES);
        System.out.println("Threshold for battery should be: " + threshold);
        // Print ruleSet
        //System.out.println(fis);

        // Show membership values for input variables
        System.out.println("Fuzzyfication:");
        Variable v;
        HashMap<String, LinguisticTerm> linguisticTerms;
        v = fis.getFunctionBlock("scarcity").getVariable("wind_power");
        System.out.println(v.getName());
        linguisticTerms = v.getLinguisticTerms();
        for( String linguisticTerm: linguisticTerms.keySet()) {
            System.out.println("\t" + linguisticTerm + " : " + v.getMembership(linguisticTerm));
        }
        v = fis.getFunctionBlock("scarcity").getVariable("solar_power");
        System.out.println(v.getName());
        linguisticTerms = v.getLinguisticTerms();
        for( String linguisticTerm: linguisticTerms.keySet()) {
            System.out.println("\t" + linguisticTerm + " : " + v.getMembership(linguisticTerm));
        }

        // Show each rule (and degree of support)
        System.out.println("Inference:");
        for(Rule r: fis.getFunctionBlock("scarcity").getFuzzyRuleBlock("No1").getRules() ) {
            System.out.println(r);
        }
        return threshold;
    }

}
