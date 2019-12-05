//
//  SceneDelegate.swift
//  Api_RickMorty
//
//  Created by francisco.adan on 04/12/2019.
//  Copyright © 2019 francisco.adan. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url {
            let  message = url.host?.removingPercentEncoding
            if message != nil {
                
                let urlString = "\(AppData.Domains.url)\(message!)"
                guard let url = URL(string: urlString) else { return }
                
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    guard let data = data else { return }

                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        Character.id = "\(json["id"]!)"
                        Character.urlImage = json["image"] as! String
                        Character.name = json["name"] as! String
                        Character.specie = json["species"] as! String
                        Character.status = json["status"] as! String
                        Character.genre = json["gender"] as! String
                        let origin = json["origin"] as! [String:Any]
                        Character.origin = origin["name"] as! String
                        let location = json["location"] as! [String:Any]
                        Character.location = location["name"] as! String
                        Character.episodes = json["episode"] as! [String]
                        
                        DispatchQueue.main.async {
                        
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let page = mainStoryboard.instantiateViewController(withIdentifier: "cvc") as! CharacterViewController
                            let rootViewController = self.window!.rootViewController as! UINavigationController
                            rootViewController.pushViewController(page, animated: true)
                        }
                        
                    } catch let jsonError {
                        print(jsonError)
                    }

                }.resume()
                
            }
        }
    }
}
