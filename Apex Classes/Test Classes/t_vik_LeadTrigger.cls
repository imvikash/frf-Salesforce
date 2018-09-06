@isTest
public class t_vik_LeadTrigger {
    @isTest static void newLead(){
        Lead newLead = new Lead();
        newLead.FirstName='Wild';
        newLead.LastName= 'Fire';
        newLead.Email= 'im.kumarvikash@gmail.com';
        newLead.LeadSource = 'Web';
        newLead.Company = '[not provided]';
        insert newLead;
    }
}