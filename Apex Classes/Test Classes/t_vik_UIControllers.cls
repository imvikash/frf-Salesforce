@isTest
public class t_vik_UIControllers {
    @isTest static void testEmailAck(){
        PageReference pageRef = Page.vik_EmailAcknowledgementUI;
        Test.setCurrentPage(pageRef);
        
        Contact con = new Contact(lastName='Tester');
        insert con;
        Opportunity opp = new Opportunity(name='Tester', npsp__Primary_Contact__c=con.Id, closeDate=Date.today().addDays(7), stageName = 'Pledged');
        insert opp;
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        vik_EmailAcknowledgementUIController controller = new vik_EmailAcknowledgementUIController(sc);
        
        controller.viewAttachment();
        controller.sendEmail();
    }
    @isTest static void testResendAck(){
        PageReference pageRef = Page.vik_ResendOpportunityAck;
        Test.setCurrentPage(pageRef);
        
       Contact con = new Contact(lastName='Tester');
        insert con;
        Opportunity opp = new Opportunity(name='Tester', npsp__Primary_Contact__c=con.Id, closeDate=Date.today().addDays(7), stageName = 'Pledged');
        insert opp;
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        vik_ResendOpportunityAck controller = new vik_ResendOpportunityAck(sc);
        
        controller.resendAcknowledgement();
    }
    @isTest static void testContSummaryEmailUI(){
        PageReference pageRef = Page.vik_ConSummaryAttachEmailUI;
        Test.setCurrentPage(pageRef);
        
        Contact con = new Contact(lastName='Tester');
        insert con;
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        vik_ControllerConSummaryAttachEmailUI controller = new vik_ControllerConSummaryAttachEmailUI(sc);
        
        controller.viewAttachment();
        controller.sendEmail();
    }
    @isTest static void testRecEmailUI(){
        PageReference pageRef = Page.vik_RecurringAttachmentEmailUI;
        Test.setCurrentPage(pageRef);
        
        Contact con = new Contact(lastName='Tester');
        insert con;
        npe03__Recurring_Donation__c rec = new npe03__Recurring_Donation__c(Name='Tester', npe03__Contact__c=con.Id, npe03__Amount__c=50, npe03__Date_Established__c=Date.today(), npe03__Installment_Period__c='Monthly');
        insert rec;
        ApexPages.StandardController sc = new ApexPages.StandardController(rec);
        vik_RecAttachEmailRenderedUIController controller = new vik_RecAttachEmailRenderedUIController(sc);
        
        controller.viewAttachment();
        controller.sendEmail();
    }
    @isTest static void testRecDetailPDF(){
        PageReference pageRef = Page.vik_RecDonationListAttach;
        Test.setCurrentPage(pageRef);
        
        vik_RecDonationAttachController controller = new vik_RecDonationAttachController();
        
        Contact con = new Contact(lastName='Tester');
        insert con;
        npe03__Recurring_Donation__c rec = new npe03__Recurring_Donation__c(Name='Tester', npe03__Contact__c=con.Id, npe03__Amount__c=50, npe03__Date_Established__c=Date.today(), npe03__Installment_Period__c='Monthly');
        insert rec;
        
        ApexPages.currentPage().getParameters().put('id', rec.Id);
        System.assertEquals(rec.id, controller.recurringDonationId);
        System.assertEquals(rec.id, controller.recurringDonation.Id);
        List<Opportunity> opps = controller.opps;
    }
    @isTest static void testConSummaryPDF(){
        PageReference pageRef = Page.vik_ContactSummaryAttach;
        Test.setCurrentPage(pageRef);
        
        vik_ContactSummaryAttachController controller = new vik_ContactSummaryAttachController();
        
        Contact con = new Contact(lastName='Tester');
        insert con;
        Opportunity opp = new Opportunity(name='Tester', npsp__Primary_Contact__c=con.Id, closeDate=Date.today().addDays(7), stageName = 'Pledged');
        insert opp;
        System.debug('#### New Test Opportunity: Name: ' + opp.Name + ', CloseDate: ' + opp.closeDate + 'Primary Contact: ' + opp.npsp__Primary_Contact__c);
        IATSPayment__IATS_Customer_Code__c code = new IATSPayment__IATS_Customer_Code__c(Name='A12345', IATSPayment__Contact__c = con.Id, IATSPayment__Opportunity__c=opp.Id);
        insert code;
        npe03__Recurring_Donation__c rec = new npe03__Recurring_Donation__c(Name='Tester', npe03__Contact__c=con.Id, npe03__Amount__c=50, npe03__Date_Established__c=Date.today(), npe03__Installment_Period__c='Monthly');
        insert rec;
        
        ApexPages.currentPage().getParameters().put('id', con.Id);
        System.assertEquals(controller.contactId, con.Id);
        System.assertEquals(controller.contact.Id, con.Id);
        List<Opportunity> opps = controller.opps;
        List<Opportunity> comingOpps = controller.comingOpps;
        List<npe03__Recurring_Donation__c> recSetup = controller.recSetup;
    }
}