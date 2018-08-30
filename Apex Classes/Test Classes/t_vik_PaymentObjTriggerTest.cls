@isTest
public class t_vik_PaymentObjTriggerTest {
	
    @isTest static void paidWithMembershipOpportunity(){
        Contact con = new Contact(lastName='Tester');
        insert con;
        String recordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
        Opportunity opp = new Opportunity(name='Tester', Amount=10, npsp__Primary_Contact__c=con.Id, closeDate=Date.today(), stageName = 'Posted', RecordTypeId=recordType);
        insert(opp);
        npe01__OppPayment__c pay = new npe01__OppPayment__c(npe01__Payment_Amount__c=10, npe01__Opportunity__c=opp.Id, npe01__Paid__c=True);
        insert(pay);
    }
}