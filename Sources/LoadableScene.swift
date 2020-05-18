import Foundation
import SpriteKit

/**
 Contains basic functions for scenes of my playground.
 */
public class LoadableScene: SKScene {
    
    /// The color tone for the scenes background and highlights
    public var colorTheme: UIColor = .black
    
    /// True, when a "next page pointer" is currently active
    var hasNextPagePointer = false
    
    required public override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public override init(size: CGSize) {
        super.init(size: size)
    }
    
    /**
     Method to clear all elements containing the scene.
     
     Used for resetting a scene.
     */
    public func clearScene(){
        if( view != nil ) {
            for subview in view!.subviews {
                subview.removeFromSuperview()
            }
        }
        
        removeAllChildren()
        
        hasNextPagePointer = false
    }
    
    /**
     Adds the navigation to the scene in the bottom right corner of the scene.
     
     - Parameter elementColor: The color of the navigation elements
     
     `elementColor` should be white when the background is colored and black if the background is white.
     */
    public func setupNavigation(elementColor: UIColor){
        let pageCounter = SKLabelNode(fontNamed: Utils.navigationFont)
        pageCounter.text = "\(SceneManager.position(of: self) + 1)/\(SceneManager.totalScenes)"
        pageCounter.fontSize = 24
        pageCounter.fontColor = elementColor
        pageCounter.horizontalAlignmentMode = .left
        
        let arrowNext = SKSpriteNode(imageNamed: "images/nav-arrow-next.png")
        arrowNext.name = "@next"
        arrowNext.color = elementColor
        arrowNext.colorBlendFactor = 1
        arrowNext.alpha = SceneManager.hasNext(current: self) ? 1 : 0.2
        arrowNext.scale(to: CGSize(width: pageCounter.frame.height, height: pageCounter.frame.height))
        arrowNext.anchorPoint = CGPoint(x: 0, y: 0)
        
        let arrowPrev = SKSpriteNode(imageNamed: "images/nav-arrow-prev.png")
        arrowPrev.name = "@prev"
        arrowPrev.color = elementColor
        arrowPrev.colorBlendFactor = 1
        arrowPrev.alpha = SceneManager.hasPrev(current: self) ? 1 : 0.2
        arrowPrev.scale(to: CGSize(width: pageCounter.frame.height, height: pageCounter.frame.height))
        arrowPrev.anchorPoint = CGPoint(x: 0, y: 0)
        
        arrowNext.position = CGPoint(x: frame.width - arrowNext.frame.width - 20, y: 20)
        pageCounter.position = CGPoint(x: arrowNext.position.x - pageCounter.frame.width - 10, y: 22)
        arrowPrev.position = CGPoint(x: pageCounter.position.x - arrowPrev.frame.width - 10, y: 20)
        
        addChild(arrowNext)
        addChild(pageCounter)
        addChild(arrowPrev)
    }
    
    /**
     Adds a visual pointer onto the "next" button to signalize that the user can continue.
     */
    func addNextPagePointer(){
        
        if(hasNextPagePointer){
            return
        }
        
        let nextPagePointer = SKSpriteNode(imageNamed: "images/nav-arrow-next.png")
        nextPagePointer.color = .gray
        nextPagePointer.colorBlendFactor = 1
        nextPagePointer.zRotation = 1.5 * .pi
        nextPagePointer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        nextPagePointer.scale(to: CGSize(width: 20, height: 20))
        nextPagePointer.position = CGPoint(x: frame.width - nextPagePointer.frame.width/2 - 20, y: 60)
        
        let pulseUp = SKAction.scale(by: 1.3, duration: 0.5)
        let pulseDown = SKAction.scale(by: 1/1.3, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        nextPagePointer.run(SKAction.repeatForever(pulse))
        
        addChild(nextPagePointer)
        hasNextPagePointer = true
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        let touchedNodes = nodes(at: location)
        for touchedNode in touchedNodes {
            
            if !(touchedNode is SKSpriteNode) {
                continue
            }
            
            if !touchedNode.hasActions(){
                let spriteNode = touchedNode as! SKSpriteNode
                
                if(spriteNode.name == "@next"){
                    SceneManager.nextScene(current: self)
                } else if (spriteNode.name == "@prev"){
                    SceneManager.prevScene(current: self)
                }
            }
        }
    }
}

/**
 A specific type of a `LoadableScene` which deals with easily setting up a introduction scene to a topic
 */
public class TopicScene: LoadableScene {
    
    /// Height of the colored background.
    public let backgroundHeight = 361
    
    /**
     Adds all text elements (including colored background) on to the screne.
     - Parameter title: The title to be displayed
     - Parameter description: Long text positioned on the colored background
     */
    public func setupText(title: String, description: String){
        let textBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat(backgroundHeight)))
        textBackground.lineWidth = 0
        textBackground.fillColor = colorTheme
        
        addChild(textBackground)
        
        let titleText = SKLabelNode(fontNamed: Utils.titleFont)
        titleText.text = title
        titleText.fontSize = 72
        titleText.fontColor = colorTheme
        titleText.horizontalAlignmentMode = .left
        titleText.position = CGPoint(x: CGFloat(Utils.outerMargin), y: textBackground.frame.maxY + CGFloat(Utils.verticalMargin))
        
        addChild(titleText)
        
        let descriptionText = SKLabelNode(fontNamed: Utils.textFont)
        descriptionText.text = description
        descriptionText.fontSize = 24
        descriptionText.fontColor = .white
        descriptionText.numberOfLines = 0
        descriptionText.lineBreakMode = .byWordWrapping
        descriptionText.preferredMaxLayoutWidth = size.width - CGFloat(2 * Utils.outerMargin)
        descriptionText.horizontalAlignmentMode = .left
        descriptionText.position = CGPoint(x: CGFloat(Utils.outerMargin), y: textBackground.frame.height - descriptionText.frame.height - CGFloat(Utils.verticalMargin))
        
        addChild(descriptionText)
    }    
}
