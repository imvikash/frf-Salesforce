public class vik_sendEmail {
    
//PLAIN TEXT EMAIL
    public static String sendPlainEmail(String[] toAddresses, String[] ccAddresses, String subject, String plainBody){
        
        System.debug('Plain Email Request received. To-' + toAddresses + '; Cc- '+ ccAddresses);
        String sentStatus;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        //message.toAddresses = new String[] { 'abc@gmail.com', 'xyz@gmail.com' };
        message.setToAddresses(toAddresses);
        message.setCcAddresses(ccAddresses);
        //message.optOutPolicy = 'FILTER';
        message.setSubject(subject);
        message.setPlainTextBody(plainBody);
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            sentStatus = 'success';
            System.debug('The email was sent successfully.');
        } else {
            sentStatus = 'failed';
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        return sentStatus;
    }
    
//SEND ERROR EMAIL (PLAIN TEXT)    
    public static String sendError(String errorMessage){
        
        System.debug('Error Email Request received. Message-' + errorMessage);
        String sentStatus;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        //message.toAddresses = new String[] { 'abc@gmail.com', 'xyz@gmail.com' };
        message.setToAddresses(new String[]{'im.kumarvikash@gmail.com'});
        message.setCcAddresses(null);
        //message.optOutPolicy = 'FILTER';
        message.setSubject('Error FRF Salesforce - Vikash');
        message.setPlainTextBody(errorMessage);
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            sentStatus = 'success';
            System.debug('The email was sent successfully.');
        } else {
            sentStatus = 'failed';
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        return sentStatus;
    }
    
//SEND TEMPLATE EMAIL
    public static String sendTemplatedEmail(String[] toRecipients, String[] ccRecipients, String templateApiName, ID targetObjId, Id whatId, String orgWideEmailAddress, Boolean saveAsActivity) {
    	//public static void sendTemplatedEmail(String[] toRecipients, String[] ccRecipients, String templateApiName, ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity, Attachment[] attachList ) {
      	//  templateId   must be ID of an Email template
      	//  targetObjId must be a Contact, User, Lead Id -- also used in merge fields of template recipient.xxxx
      	//  whatId    must be an SObject that is used in the merge fields of the template relatedTo.xxxx
      	//  fromId    if non null, use current user, otherwise, use this ID (most likely an org wide no reply id)
      	//  bcc      not permitted when using templates
      
        System.debug('Template Email Request received. To-' + toRecipients + '; Cc- '+ ccRecipients + '; Email Template- ' + templateApiName + '; tagetObjId-' + targetObjId + 
                        '; whatId-' + whatId + '; orgWideEmail: ' + orgWideEmailAddress);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String emailResult = 'failed';
        
        Id templateId;  
        try {
            templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;
        } catch (Exception e) {
            //throw new UtilException ('[U-03] Unable to locate EmailTemplate using name: ' + templateApiName + 
                    //' refer to Setup | Communications Templates ' + templateApiName);
            System.debug('Unable to locate EmailTemplate using name: ' + templateApiName + 
                    ' refer to Setup | Communications Templates ' + templateApiName);
        }   
        email.setToAddresses(toRecipients);
        email.setCcAddresses(ccRecipients);
        email.setTargetObjectId(targetObjId);
        email.setWhatId(whatId);
        
		OrgWideEmailAddress[] addr = [SELECT Id, DisplayName FROM OrgWideEmailAddress WHERE DisplayName=:orgWideEmailAddress LIMIT 1];
        Id orgWideEmailId = addr[0].Id;
        System.debug('Org Wide Email selected - ' + addr[0].DisplayName + ', Id: ' + addr[0].Id);
        email.setorgWideEmailAddressId(orgWideEmailId);
        email.setTemplateId(templateId);
        email.setSaveAsActivity(saveAsActivity);      // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users
        
        System.debug(LoggingLevel.INFO,'** entered sendTemplatedEmail, to:' + toRecipients + ' cc:' + ccRecipients +  ' templateId:' + templateId + ' tagetObjId:' + targetObjId + 
                        ' whatId:' + whatId + ' orgWideEmailId: ' + orgWideEmailId);
        try {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            if(results[0].isSuccess())
                emailResult = 'success';        
            else
                emailResult = 'failed';
            System.debug(emailResult);
            return emailResult;
        } catch (EmailException e) {
            System.debug('sendTemplatedEmail error. ' + e.getMessage());
            return emailResult;
        } 
    }
}