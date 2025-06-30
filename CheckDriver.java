public class CheckDriver {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver MySQL encontrado com sucesso!");
        } catch (ClassNotFoundException e) {
            System.err.println("Erro: Driver MySQL não encontrado. " + e.getMessage());
            e.printStackTrace();
        }
    }
}