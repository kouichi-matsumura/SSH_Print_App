import UIKit

class FileViewerVC: UITableViewController {
    var fileNames = Array<String>()
    var currentCell :UITableViewCell?
    var addedFileName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onFileChanged(notification:)), name: .notifyName, object: nil)
        tableView.tableFooterView = UIView()
        let documentsPath = NSHomeDirectory() + "/Documents/SshPrint"
        let flag = FileManager.default.fileExists(atPath: documentsPath)
        if (!flag) {
            try? FileManager.default.createDirectory(atPath: documentsPath, withIntermediateDirectories: false)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let documentsPath = NSHomeDirectory() + "/Documents/SshPrint"
        fileNames = (try? FileManager.default.contentsOfDirectory(atPath: documentsPath)) ?? Array<String>()
        fileNames.sort { $0 < $1 }
        let count = fileNames.count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = fileNames[indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.systemBlue
        cell.selectedBackgroundView = backgroundView
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCell = (self.view as! UITableView).cellForRow(at: indexPath)
        performSegue(withIdentifier: "toDocumentView",sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        (segue.destination as! DocumentVC).navigationItem.title = currentCell?.textLabel?.text
        if let it = currentCell?.textLabel?.text {
            (segue.destination as! DocumentVC).pdfPath = NSHomeDirectory() + "/Documents/SshPrint/" + it
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let documentsPath = NSHomeDirectory() + "/Documents/SshPrint/"
            do {
                try FileManager.default.removeItem(atPath: documentsPath + fileNames[indexPath.row])
            } catch {
                print(error)
            }
            fileNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }

    @objc func onFileChanged(notification: Notification) {
        let addedFilePath = notification.userInfo?["filePath"] as? URL
        if let it = addedFilePath {
            let destinationPath = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/SshPrint/").appendingPathComponent(it.lastPathComponent)
            if (FileManager.default.fileExists(atPath: destinationPath!.path) ) {
                let alert: UIAlertController = UIAlertController(title: "アラート表示", message: "\(it.lastPathComponent) を上書き保存しますか？", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    do {
                        try FileManager.default.removeItem(at: destinationPath!)
                        print("copy to")
                        print(destinationPath!)
                        try FileManager.default.copyItem(at: it, to: destinationPath!)
                        self.addedFileName = it.lastPathComponent

                        (self.view as! UITableView).reloadData()
                        if let it = self.addedFileName {
                            for cell in (self.view as! UITableView).visibleCells {
                                if (cell.textLabel?.text == it) {
                                    cell.setSelected(true, animated: true)
                                }
                            }
                        }
                    }catch {
                        self.addedFileName = nil
                        print("ファイルのコピーが失敗")
                    }
                })
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                    print("Cancel")
                })
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                self.present(alert, animated: true)
            }
            else {
                do {
                    try FileManager.default.copyItem(at: it as URL, to: destinationPath!)
                    print("copy to")
                    print(destinationPath!)
                    addedFileName = it.lastPathComponent
                }catch {
                    addedFileName = nil
                    print("ファイルのコピーが失敗")
                }
            }
        }
        (self.view as! UITableView).reloadData()
        if let it = addedFileName {
            for cell in (self.view as! UITableView).visibleCells {
                if (cell.textLabel?.text == it) {
                    cell.setSelected(true, animated: true)
                }
            }
        }
    }

}
