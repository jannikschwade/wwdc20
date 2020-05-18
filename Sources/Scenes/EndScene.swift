import Foundation
import UIKit
import SpriteKit

/**
 `TopicScene` to thank the user for checking out the playground
 */
public class EndScene: TopicScene {
    
    public override func didMove(to view: SKView) {
        
        //Setting up the scene
        clearScene()
        
        self.backgroundColor = .white
        colorTheme = UIColor.CustomColor.primaryYellow
        
        //Add the content to the scene
        let title = "The End 🎉"
        let description = "Congratulations on completing the playground! Thanks for checking it out! I hope you've enjoyed it and learned a lot about red-green color blindness. Have a great day, stay safe."
        setupText(title: title, description: description)
        
        let nameNode = SKLabelNode(fontNamed: Utils.commentFont)
        nameNode.text = "Jannik Schwade"
        nameNode.fontSize = 18
        nameNode.fontColor = .white
        nameNode.horizontalAlignmentMode = .left
        nameNode.position = CGPoint(x: CGFloat(Utils.outerMargin), y: 26 + nameNode.frame.height)
        
        addChild(nameNode)
        
        //Add the navigation to the scene
        setupNavigation(elementColor: .white)
    }
    
}
