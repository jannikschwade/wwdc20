import Foundation
import UIKit
import SpriteKit

/**
 A scene to introduce the user to how the human retina is built and how protanopia is affecting it.
 */
public class ConeGame: LoadableScene {
    
    /// Array of all `SKSpriteNodes` build up
    var cellNodes: [SKSpriteNode] = []
    
    /// Wether the game is already solved
    var solved = false
    
    /// Label for the hint to be displayed
    let hint = SKLabelNode(fontNamed: Utils.commentFont)
    
    public override func didMove(to view: SKView) {
        
        //Setting up the scene
        clearScene()
        
        self.backgroundColor = .white
        colorTheme = UIColor.CustomColor.primaryGreen
        
        //Add the tet content to the scene
        let taskTitle = SKLabelNode(fontNamed: Utils.titleFont)
        taskTitle.text = "The Human Retina"
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
        explanation.text = "You've learned about Protanopia on the last page. Here you see the retina of a human eye. Can you simulate a Protanopians' eye by clicking on the correct cones and rods?"
        explanation.fontSize = 18
        explanation.fontColor = .black
        explanation.numberOfLines = 0
        explanation.lineBreakMode = .byWordWrapping
        explanation.preferredMaxLayoutWidth = size.width - CGFloat(2 * Utils.outerMargin)
        explanation.horizontalAlignmentMode = .left
        explanation.position = CGPoint(x: CGFloat(Utils.outerMargin), y: textBackground.position.y - explanation.frame.height - CGFloat(Utils.verticalMargin))
        addChild(explanation)
        
        //Add the interactive human eye model
        let cone = SKSpriteNode(imageNamed: "images/cone.png")
        let rod = SKSpriteNode(imageNamed: "images/rod.png")
        
        let totalCells = (Int(size.width) - 2 * Utils.outerMargin) / 30
        let totalConesPerColor = totalCells / 2 / 3
        let totalRods = totalCells - totalConesPerColor * 3
        
        //Add rods
        for _ in 1...totalRods {
            
            let image: SKSpriteNode
            image = rod.copy() as! SKSpriteNode
            image.color = .gray
            image.colorBlendFactor = 0.7
            
            image.scale(to: CGSize(width: image.size.width/4, height: image.size.height/4))
            image.anchorPoint = CGPoint(x: 0, y: 0)
            
            cellNodes.append(image)
        }
        
        //Add cones
        for color in [UIColor.red, UIColor.green, UIColor.blue] {
            for _ in 1...totalConesPerColor {
                
                let image: SKSpriteNode
                image = cone.copy() as! SKSpriteNode
                image.color = color
                image.colorBlendFactor = 0.7
                
                image.scale(to: CGSize(width: image.size.width/4, height: image.size.height/4))
                image.anchorPoint = CGPoint(x: 0, y: 0)
                
                cellNodes.append(image)
            }
        }
        
        cellNodes.shuffle()
        
        var xPos = Utils.outerMargin
        for cellNode in cellNodes {
            cellNode.position = CGPoint(x: xPos, y: 150)
            addChild(cellNode)
            
            xPos += 30
        }
        
        //Add reminder that it is a model
        var counter = 0
        for node in cellNodes.reversed() {
            if(node.texture!.description.contains("rod.png")){
                counter += 1
            }
            
            if(counter == 4){
                let comment = SKLabelNode(fontNamed: Utils.commentFont)
                comment.text = "'We look different in reality!'"
                comment.fontSize = 8
                comment.fontColor = .gray
                comment.horizontalAlignmentMode = .left
                comment.position = CGPoint(x: node.position.x + node.frame.width, y: node.position.y + node.frame.height + 10)
                addChild(comment)
                
                let commentLine = UIBezierPath()
                commentLine.move(to: CGPoint(x: node.position.x + node.frame.width / 2, y: node.position.y + node.frame.height + 2))
                commentLine.addLine(to: CGPoint(x: comment.position.x - 2, y: comment.position.y))
                let commentLineNode = SKShapeNode(path: commentLine.cgPath)
                commentLineNode.strokeColor = .lightGray
                addChild(commentLineNode)
                
                break
            }
        }
        
        //Add a hint to the scene
        hint.text = "Hint: Protanopia causes only the red cones to disfunction."
        hint.fontColor = colorTheme
        hint.fontSize = 14
        hint.numberOfLines = 0
        hint.lineBreakMode = .byWordWrapping
        hint.preferredMaxLayoutWidth = size.width - CGFloat(2 * Utils.outerMargin)
        hint.horizontalAlignmentMode = .left
        hint.position = CGPoint(x: CGFloat(Utils.outerMargin), y: 150 - hint.frame.height - 30)
        hint.alpha = 0
        
        addChild(hint)
        
        let hintLabel = SKLabelNode(fontNamed: Utils.commentFont)
        hintLabel.text = "Tap for a hint"
        hintLabel.name = "@hint"
        hintLabel.fontColor = colorTheme
        hintLabel.fontSize = 14
        hintLabel.position = CGPoint(x: CGFloat(Utils.outerMargin) + hintLabel.frame.width / 2, y: 26)
        hintLabel.alpha = 0
        
        let pulseUp = SKAction.scale(by: 1.1, duration: 0.5)
        let pulseDown = SKAction.scale(by: 1/1.1, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        hintLabel.run(SKAction.repeatForever(pulse))
        
        hintLabel.run(SKAction.sequence([
            SKAction.wait(forDuration: 5),
            SKAction.fadeIn(withDuration: 3)
        ]))
        
        addChild(hintLabel)
        
        //Add banner
        let footerBanner = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: 10))
        footerBanner.position = CGPoint(x: 0, y: 0)
        footerBanner.lineWidth = 0
        footerBanner.fillColor = colorTheme
        
