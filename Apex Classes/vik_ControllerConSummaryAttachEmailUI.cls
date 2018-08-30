public class vik_ControllerConSummaryAttachEmailUI {
    
    private Contact contact{get; set;}
    public String emailSubject{get; set;}
    public String emailBody{get; set;}
    public String emailCcAddress{get; set;}
    
    public vik_ControllerConSummaryAttachEmailUI(ApexPages.StandardController stdController){
        this.contact = (Contact)stdController.getRecord();
        
        emailSubject = 'Account Summary';        
        
        //Getting Template
        Id templateId;  
        try {
            templateId = [Select id, name from EmailTemplate where developername = 'Customer_Summary_Email_Body'].id;
        } catch (Exception e) {
            //throw new UtilException ('[U-03] Unable to locate EmailTemplate using name: ' + templateApiName + 
                    //' refer to Setup | Communications Templates ' + templateApiName);
            System.debug('Unable to locate EmailTemplate');
        }
        
        //Rendering Email
        Messaging.SingleEmailMessage renderEmail = Messaging.renderStoredEmailTemplate(templateId , contact.Id, null);
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
        //Blob pdf = paymentPdf.getContentAsPDF();	//If the VF Page is not set to render as PDF
        } catch(Exception e){
            System.debug('Could not get Content for Blob');
        }
        
        Messaging.EmailFileAttachment emailPdf = new Messaging.EmailFileAttachment();
        emailPdf.setFileName('Summary for ' + contact.Name + '.pdf');
        emailPdf.setBody(pdf);
        System.debug('PDF Attached');
        
        List<String> emailAdds = new List<String>();
        
        emailAdds.add(contact.Email);
        //emailAdds.add('im.kumarvikash@gmail.com');       
        
        //Setting up Email
        email.setSubject(emailSubject);
        email.setHtmlBody(emailBody);
        email.setToAddresses(emailAdds);
        //email.setCcAddresses(emailCcAddress);
        //email.setWhatId(recDonation.Id);
        
        email.setTargetObjectId(contact.Id);
        email.setsaveAsActivity(true);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {emailPdf});
        
        //Getting Cc Address
        List<String> CcList = new List<String>();
        try{
            for(String ids: emailCcAddress.split(',')){
                if(ids.length()>3)
                    CcList.add(ids);
        	}
        } catch(NullPointerException ne){
        	System.debug('No Cc Found');      
        }
        if(!CcList.isEmpty()){
            email.setCcAddresses(CcList);
            System.debug('Sending a Copy to- ' + CcList);
        }
        else{
            email.setCcAddresses(null);
            System.debug('Sending a copy to No-one');
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
        PageReference paymentPdf = Page.vik_ContactSummaryAttach;
        paymentPdf.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
        //paymentPdf.setRedirect(true);
        return paymentPdf;
    }
}