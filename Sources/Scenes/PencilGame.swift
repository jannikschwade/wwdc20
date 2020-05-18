import Foundation
import UIKit
import SpriteKit

/**
 A fun little scene to show the user the fundamental problem color blind people are facing.
 */
public class PencilGame: LoadableScene {
    
    /// Round number of the game
    var round = 0
    
    /// Right answer for every round
    let roundRightAnswers = [1: UIColor.red,
                             2: UIColor.yellow,
                             3: UIColor.yellow]
    
    /// Colors of the pencils on each round
    let roundColors = [1: [UIColor.red, UIColor.green],
                       2: [UIColor.green, UIColor.yellow],
                       3: [UIColor.green, UIColor.green]]
    
    /// Texts to be displayed in each round
    let roundTexts = [1: "In the first round, we are searching for the red pencil.",
                      2: "Nice! Now in the second round, we're searching the color yellow!",
                      3: "Easy! But how about now selecting the yellow one? Imagine you see the world like me and have difficulties distinguishing yellow from green (e.g. when buying bananas: are they ripe?)"]
    
    /// Text label for the searched color of each round
    var searchFor = SKLabelNode(fontNamed: Utils.textFont)
    
    /// First pencil of the scene
    var pencilTop = SKSpriteNode(imageNamed: "images/pencil.png")
    
    /// Second pencil of the scene
    var pencilBottom = SKSpriteNode(imageNamed: "images/pencil.png")
    
    public override func didMove(to view: SKView) {
        
        //Setting up the scene
        clearScene()
        
        self.backgroundColor = .white
        colorTheme = UIColor.CustomColor.primaryBlue
        
        //Add the content to the scene
        let taskTitle = SKLabelNode(fontNamed: Utils.titleFont)
        taskTitle.text = "The Pencil Game"
        taskTitle.horizontalAlignmentMode = .left
        let textHeight = taskTitle.frame.maxY - taskTitle.frame.minY
        taskTitle.position = CGPoint(x: CGFloat(Utils.outerMargin), y: self.size.height - textHeight - 50)
        
        let textBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: taskTitle.frame.maxX + CGFloat(Utils.outerMargin), height: frame.height - taskTitle.position.y + 15))
        textBackground.position = CGPoint(x: 0, y: taskTitle.position.y - 15)
        textBackground.lineWidth = 0
        textBackground.fillColor = colorTheme
        
        let textBackground2 = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width - textBackground.frame.width, height: frame.height - taskTitle.frame.maxY))
        textBackground2.position = CGPoint(x: textBackground.frame.maxX, y: taskTitle.frame.maxY)
        textBackground2.lineWidth = 0
        textBackground2.fillColor = colorTheme
        
        addChild(textBackground)
        addChild(textBackground2)
        addChild(taskTitle)
        
        let explanation = SKLabelNode(fontNamed: Utils.textFont)
        explanation.text = "Growing up with and telling people about my color blindness resulted in some funny situations. In school kids always showed me pencils and asked me about their colors. Let's play this game together today!"
        explanation.fontSize = 18
        explanation.fontColor = .black
        explanation.numberOfLines = 0
        explanation.lineBreakMode = .byWordWrapping
        explanation.preferredMaxLayoutWidth = size.width - CGFloat(2 * Utils.outerMargin)
        explanation.horizontalAlignmentMode = .left
        explanation.position = CGPoint(x: CGFloat(Utils.outerMargin), y: textBackground.position.y - explanation.frame.height - CGFloat(Utils.verticalMargin))
        addChild(explanation)
        
        //Add game elements
        searchFor.fontSize = 18
        searchFor.fontColor = .black
        searchFor.numberOfLines = 0
        searchFor.lineBreakMode = .byWordWrapping
        searchFor.preferredMaxLayoutWidth = size.width - CGFloat(2 * Utils.outerMargin)
        searchFor.horizontalAlignmentMode = .left
        searchFor.position = CGPoint(x: CGFloat(Utils.outerMargin), y: 280)
        addChild(searchFor)
        
        pencilTop.scale(to: CGSize(width: pencilTop.size.width/2, height: pencilTop.size.height/2))
        pencilTop.anchorPoint = CGPoint(x: 0, y: 0)
        pencilTop.position = CGPoint(x: (frame.width / 2) - (pencilTop.frame.width / 2), y: 200)
        
        pencilBottom.scale(to: CGSize(width: pencilBottom.size.width/2, height: pencilBottom.size.height/2))
        pencilBottom.anchorPoint = CGPoint(x: 0, y: 0)
        pencilBottom.position = CGPoint(x: (frame.width / 2) - (pencilBottom.frame.width / 2), y: 120)
        
        addChild(pencilTop)
        addChild(pencilBottom)
        
        let footerBanner = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: 10))
        footerBanner.position = CGPoint(x: 0, y: 0)
        footerBanner.lineWidth = 0
        footerBanner.fillColor = colorTheme
        
        addChild(footerBanner)
        
        //Add the navigation to the scene
        setupNavigation(elementColor: .black)
        
        //Start the game by switching in the first round
        nextRound()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        let touchedNodes = nodes(at: location)
        for touchedNode in touchedNodes {
            
            if !(touchedNode is SKSpriteNode) {
                //only affect pencils
                continue
            }
            
            if !touchedNode.hasActions(){
                let spriteNode = touchedNode as! SKSpriteNode
                
                if(spriteNode.name == "@next"){
                    SceneManager.nextScene(current: self)
                } else if (spriteNode.name == "@prev"){
                    SceneManager.prevScene(current: self)
                } else {
                    //is pencil
                    if(spriteNode.color == roundRightAnswers[round]) {
                        let particleEmitter = SKEmitterNode(fileNamed: "particles/Success.sks")!
                        particleEmitter.particleTexture = SKTexture(imageNamed: "particles/checkmark.png")
                        particleEmitter.position = CGPoint(x: touchedNode.position.x + touchedNode.frame.width/2, y: touchedNode.position.y + touchedNode.frame.height/2)
                        particleEmitter.run(SKAction.playSoundFileNamed("/sounds/yes.mp3", waitForCompletion: false))
                        addChild(particleEmitter)
                        
                        nextRound()
                    } else {
                        spriteNode.run(SKAction.playSoundFileNamed("/sounds/nope.mp3", waitForCompletion: false))
                    }
                }
            }
        }
    }
    
    /**
     Method to clear all elements containing the scene and restarting on first round.
     
     Used for resetting a scene.
     */
    public override func clearScene() {
        super.clearScene()
        searchFor = SKLabelNode(fontNamed: Utils.textFont)
        pencilTop = SKSpriteNode(imageNamed: "images/pencil.png")
        pencilBottom = SKSpriteNode(imageNamed: "images/pencil.png")
        round = 0
    }
    
    /**
     Change into the next round and load new pencils and explenation text.
     */
    func nextRound(){
        
        round += 1
        
        if(roundColors[round] != nil){
            
            searchFor.text = roundTexts[round]
            
            pencilTop.color = roundColors[round]![0]
            pencilTop.colorBlendFactor = 0.7
            
            pencilBottom.color = roundColors[round]![1]
            pencilBottom.colorBlendFactor = 0.7
        }
        
        if(round == roundColors.count){
            addNextPagePointer()
        }
    }
}
