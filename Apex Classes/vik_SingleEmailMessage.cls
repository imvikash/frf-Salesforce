public class vik_SingleEmailMessage {
    
    public static String sendPlainEmail(String[] toAddresses, String[] ccAddresses, String subject, String plainBody){
        
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
            sentStatus = 'Email Successfully Sent!';
            System.debug('The email was sent successfully.');
        } else {
            sentStatus = 'Email Not Sent!';
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        return sentStatus;
    }
}