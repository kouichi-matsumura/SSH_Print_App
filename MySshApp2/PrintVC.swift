import UIKit
import Shout

class PrintVC: UIViewController {
    @IBOutlet weak var commandTextField: UITextField!
    @IBOutlet weak var outputTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func onCompleteButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onSubmitButton(_ sender: Any) {
        do {
            let ssh = try SSH(host: LoginData.instance.server!)
            try ssh.authenticate(username: LoginData.instance.id! , password: LoginData.instance.password!)
            print(try ssh.capture(commandTextField.text!))
            self.outputTextView.text = try ssh.capture(commandTextField.text!).output
        }
        catch {
            print(error)
        }
    }
}
