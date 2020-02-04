import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(false, forKey: "launchedBefore")
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if(!launchedBefore) {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            if let sampleFilePath = Bundle.main.url(forResource: "さんぷる", withExtension: "pdf") {
                print("さんぷる")
                print(sampleFilePath)
                let destinationPath = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/SshPrint/").appendingPathComponent(sampleFilePath.lastPathComponent)
                do {
                    try FileManager.default.copyItem(at: sampleFilePath as URL, to: destinationPath!)
                    print("copy to")
                    print(destinationPath!)
                }catch {
                    print("ファイルのコピーが失敗")
                }
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        window.rootViewController = SplashVC()
        window.makeKeyAndVisible()
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: .notifyName, object: nil, userInfo: ["filePath":url])
        return true
    }
}

extension Notification.Name {
    static let notifyName = Notification.Name("OnOpenWithURL")
}

