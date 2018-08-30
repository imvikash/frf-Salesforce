public class vik_SwissKnife {

    public static void ClosedWonToPosted(){
        List<Opportunity> oppList = [SELECT Id, StageName FROM Opportunity WHERE StageName = 'Closed Won'];
        for(Opportunity opp: oppList){
            opp.StageName='Posted';
        }
        upsert oppList;
    }
    public static void blankMethodToCreditCard(){
        List<npe01__OppPayment__c> payments = [SELECT Name, npe01__Payment_Method__c FROM npe01__OppPayment__c
												WHERE npe01__Payment_Method__c=''];
        for(npe01__OppPayment__c pay: payments){
            pay.npe01__Payment_Method__c = 'Credit Card';
        }
        upsert payments;
    }
    
    public static void deleteRecurring(String dontDeleteId){
        List<npe03__Recurring_Donation__c> rec = [SELECT Id FROM npe03__Recurring_Donation__c
													WHERE npe03__Contact__c<>:dontDeleteId];
        delete rec;
    }

}