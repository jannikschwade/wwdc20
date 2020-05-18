import Foundation
import UIKit
import SpriteKit

/**
 `TopicScene` to introduce the user to the biological background of red-green color blindness.
 */
public class BackgroundScene: TopicScene {
    
    public override func didMove(to view: SKView) {
        
        //Setting up the scene
        clearScene()
        
        self.backgroundColor = .white
        colorTheme = UIColor.CustomColor.primaryGreen
        
        //Add the content to the scene
        let title = "Background"
        let description = "First of all: every 10th man on earth suffers from a kind of red-green color blindness, most of them being Deuteranomaly. But since I have a Protanopia, that is what we will be covering. Color blindness in this context means that I can't recognize the whole spectrum of the light. The human eyes' retina consists of cones to (said easily) detect color (red, green and blue) and rods to detect brightness. Protanopia is a form of genetic defect on the X chromosome that causes the red cones to disfunction."
        
        setupText(title: title, description: description)
        
        //Add the navigation to the scene
        setupNavigation(elementColor: .white)
    }
}
