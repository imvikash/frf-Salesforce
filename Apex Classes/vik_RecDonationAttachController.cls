/*
 * Controller for the pdf attachment - vik_RecDonationListAttach.vfp
 */
public class vik_RecDonationAttachController {
	
    public String recurringDonationId{
        get{
            System.debug('Get Recurring Donation ID');
            if(recurringDonationId == null &&
               ApexPages.currentPage().getParameters().get('id') != null){
                   recurringDonationId = ApexPages.currentPage().getParameters().get('id');
                   //recurringDonationId = 'a094F000000Fhw2QAC';
               }
            System.debug('Fetched Recurring Donation ID: ' + recurringDonationId);
            return recurringDonationId;
        }
        set;
    }
    
    public npe03__Recurring_Donation__c recurringDonation{
        get{
            System.debug('QUERY >>>> SELECT npe03__Donor_Name__c, npe03__Installment_Period__c, npe03__Installments__c, npe03__Paid_Amount__c, npe03__Next_Payment_Date__c FROM npe03__Recurring_Donation__c WHERE Id=' + recurringDonationId);
            return [SELECT npe03__Donor_Name__c, npe03__Installment_Period__c, npe03__Installments__c, npe03__Paid_Amount__c, npe03__Next_Payment_Date__c
					FROM npe03__Recurring_Donation__c
					WHERE Id=:recurringDonationId];
        }
        set;
    }
    
    public List<Opportunity> opps{
        get{
            System.debug('QUERY >>>> SELECT CloseDate, npsp__Recurring_Donation_Installment_Name__c, Amount, StageName FROM Opportunity WHERE npe03__Recurring_Donation__c=' + recurringDonationId + 'LIMIT 9');
            return [SELECT CloseDate, npsp__Recurring_Donation_Installment_Name__c, Amount, StageName
						FROM Opportunity
						WHERE npe03__Recurring_Donation__c=:recurringDonationId];
        }
    }
}