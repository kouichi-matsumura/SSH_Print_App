class LoginData {
    static let instance = LoginData()
    var id: String?
    var password: String?
    var server: String?
    var isLogined = false
    private init() {
    }
}
