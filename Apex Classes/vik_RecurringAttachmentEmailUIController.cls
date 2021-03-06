//Not Used, using vik_RecAttachEmailRenderedUIController instead
public class vik_RecurringAttachmentEmailUIController {

    private npe03__Recurring_Donation__c recDonation {get; set;}
    
    public vik_RecurringAttachmentEmailUIController(ApexPages.StandardController stdController) {
        this.recDonation = (npe03__Recurring_Donation__c)stdController.getRecord();
        emailSubject = 'Payment Details for your Donation';
        emailBody = 'Hi ' + recDonation.npe03__Donor_Name__c + ',\n\nYour payment details are attached with this email.\n\nBest Regards,';
        /*opp = [SELECT Name, (
        			SELECT FirstName, LastName, Email
        			FROM Opportunity.npsp__Primary_Contact__r)
              	FROM Opportunity
              	WHERE Id=:ApexPages.currentPage().getParameters().get('id')];*/
    }
    
    public PageReference SendEmail(){
        
        String emailResult;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        PageReference paymentPdf = Page.vik_RecDonationListAttach;
        paymentPdf.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
        //paymentPdf.getParameters().put('OpportunityId', '006f400000Cdod4AAB');	//Dummy data for Insigne, Lorezo
        paymentPdf.setRedirect(true);
        
        //Blob pdf = paymentPdf.getContent();
        Blob pdf = paymentPdf.getContentAsPDF();	//If the VF Page is not set to render as PDF
        
        Messaging.EmailFileAttachment emailPdf = new Messaging.EmailFileAttachment();
        emailPdf.setFileName('PaymentDetails.pdf');
        emailPdf.setBody(pdf);
        System.debug('PDF Attached');
        
        List<String> emailAdds = new List<String>();
        
        emailAdds.add(recDonation.npe03__Contact__r.Email);
        //emailAdds.add('im.kumarvikash@gmail.com');
        
        email.setSubject(emailSubject);
        email.setPlainTextBody(emailBody);
        email.setToAddresses(emailAdds);
        //email.setCcAddresses(emailCcAddress);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {emailPdf});
        
        //Getting Cc Address
        List<String> CcList = new List<String>();
        for(String ids: emailCcAddress.split(',')){
            CcList.add(ids);
        }
        email.setCcAddresses(CcList);
        System.debug('Subject, Body, Address and Attachment set to send.');
        
        try{
            System.debug('Attempting message send process');
        	Messaging.SendEmailResult[] results= Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});        
            if(results[0].isSuccess())
                emailResult = 'Email Successfully Sent!';        
            else
                emailResult = 'Email Not Sent!';
            System.debug(emailResult);
            //return results;
        } catch (EmailException e) {
            System.debug('sendTemplatedEmail error. ' + e.getMessage());
            //return results;
        }
        
        String returnUrl = ApexPages.currentPage().getParameters().get('id');
        return new Pagereference('/' + returnUrl);
    }
    
    //public List<String> emailAdds{get; set;}
    public String emailSubject{get; set;}
    public String emailBody{get; set;}
    public String emailCcAddress{get; set;}
}