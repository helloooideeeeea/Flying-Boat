import AppKit

class StatusBarController:NSViewController {

    @IBOutlet weak var accessKeyInput: NSTextField!
    @IBOutlet weak var secretKeyInput: NSSecureTextField!
    @IBAction func authSubmited(_ sender: Any) {
        let key = accessKeyInput.stringValue
        let pass = secretKeyInput.stringValue
        
        UserDefaults.standard.set(["key":key, "securet":pass], forKey: "keyPass")
        
        // 一番手前に持ってくる
        if let window = NSApplication.shared.mainWindow {
            window.orderFrontRegardless()
        }
        
        NotificationCenter.default.post(name: .StatusBarNotification, object: nil)
    }
    
    override func viewDidLoad() {
    }
    
    static func freshController() -> StatusBarController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("StatusBarController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? StatusBarController else {
            fatalError("StatusBarController is not found in Main.storyboard")
        }
      return viewcontroller
    }
    
}


