public class vik_ResendOpportunityAck {
    
    private Opportunity opp{get; set;}
      
    public vik_ResendOpportunityAck(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
    }
	
    public PageReference resendAcknowledgement(){
        System.debug('Action Initiated - Resend Acknowledgement to Opportunty Id- ' + opp.Id);
        
        //Get Primary Contact Email        
        Contact[] con = [SELECT Id, Email FROM Contact WHERE Id IN (
							SELECT npsp__Primary_Contact__c FROM Opportunity WHERE Id=:opp.Id)];
        if(con.isEmpty()){
            System.debug('No Contact for the Opportunity. Cannot send an email');
        }
        List<String> toRecipients=new List<String>{con[0].Email};
        System.debug('Contact Found- ' + con[0].Email);
        List<String> ccRecipients=new List<String>{'im.kumarvikash@gmail.com'};
            
        String templateApiName='Payment_Acknowledgement';
        Id targetObjId=con[0].Id;
        Id whatId=opp.Id;
        Id orgWideEmailId='0D24F000000CaazSAC';
        Boolean saveAsActivity=TRUE;
        String emailResult = vik_SendTemplateEmail.sendTemplatedEmail(toRecipients, null, templateApiName, targetObjId, whatId, orgWideEmailId, saveAsActivity);
        System.debug(LoggingLevel.INFO,'** entered PostedOppTrigger, to:' + toRecipients + ' cc:' + ccRecipients +  ' templateAPI:' + templateApiName + ' tagetObjId:' + targetObjId + 
                        ' whatId:' + whatId + ' orgWideEmailId: ' + orgWideEmailId);
        
        //Opportunity opp = [SELECT Id FROM Opportunity WHERE Id=:oppId];
        if(emailResult.equalsIgnoreCase('Email Successfully Sent!')){
            //Update Acknowledgement Date and Status
            opp.npsp__Acknowledgment_Status__c = 'Acknowledged';
            opp.npsp__Acknowledgment_Date__c = Date.today();
        }
        else{
            //Update Acknowledgement Status
            opp.npsp__Acknowledgment_Status__c = 'Email Acknowledgment Not Sent';
        }
        upsert(opp);
        System.debug('Opportunity Acknowledgement Status updated. Redirecting...');
        PageReference pageRef = new PageReference('/'+opp.Id);
        pageRef.setRedirect(true);
		return pageRef;
    }
}

/*    public String oppId{
        get{
            System.debug('Getting Opportunity ID from URL');
            if(oppId == null &&
               ApexPages.currentPage().getParameters().get('id') != null){
                   oppId = ApexPages.currentPage().getParameters().get('id');
               }
            System.debug('Fetched Opportunity ID - ' + oppId);
            return oppId;
        }
        set;
    }
*/