        addChild(footerBanner)
        
        //Add the navigation to the scene
        setupNavigation(elementColor: .black)
    }
    
    /**
     Method to clear all elements containing the scene and resetting the build image of the human retina.
     
     Used for resetting a scene.
     */
    public override func clearScene() {
        super.clearScene()
        cellNodes = []
        solved = false
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
                if(touchedNode is SKLabelNode){
                    let labelNode = touchedNode as! SKLabelNode
                    if let name = labelNode.name {
                        if(name == "@hint"){
                            labelNode.run(SKAction.sequence([
                                SKAction.playSoundFileNamed("/sounds/plop.mp3", waitForCompletion: false),
                                SKAction.fadeAlpha(to: 0, duration: 0),
                            ]))
                            
                            hint.alpha = 1
                        }
                    }
                }
                
                continue
            }
            
            if !touchedNode.hasActions(){
                let spriteNode = touchedNode as! SKSpriteNode
                
                if(spriteNode.name == "@next"){
                    SceneManager.nextScene(current: self)
                } else if (spriteNode.name == "@prev"){
                    SceneManager.prevScene(current: self)
                } else {
                    
                    if(solved){
                        return
                    }
                    
                    let nodeIsActive = touchedNode.alpha == 1
                    if (nodeIsActive){
                        touchedNode.run(SKAction.sequence([
                            SKAction.playSoundFileNamed("/sounds/wush.mp3", waitForCompletion: false),
                            SKAction.fadeAlpha(to: 0.3, duration: 0.2),
                            SKAction.wait(forDuration: 0.1),
                            SKAction.run({
                                self.checkSolved()
                            })
                        ]))
                    } else {
                        touchedNode.run(SKAction.sequence([
                            SKAction.playSoundFileNamed("/sounds/plop.mp3", waitForCompletion: false),
                            SKAction.fadeAlpha(to: 1, duration: 0),
                            SKAction.wait(forDuration: 0.1),
                            SKAction.run({
                                self.checkSolved()
                            })
                        ]))
                    }
                }
            }
        }
    }
    
    /**
     Method to check if the task is completed and all red cones are deactivated.
     
     Plays a particle effect and sone on completing.
     */
    public func checkSolved() {
        for cellNode in cellNodes {
            
            if (cellNode.color == UIColor.red){
                if(cellNode.alpha == 1){
                    solved = false
                    return
                }
            } else {
                if(cellNode.alpha != 1){
                    solved = false
                    return
                }
            }
        }
        
        if(solved) {
            return
        }
        
        let particleEmitter = SKEmitterNode(fileNamed: "particles/Success.sks")!
        particleEmitter.particleTexture = SKTexture(imageNamed: "particles/checkmark.png")
        particleEmitter.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        particleEmitter.run(SKAction.playSoundFileNamed("/sounds/yes.mp3", waitForCompletion: false))
        addChild(particleEmitter)
        
        addNextPagePointer()
        solved = true
    }
}
