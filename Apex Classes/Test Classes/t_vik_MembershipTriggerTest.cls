@isTest
public class t_vik_MembershipTriggerTest {

    @isTest static void testMembershp(){
        Contact con = new Contact(lastName='Tester');
        insert con;
        String recordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
        Opportunity opp = new Opportunity(name='Tester', Amount=10, npsp__Primary_Contact__c=con.Id, npe01__Membership_End_Date__c=Date.today(), closeDate=Date.today(), stageName = 'Posted', RecordTypeId=recordType);
        insert(opp);
        System.debug('New Contact: ' + con.Id + ' New Membership with End Date: ' + con.npo02__MembershipEndDate__c);
        
        //Reacquire
        con.npo02__MembershipEndDate__c=Date.today().addDays(-10);
        con.npo02__NumberOfMembershipOpps__c=1;
        upsert con;
        System.debug('Same Contact for reacquire: ' + con.Id + ' Changed Membership with End Date: ' + con.npo02__MembershipEndDate__c);
        opp = new Opportunity(name='ReAcquiredTester', Amount=10, npsp__Primary_Contact__c=con.Id, npe01__Membership_End_Date__c=Date.today().addYears(1), closeDate=Date.today(), stageName = 'Posted', RecordTypeId=recordType);
        insert(opp);
        
        //Renew
        con.npo02__MembershipEndDate__c=Date.today().addDays(10);
        upsert con;
        System.debug('Same Contact for renewal: ' + con.Id + ' New Membership with End Date: ' + con.npo02__MembershipEndDate__c);
        opp = new Opportunity(name='RenewedTester', Amount=10, npsp__Primary_Contact__c=con.Id, closeDate=Date.today(), stageName = 'Posted', RecordTypeId=recordType);
        insert(opp);
    }
    /*
    @isTest static void testRenewMember(){
        Contact con = new Contact(lastName='Tester', npo02__MembershipEndDate__c=Date.today().addDays(10));
        insert con;
        String recordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
        Opportunity opp = new Opportunity(name='Tester', Amount=10, npsp__Primary_Contact__c=con.Id, closeDate=Date.today(), stageName = 'Posted', RecordTypeId=recordType);
        insert(opp);
    }
    @isTest static void testReacquireMember(){
    	Contact con = new Contact(lastName='Tester', npo02__MembershipEndDate__c=Date.today().addDays(-10));
        insert con;
        String recordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
        Opportunity opp = new Opportunity(name='Tester', Amount=10, npsp__Primary_Contact__c=con.Id, closeDate=Date.today(), stageName = 'Posted', RecordTypeId=recordType);
        insert(opp);
    }
    */
}