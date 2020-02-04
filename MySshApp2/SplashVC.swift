import UIKit
import SnapKit

class SplashVC: UIViewController {
    var fileViewerVC: UIViewController? = nil
    private lazy var splashImage: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(named: "Splash")
        )
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.frame
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        splashImage.isHidden = true
        view.addSubview(splashImage)
        splashImage.snp.makeConstraints{(make) in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        }
        splashImage.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(1)
        let storybord = UIStoryboard(name: "Debug2", bundle: nil)
        if let fileViewerVC = storybord.instantiateInitialViewController() {
            fileViewerVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            fileViewerVC.modalPresentationStyle = .fullScreen
            self.present(fileViewerVC,animated: true)
        }
    }
}
