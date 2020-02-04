import UIKit
import PDFKit

class DocumentVC: UIViewController
{
    public var pdfPath: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let pdfView = PDFView(frame: view.frame)
        let encodedPath = "file://" + pdfPath!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "/"
        let url = URL(string: encodedPath)
        if (url != nil) {
            let document = PDFDocument(url: url!)
            pdfView.document = document
            pdfView.backgroundColor = .lightGray
            pdfView.autoScales = true
            pdfView.displayMode = .singlePageContinuous
            view.addSubview(pdfView)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        ((segue.destination as! UINavigationController).topViewController as? DebugVC)?.pdfPath = self.pdfPath
    }
    @IBAction func onPrintButton(_ sender: Any) {
        if (!LoginData.instance.isLogined) {
            self.performSegue(withIdentifier: "toLoginView", sender: nil)
        } else {
            self.performSegue(withIdentifier: "toPrintView", sender: nil)
        }
    }
}
