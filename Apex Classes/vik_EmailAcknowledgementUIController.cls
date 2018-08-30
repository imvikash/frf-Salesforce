public class vik_EmailAcknowledgementUIController {
    public Opportunity opp{get; set;}
    public String emailSubject{get; set;}
    public String emailBody{get; set;}
    public String emailCcAddress{get; set;}
    
    public vik_EmailAcknowledgementUIController(ApexPages.StandardController stdController){
        this.opp = (Opportunity)stdController.getRecord();
        
        emailSubject = 'Thank You!';        
        
        //Getting Template
        Id templateId;  
        try {
            templateId = [Select id, name from EmailTemplate where developername = 'Payment_Acknowledgement'].id;
        } catch (Exception e) {
            System.debug('Unable to locate EmailTemplate');
        }
        
        //Rendering Email
        Messaging.SingleEmailMessage renderEmail = Messaging.renderStoredEmailTemplate(templateId , opp.npsp__Primary_Contact__r.Id, null);
        emailBody = renderEmail.getHtmlBody();
        System.debug(emailBody);
    }
    
    public PageReference SendEmail(){
        
        String emailResult;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        PageReference paymentPdf = Page.vik_ContactSummaryAttach;
        paymentPdf.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
        paymentPdf.setRedirect(true);
        
        Blob pdf = blob.valueof('error');
        try{
        	pdf = paymentPdf.getContent();
        } catch(Exception e){
            System.debug('Could not get Content for Blob');
        }
        //Blob pdf = paymentPdf.getContentAsPDF();	//If the VF Page is not set to render as PDF
        Messaging.EmailFileAttachment emailPdf = new Messaging.EmailFileAttachment();
        emailPdf.setFileName('Acknowledgement for ' + contact.Name + '.pdf');
        emailPdf.setBody(pdf);
        System.debug('PDF Attached');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {emailPdf});
        
        List<String> emailAdds = new List<String>();
        
        emailAdds.add(opp.npsp__Primary_Contact__r.Email);    
        
        //Setting up Email
        email.setSubject(emailSubject);
        email.setHtmlBody(emailBody);
        email.setToAddresses(emailAdds);        
        email.setTargetObjectId(opp.npsp__Primary_Contact__r.Id);
        email.setWhatId(opp.Id);
        email.setsaveAsActivity(true);
        
        //Getting Cc Address
        List<String> CcList = new List<String>();
        try{
            for(String ids: emailCcAddress.split(',')){
                if(ids.length()>3)
                    CcList.add(ids);
            }
            if(!CcList.isEmpty()){
                email.setCcAddresses(CcList);
                System.debug('Sending a Copy to- ' + CcList);
            }
            else{
                email.setCcAddresses(null);
                System.debug('Sending a copy to No-one');
            }
        } catch(NullPointerException ne){
            System.debug('Cc is empty');
        }
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
    
    public PageReference viewAttachment(){
        PageReference paymentPdf = Page.vik_renderHTML;
        //paymentPdf.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
        //paymentPdf.getParameters().put('emailBody', emailBody);
        //paymentPdf.setRedirect(true);
        return paymentPdf;
    }    
}