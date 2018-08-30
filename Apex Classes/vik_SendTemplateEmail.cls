public class vik_SendTemplateEmail {

/*-------------------------------------------------------------------------
HELPER method: sendTemplatedEmail
-------------------------------------------------------------------------*/
    public static String sendTemplatedEmail(String[] toRecipients, String[] ccRecipients, String templateApiName, ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity) {
    //public static void sendTemplatedEmail(String[] toRecipients, String[] ccRecipients, String templateApiName, ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity, Attachment[] attachList ) {
      //  templateId   must be ID of an Email template
      //  targetObjId must be a Contact, User, Lead Id -- also used in merge fields of template recipient.xxxx
      //  whatId    must be an SObject that is used in the merge fields of the template relatedTo.xxxx
      //  fromId    if non null, use current user, otherwise, use this ID (most likely an org wide no reply id)
      //  bcc      not permitted when using templates
      
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String emailResult = 'Email Not Sent!';
        
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
        
		OrgWideEmailAddress[] addr = [SELECT Id, DisplayName FROM OrgWideEmailAddress WHERE DisplayName='First Responders Foundation' LIMIT 1];
        orgWideEmailId = addr[0].Id;
        System.debug('Overriding Org Wide Email address by - ' + addr[0].DisplayName + ', Id: ' + addr[0].Id);
        email.setorgWideEmailAddressId(orgWideEmailId);
        email.setTemplateId(templateId);
        email.setSaveAsActivity(saveAsActivity);      // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users
        
        System.debug(LoggingLevel.INFO,'** entered sendTemplatedEmail, to:' + toRecipients + ' cc:' + ccRecipients +  ' templateId:' + templateId + ' tagetObjId:' + targetObjId + 
                        ' whatId:' + whatId + ' orgWideEmailId: ' + orgWideEmailId);
        try {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            if(results[0].isSuccess())
                emailResult = 'Email Successfully Sent!';        
            else
                emailResult = 'Email Not Sent!';
            System.debug(emailResult);
            return emailResult;
        } catch (EmailException e) {
            System.debug('sendTemplatedEmail error. ' + e.getMessage());
            return emailResult;
        } 
    }    
}

/*Opportunity
List<String> toRecipients=new List<String>{'vikashkumar@unomaha.edu'};
List<String> ccRecipients=new List<String>{'im.kumarvikash@gmail.com'};
String templateApiName='Payment_Acknowledgement';
Id targetObjId='0034F000005m5kAQAQ';
Id whatId='0064F000002gIbYQAU';
Id orgWideEmailId='0D24F000000CaazSAC';
Boolean saveAsActivity=TRUE;
vik_SendTemplateEmail.sendTemplatedEmail(toRecipients, ccRecipients, templateApiName, targetObjId, whatId, orgWideEmailId, saveAsActivity);
 */
/*IATS TRANSACTION
List<String> toRecipients=new List<String>{'vikashkumar@unomaha.edu'};
List<String> ccRecipients=new List<String>{'im.kumarvikash@gmail.com'};
String templateApiName='Transaction_Acknowledgement';
Id targetObjId='0034F000005m5kAQAQ';
Id whatId='a0r4F000000DPztQAG';
Id orgWideEmailId='0D24F000000CaazSAC';
Boolean saveAsActivity=FALSE;
vik_SendTemplateEmail.sendTemplatedEmail(toRecipients, ccRecipients, templateApiName, targetObjId, whatId, orgWideEmailId, saveAsActivity);
 */