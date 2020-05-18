import Foundation
import UIKit
import SpriteKit

/**
 `TopicScene` to introduce the user to the idea of the playground.
 */
public class WelcomeScene: TopicScene {
    
    public override func didMove(to view: SKView) {
        
        //Setting up the scene
        clearScene()
        
        self.backgroundColor = .white
        colorTheme = UIColor.CustomColor.primaryBlue
        
        //Add the content to the scene
        let title = "Introduction"
        let description = "Hi! I'm excited to present to you my first ever Swift programming project! Besides coding, I also love to photograph, design and play games. But often I experience moments when I am overwhelmed with choosing or recognize the right colors - because I suffer from a form of red-green color blindness. Because most people can't imagine what it means to be color blind I want to introduce you to red-green color blindness in this playground!"
        setupText(title: title, description: description)
        
        let interactionNote = SKLabelNode(fontNamed: Utils.commentFont)
        interactionNote.text = "Can't click forward? Try to re-run the playground!"
        interactionNote.fontSize = 10
        interactionNote.fontColor = .white
        interactionNote.horizontalAlignmentMode = .left
        interactionNote.position = CGPoint(x: frame.width - interactionNote.frame.width - 150, y: 26)
        
        addChild(interactionNote)
        
        //Add the navigation to the scene
        setupNavigation(elementColor: .white)
    }
    
}
