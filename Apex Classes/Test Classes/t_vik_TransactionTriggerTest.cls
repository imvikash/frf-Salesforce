@isTest
public class t_vik_TransactionTriggerTest {

    @isTest static void noOpportunity(){
        IATSPayment__Transaction__c trans = new IATSPayment__Transaction__c(Name='TEST123');
        insert trans;
    }
    @isTest static void rejectWithOpportunity(){
        Contact con = new Contact(lastName='Tester');
        insert con;
        Opportunity opp = new Opportunity(name='Tester', npsp__Primary_Contact__c=con.Id, closeDate=Date.today().addDays(7), stageName = 'Pledged');
        insert opp;
        IATSPayment__Transaction__c trans = new IATSPayment__Transaction__c(Name='TEST123', IATSPayment__Status__c='Reject', IATSPayment__Opportunity__c=opp.Id);
        insert trans;
    }
    @isTest static void approvedWithOpportunity(){
        Contact con = new Contact(lastName='Tester');
        insert con;
        String recordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
        Opportunity opp = new Opportunity(name='Tester', npsp__Primary_Contact__c=con.Id, closeDate=Date.today().addDays(7), stageName = 'Pledged', recordTypeId=recordType);
        System.debug('//////Adding Opportunity with record type: ' + opp.RecordTypeId);
        insert opp;
        npe01__OppPayment__c pay = new npe01__OppPayment__c(npe01__Payment_Amount__c=10, npe01__Opportunity__c=opp.Id, npe01__Paid__c=True);
        insert pay;
        IATSPayment__Transaction__c trans = new IATSPayment__Transaction__c(Name='TEST123', IATSPayment__Credit_Card__c='Card ****1234', IATSPayment__Status__c='Approved', IATSPayment__Opportunity__c=opp.Id, IATSPayment__Amount_currency__c=10);
        insert trans;
    }
}