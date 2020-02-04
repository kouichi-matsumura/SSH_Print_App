import UIKit
import Shout

class DebugVC: UIViewController {
    public var pdfPath: String?
    //let tableView = UITableView()
    @IBOutlet weak var idTextField :UITextField!
    @IBOutlet weak var domainTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    //let stackView = UIStackView()
    @IBOutlet weak var commandTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (LoginData.instance.isLogined) {
            self.dismiss(animated: true, completion: nil)
        }
        passTextField.isSecureTextEntry = true
        commandTextField.keyboardType = .alphabet
        do {
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            toolBar.barStyle = UIBarStyle.default
            toolBar.sizeToFit()
            let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
            let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(DebugVC.commitButtonTapped))
            toolBar.items = [spacer, commitButton]
            idTextField.inputAccessoryView = toolBar
            passTextField.inputAccessoryView = toolBar
            commandTextField.inputAccessoryView = toolBar
            
            self.view.backgroundColor = UIColor.white
        }
        //print(pdfPath)
        // 背景色を変更
        self.view.backgroundColor = UIColor.white
    }
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    @IBAction func submitButton(_ sender: Any) {
        do {
            let ssh = try SSH(host: domainTextField.text!)
            try ssh.authenticate(username: idTextField.text! , password: passTextField.text!)
            LoginData.instance.id = idTextField.text
            LoginData.instance.password = passTextField.text
            LoginData.instance.server = domainTextField.text
            LoginData.instance.isLogined = true
            try ssh.execute("mkdir .print_temp")
            let res = try ssh.capture("cd .print_temp && ls")
            print(res.output)
            self.textView.text = res.output
            let encodedPath = "file://" + pdfPath!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "/"
            let sftp = try ssh.openSftp()
            let encodedFileName = URL(string: encodedPath)!.lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            try sftp.upload(localURL: URL(string: encodedPath)!, remotePath: (".print_temp/" + encodedFileName))
            print(URL(string: encodedPath)!.lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            print(try ssh.capture("lpstat -p"))
            print(try ssh.capture("cd .print_temp && ls \(encodedFileName)"))
        }
        catch {
            print(error)
        }
    }
    @IBAction func OnCommandButton(_ sender: Any) {
        do {
            let ssh = try SSH(host: domainTextField.text!)
            try ssh.authenticate(username: idTextField.text! , password: passTextField.text!)
            print(try ssh.capture(commandTextField.text!))
            self.textView.text = try ssh.capture(commandTextField.text!).output
        }
        catch {
            print(error)
        }
    }
    @IBAction func onCompleteButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
