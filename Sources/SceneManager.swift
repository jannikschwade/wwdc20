import Foundation
import SpriteKit
import PlaygroundSupport

/**
 Class to manage creating and navigating through scenes in the playground.
 */
public class SceneManager {
    
    public struct Settings {
        /**
         Whether the pencil scene should be included in the playground.
         
        Due to the 3-minutes time constraint this scene is deactivated by default.
         */
        public static var enablePencilScene = false
    }
    
    /// The overall sceneView which is presented to the playground.
    private static let sceneView = SKView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 748, height: 562)))
    
    public init() {}
    
    /**
     Array holding all instances of scenes for the playground
     
     The ordering in the array will determ in which order scenes will be displayed later on. **Due to time constraints the scene PencilGame will not be content of my final playground submission but can be manually added by deleting the comment.**
     */
    private static var scenes: [LoadableScene] = [WelcomeScene(),
                                                  BackgroundScene(),
                                                  ConeGame(),
                                                  FilterGame(),
                                                  TipsScene(),
                                                  TipsGame(),
                                                  EndScene()]
    
    /// Amount of scenes loaded in the playground
    public static let totalScenes = scenes.count
    
    /// Loads up and displays the first scene of the playground
    public static func start(){
                
        if(SceneManager.Settings.enablePencilScene) {
            scenes.insert(PencilGame(), at: 1)
        }
        
        let firstScene = scenes[0]
        
        firstScene.scaleMode = .resizeFill
        sceneView.presentScene(firstScene)
        
        PlaygroundPage.current.liveView = sceneView
    }
    
    /**
     Method to determ where the given scenes is located in the overall order of scenes.
     */
    public static func position(of: LoadableScene) -> Int{
        return scenes.firstIndex(where: {$0 === of}) ?? -1
    }
    
    /**
     Returns, whether there is a next scene coming up.
     */
    public static func hasNext(current: LoadableScene) -> Bool{
        return (0...totalScenes - 2).contains(position(of: current))
    }
    
    /**
     Returns, whether the scene has a predecessor scene.
     */
    public static func hasPrev(current: LoadableScene) -> Bool{
        return position(of: current) > 0
    }
    
    /**
     Switches to the current scene to next scene in the order, if there is one.
     - Parameter current: The current scene from where to transition to the next one
     */
    public static func nextScene<T: LoadableScene>(current: T){
        if(hasNext(current: current)){
            
            let currentPosition = position(of: current)
            
            //Reset scene
            //scenes[currentPosition] = T()
            let nextScene = scenes[currentPosition + 1]
            
            nextScene.scaleMode = .resizeFill
            sceneView.presentScene(nextScene)
        }
    }
    
    /**
     Switches to the current scene to previous scene in the order, if there is one.
     - Parameter current: The current scene from where to transition to the next one
     */
    public static func prevScene<T: LoadableScene>(current: T){
        if(hasPrev(current: current)){
            
            let currentPosition = position(of: current)
            
            //Reset scene
            //scenes[currentPosition] = T()
            let prevScene = scenes[currentPosition - 1]
            
            prevScene.scaleMode = .resizeFill
            sceneView.presentScene(prevScene)
        }
    }
}
