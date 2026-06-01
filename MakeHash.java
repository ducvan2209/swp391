import org.mindrot.jbcrypt.BCrypt;

public class MakeHash {
    public static void main(String[] args) {
        System.out.println(BCrypt.hashpw("123456", BCrypt.gensalt(12)));
    }
}
