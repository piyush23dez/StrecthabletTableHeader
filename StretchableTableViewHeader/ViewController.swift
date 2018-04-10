

import UIKit

class ViewController: UIViewController {
    
    var previousScrollOffset: CGFloat = 0
    @IBOutlet weak var headerBlurImageView: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profile: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 0
        headerBlurImageView.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        switch indexPath.row % 2 {
        case 0:
            cell.contentView.backgroundColor = UIColor.red
        default:
            break
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity

        if offset < 0 {
            
            let headerScaleFactor = -(offset) / profile.bounds.height
            let headerSizevariation = ((profile.bounds.height * (1.0 + headerScaleFactor)) - profile.bounds.height) / 2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
        } else {
            
            let statuBarHeight: CGFloat = 20.0
            let navBarHeight: CGFloat = 44.0
            let stopOffset = -profile.bounds.size.height+statuBarHeight+navBarHeight
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(stopOffset , -offset), 0)
            var percent = offset / profile.bounds.size.height // 0 to 1
            if percent > 1 {
                percent = 1
                headerBlurImageView?.alpha = percent
            } else {
                headerBlurImageView?.alpha = percent
            }
    
            
            if offset <= -stopOffset {
                profile.layer.zPosition = 2
            }
        }
        
        profile.layer.transform = headerTransform
    }
}


func isVisible(view: UIView) -> Bool {
    func isVisible(view: UIView, inView: UIView?) -> Bool {
        guard let inView = inView else { return true }
        let viewFrame = inView.convert(view.bounds, from: view)
        if viewFrame.intersects(inView.bounds) {
            return isVisible(view: view, inView: inView.superview)
        }
        return false
    }
    return isVisible(view: view, inView: view.superview)
}
