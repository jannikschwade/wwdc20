import Foundation
import UIKit
import SpriteKit

/**
 `TopicScene` to catch attention of developing apps with accessibility in mind.
 */
public class TipsScene: TopicScene {
    
    public override func didMove(to view: SKView) {
        
        //Setting up the scene
        clearScene()
        
        self.backgroundColor = .white
        colorTheme = UIColor.CustomColor.primaryRed
        
        //Add the content to the scene
        let textBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: 361))
        textBackground.lineWidth = 0
        textBackground.fillColor = colorTheme
        
        addChild(textBackground)
        
        let title = SKLabelNode(fontNamed: Utils.titleFont)
        title.text = "Tips for Devs"
        title.fontSize = 72
        title.fontColor = colorTheme
        title.horizontalAlignmentMode = .left
        title.position = CGPoint(x: CGFloat(Utils.outerMargin), y: textBackground.frame.maxY + CGFloat(Utils.verticalMargin))
        
        addChild(title)
        
        let text = SKLabelNode(fontNamed: Utils.textFont)
        text.text = "Now that you saw what it means to be color blind, I want to end my playground by showing you that developing apps with color blind people in mind isn't that difficult! The thoughts I will present to you are easy to remember and aren't complicated to implement into your apps either. Please help by creating accessible apps all of us can use - and enjoy!"
        text.fontSize = 24
        text.fontColor = .white
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.preferredMaxLayoutWidth = size.width - CGFloat(2 * Utils.outerMargin)
        text.horizontalAlignmentMode = .left
        text.position = CGPoint(x: CGFloat(Utils.outerMargin), y: textBackground.frame.height - text.frame.height - CGFloat(Utils.verticalMargin))
        
        addChild(text)
        
        //Add the navigation to the scene
        setupNavigation(elementColor: .white)
    }
    
}
