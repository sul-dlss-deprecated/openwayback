package edu.stanford.dlss.contact;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailProcessor {


    public boolean sendEmail(String from, String subject, String body) {
    	if(!isValidEmail(from)){
    		from = "admin@wayback.stanford.edu";
    	}
        
        String to = "sul-was-support@lists.stanford.edu";

        // Assuming you are sending email from localhost
        String host = "localhost";

        // Get system properties
        Properties properties = System.getProperties();

        // Setup mail server
        properties.setProperty("mail.smtp.host", host);

        // Get the default Session object.
        Session session = Session.getDefaultInstance(properties);

        try{
           // Create a default MimeMessage object.
           MimeMessage message = new MimeMessage(session);

           // Set From: header field of the header.
           message.setFrom(new InternetAddress(from));

           // Set To: header field of the header.
           message.addRecipient(Message.RecipientType.TO,
                                    new InternetAddress(to));

           // Set Subject: header field
           message.setSubject(subject);

           // Now set the actual message
           message.setText(body);

           // Send message
           Transport.send(message);
           System.out.println("Sent message successfully....");
           return true;
        }catch (Exception mex) {
           mex.printStackTrace();
           return false;
        }
    	
    }
    
    private boolean isValidEmail(String emailAddress){
    	boolean isValid = false;
    	if(emailAddress != null && emailAddress.length() > 5){
			try {
				InternetAddress internetAddress = new InternetAddress(emailAddress);
				internetAddress.validate();
				isValid = true;
			} catch (AddressException e) {
				System.out.println("The from email is not valid " + emailAddress);
			}
		}
		return isValid;
    }
}