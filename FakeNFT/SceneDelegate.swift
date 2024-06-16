import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let tabBarController = TabBarController(servicesAssembly: servicesAssembly)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func addBlurEffectToWindow() {
        guard let window = window else { return }
        blurEffectView.frame = window.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        window.addSubview(blurEffectView)
        UIView.animate(withDuration: 1.0) {
            self.blurEffectView.effect = UIBlurEffect(style: .light)
        }
    }
    
    func removeBlurEffectToWindow() {
        blurEffectView.removeFromSuperview()
        UIView.animate(withDuration: 1.0) {
            self.blurEffectView.effect = UIBlurEffect(style: .light)
        }
    }
}
