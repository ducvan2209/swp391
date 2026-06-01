package helper;

public final class PasswordValidator {

    private static final String PASSWORD_PATTERN =
            "^[A-Z].{6,}[!@#$%^&*()_+=\\-{}\\[\\]:;\"'<>,.?/~`]$";

    private PasswordValidator() {
    }

    public static boolean isStrong(String password) {
        return password != null
                && password.length() >= 8
                && password.matches(PASSWORD_PATTERN);
    }

    public static String strengthGuideline() {
        return "Password must be at least 8 characters, start with an uppercase letter, "
                + "and end with a special character.";
    }
}
