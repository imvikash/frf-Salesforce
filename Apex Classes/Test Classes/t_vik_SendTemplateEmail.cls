@isTest
public class t_vik_SendTemplateEmail {
    @isTest static void testTemplateEmail(){
        List<String> toAddress=new List<String>{'im.kumarvikash@gmail.com'};
        List<String> cCAddress=new List<String>{'vikashkumar@unomaha.edu'};
        
            //String templateApiName, ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity
        String emailResult = vik_SendTemplateEmail.sendTemplatedEmail(toAddress, cCAddress, 'Customer_Summary_Email_Body', 
                                                  '0034F000007OEOxQAO', null, '0D24F000000CaazSAC', False);
        //System.assertEquals('Email Successfully Sent!', emailResult);
    }
    @isTest static void testSingleEmail(){
        List<String> to=new List<String>{'im.kumarvikash@gmail.com'};
        List<String> cc=new List<String>{'vikashkumar@unomaha.edu'};
		String emailResult = vik_SingleEmailMessage.sendPlainEmail(to, cc, 'Yo', 'Man!') ;
        System.assertEquals('Email Successfully Sent!', emailResult);
    }
    @isTest static void testErrorEmail(){
        String emailResult = vik_sendErrorEmail.sendError('Error Error!');
        System.assertEquals('Email Successfully Sent!', emailResult);
    }
}