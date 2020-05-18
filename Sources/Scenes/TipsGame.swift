import Foundation
import UIKit
import SpriteKit

/**
 A scene with the aim to provide the user with some ideas on how to enhance apps with thinking of color blind people.
 */
public class TipsGame: LoadableScene {
    
    public override func didMove(to view: SKView) {
        
        //Setting up the scene
        clearScene()
        
        self.backgroundColor = .white
        colorTheme = UIColor.CustomColor.primaryRed
        
        //Add the content to the scene
        let taskTitle = SKLabelNode(fontNamed: Utils.titleFont)
        taskTitle.text = "Remember This!"
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
        
        //Add left explenation pane
        let explanationLeft = SKLabelNode(fontNamed: Utils.textFont)
        explanationLeft.text = "1: Avoid similar colors and aim for a difference in brightness and saturation or use elements like names, accessories in games etc. to make them distinguishable."
        explanationLeft.fontSize = 18
        explanationLeft.fontColor = .black
        explanationLeft.numberOfLines = 0
        explanationLeft.lineBreakMode = .byWordWrapping
        explanationLeft.preferredMaxLayoutWidth = size.width / 2 - 1.5 * CGFloat(Utils.outerMargin)
        explanationLeft.horizontalAlignmentMode = .left
        explanationLeft.position = CGPoint(x: CGFloat(Utils.outerMargin), y: textBackground.position.y - explanationLeft.frame.height - CGFloat(Utils.verticalMargin))
        addChild(explanationLeft)
        
        let hint = SKLabelNode(fontNamed: Utils.commentFont)
        hint.text = "Notice how you can better differentiate the blobs by adding a name:"
        hint.fontColor = colorTheme
        hint.fontSize = 12
        hint.numberOfLines = 0
        hint.lineBreakMode = .byWordWrapping
        hint.horizontalAlignmentMode = .left
        hint.preferredMaxLayoutWidth = size.width / 2 - 1.5 * CGFloat(Utils.outerMargin)
        hint.position = CGPoint(x: CGFloat(Utils.outerMargin), y: explanationLeft.position.y - 40)
        
        addChild(hint)
        
        for blobNr in 1...2 {
            
            let blob = SKSpriteNode(imageNamed: "images/animation/blob-\(blobNr)-1.png")
            blob.texture!.filteringMode = .nearest
            blob.scale(to: CGSize(width: blob.size.width*6, height: blob.size.height*6))
            
            let positionOffset = CGFloat((blobNr - 1)) * (blob.frame.width) + 80
            blob.position = CGPoint(x: CGFloat(Utils.outerMargin) + positionOffset, y: 150)
            
            var textures: [SKTexture] = []
            
            for  i in 1...6 {
                let texture = SKTexture(imageNamed: "images/animation/blob-\(blobNr)-\(i).png")
                texture.filteringMode = .nearest
                textures.append(texture)
            }
            
            addChild(blob)
            
            blob.run(.sequence([
                SKAction.wait(forDuration: Double(blobNr-1) * 0.1),
                SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
            ]))
            
            let playerTag = SKLabelNode(fontNamed: Utils.textFont)
            playerTag.text = blobNr == 1 ? "Mary" : "Greg"
            playerTag.fontSize = 12
            playerTag.fontColor = .black
            playerTag.position = CGPoint(x: blob.position.x, y: blob.frame.maxY + 20)
            addChild(playerTag)
        }
        
        //Add right explenation pane
        let explanationRight = SKLabelNode(fontNamed: Utils.textFont)
        explanationRight.text = "2: Instead of just highlighting a word through a different font color, try choosing color independent options like underlines, bold texts, or even animations ... you can get creative with this!"
        explanationRight.fontSize = 18
        explanationRight.fontColor = .black
        explanationRight.numberOfLines = 0
        explanationRight.lineBreakMode = .byWordWrapping
        explanationRight.preferredMaxLayoutWidth = size.width / 2 - 1.5 * CGFloat(Utils.outerMargin)
        explanationRight.horizontalAlignmentMode = .left
        explanationRight.position = CGPoint(x: size.width / 2 + CGFloat(Utils.outerMargin / 2), y: textBackground.position.y - explanationRight.frame.height - CGFloat(Utils.verticalMargin))
        addChild(explanationRight)
        
        let howNotToDo = SKLabelNode(fontNamed: Utils.textFont)
        howNotToDo.text = "don't only use color as highlights"
        howNotToDo.fontSize = 18
        howNotToDo.fontColor = .red
        howNotToDo.preferredMaxLayoutWidth = size.width / 2 - 1.5 * CGFloat(Utils.outerMargin)
        howNotToDo.horizontalAlignmentMode = .left
        howNotToDo.position = CGPoint(x: size.width / 2 + CGFloat(Utils.outerMargin / 2), y: explanationRight.position.y - howNotToDo.frame.height - 10)
        addChild(howNotToDo)
        
        let howToDo = SKLabelNode(fontNamed: Utils.textFont)
        let attributedString = NSMutableAttributedString.init(string: "also try using underlines")
        let stringRange = NSMakeRange(0, attributedString.length)
        
        attributedString.beginEditing()
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: stringRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: howToDo.fontName!, size: 18) ?? UIFont.systemFont(ofSize: 18), range: stringRange)
        attributedString.endEditing()
        
        howToDo.attributedText = attributedString
        howToDo.fontSize = 18
        howToDo.fontColor = .red
        howToDo.preferredMaxLayoutWidth = size.width / 2 - 1.5 * CGFloat(Utils.outerMargin)
        howToDo.horizontalAlignmentMode = .left
        howToDo.position = CGPoint(x: size.width / 2 + CGFloat(Utils.outerMargin / 2), y: howNotToDo.position.y - howToDo.frame.height - 10)
        addChild(howToDo)
        
        let explanationRightDown = SKLabelNode(fontNamed: Utils.textFont)
        explanationRightDown.text = "3: Remember having fun. Implementing accessibility never should be a burden. Maybe gameify your experience. Would you be able to use your app in grayscale, with eyes closed, only voice? Try it out yourself and learn a lot!"
        explanationRightDown.fontSize = 18
        explanationRightDown.fontColor = .black
        explanationRightDown.numberOfLines = 0
        explanationRightDown.lineBreakMode = .byWordWrapping
        explanationRightDown.preferredMaxLayoutWidth = size.width / 2 - 1.5 * CGFloat(Utils.outerMargin)
        explanationRightDown.horizontalAlignmentMode = .left
        explanationRightDown.position = CGPoint(x: size.width / 2 + CGFloat(Utils.outerMargin / 2), y: howToDo.position.y - explanationRightDown.frame.height - CGFloat(Utils.verticalMargin))
        addChild(explanationRightDown)
        
        let footerBanner = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: 10))
        footerBanner.position = CGPoint(x: 0, y: 0)
        footerBanner.lineWidth = 0
        footerBanner.fillColor = colorTheme
        
        addChild(footerBanner)
        
        //Add navigation to scene
        setupNavigation(elementColor: .black)
    }
}
