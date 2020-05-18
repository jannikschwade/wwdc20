/*:
 
 # Notes:
 
 Hi! 👋 This is the playground application from Jannik Schwade for the Swift Student Challange for WWDC20 (my first one, yey!)
 * The playground might take a while to be ready to be executed - don't worry, it will start! First time starting always takes a bit!
 * This playground features self-made visuals and sound effects, so make sure sound is turned on 🔉 (but I suggest not at max volume.).
 * In this year you won't need any code (unless you want to change some settings) since everything will be interactive in the playground, so just start the playground and enjoy! 😊
 * If you want to change the settings below, see their comment and documentation for more information.
 * And of course feel free to check out my code afterwards! 👩‍💻👨‍💻
 
 # Troubleshooting
 * Touch-interactions might won't work at the first start of the playground, if this happens to you, just *re-run the playground!*
 * Get a blackscreen when first starting? Just *re-run the playground!*
*/

import UIKit
import SpriteKit
import PlaygroundSupport

//Settings

    //Should the image simulation be calculated at runtime?
    FilterGame.Settings.doPictureCalculation = false

    //What's the name of your custom image you want to simulate?
    FilterGame.Settings.customImageName = "custom.png"

    //Should the extra pencil scene be loaded?
    SceneManager.Settings.enablePencilScene = false

//Start the adventure!
SceneManager.start()

