package api;

import helper.AppConfig;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailUtil {

    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());

    private static Session buildMailSession() {
        final String fromEmail = AppConfig.get("mail.smtp.user", "");
        final String password = AppConfig.get("mail.smtp.password", "");

        Properties props = new Properties();
        props.put("mail.smtp.host", AppConfig.get("mail.smtp.host", "smtp.gmail.com"));
        props.put("mail.smtp.port", AppConfig.get("mail.smtp.port", "587"));
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });
    }

    public static void sendEmail(String toEmail, String subject, String messageText) throws MessagingException {
        final String fromEmail = AppConfig.get("mail.smtp.user", "");
        if (fromEmail.isEmpty()) {
            throw new MessagingException("mail.smtp.user is not configured in app.properties");
        }

        Session session = buildMailSession();
        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(fromEmail, false));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject);
        msg.setContent(messageText, "text/html; charset=utf-8");
        Transport.send(msg);
    }

    public static boolean isValidEmail(String email) {
        try {
            InternetAddress emailAddr = new InternetAddress(email);
            emailAddr.validate();
            return true;
        } catch (AddressException ex) {
            return false;
        }
    }

    public static void sendResetLink(String toEmail, String token) {
        try {
            String resetLink = AppConfig.getBaseUrl() + "/recovery?token=" + token;
            String subject = "HRM System - Password Reset";
            String content = "<p>You requested a password reset.</p>"
                    + "<p>Click <a href='" + resetLink + "'>here</a> to set a new password.</p>"
                    + "<p>This link expires in 24 hours.</p>";
            sendEmail(toEmail, subject, content);
        } catch (MessagingException ex) {
            LOGGER.log(Level.SEVERE, "Failed to send reset email", ex);
        }
    }

    public static void sendPasswordChangedNotification(String toEmail, String fullName) {
        try {
            String subject = "HRM System - Password Changed";
            String content = "<p>Hello " + (fullName == null ? "" : fullName) + ",</p>"
                    + "<p>Your account password was changed successfully.</p>"
                    + "<p>If you did not perform this action, contact your administrator immediately.</p>";
            sendEmail(toEmail, subject, content);
        } catch (MessagingException ex) {
            LOGGER.log(Level.WARNING, "Failed to send password change notification", ex);
        }
    }
}
