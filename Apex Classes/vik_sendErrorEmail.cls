public class vik_sendErrorEmail {
    public static String sendError(String errorMessage){
        
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
            sentStatus = 'Email Successfully Sent!';
            System.debug('The email was sent successfully.');
        } else {
            sentStatus = 'Email Not Sent!';
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        return sentStatus;
    }
}