import Foundation
import UIKit
import SpriteKit

/**
 A scene that shows the user how protanopia affects everyday life through simulating a protanopians sight.
 */
public class FilterGame: LoadableScene {
       
    public struct Settings {
        /**
         Whether the picture should be live calculated.
         
         Need to be set to true to use a custom image for calculation.
         - Warning: The pixelbased calculation of the protanopians simulation might cause some performance issues on some devices and in the playground app. Therefore it is deactivated by default.
         */
        public static var doPictureCalculation = false
        
        /**
        Name of the custom image rendered into a protanopia simulation.
         */
        public static var customImageName = "custom.png"
    }
            
    public required init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public init(size: CGSize) {
        super.init(size: size)
    }
    
    public override func didMove(to view: SKView) {
        
        //Setting up the scene
        clearScene()
        
        self.backgroundColor = .white
        colorTheme = UIColor.CustomColor.primaryGreen
        
        //Add the content to the scene
        let taskTitle = SKLabelNode(fontNamed: Utils.titleFont)
        taskTitle.text = "How I See The World"
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
        explanation.text = "The absence of red cones changes how the eye perceives and the brain interprets colors. Since long waves can't be detected, the whole view shifts more into a green tone. We can mathematically remove these wavelengths from photos and thus simulate the view of a protanope. Down below you find an example:"
        explanation.fontSize = 18
        explanation.fontColor = .black
        explanation.numberOfLines = 0
        explanation.lineBreakMode = .byWordWrapping
        explanation.preferredMaxLayoutWidth = size.width - CGFloat(2 * Utils.outerMargin)
        explanation.horizontalAlignmentMode = .left
        explanation.position = CGPoint(x: CGFloat(Utils.outerMargin), y: textBackground.position.y - explanation.frame.height - CGFloat(Utils.verticalMargin))
        addChild(explanation)
        
        //Add splitview of original picture and protanopia simulation
        var uiimage = UIImage(named: "custom/example.jpg")
        let precalcUIImage = UIImage(named: "custom/example-protanope.jpg")
        
        if(FilterGame.Settings.doPictureCalculation){
            if let customImage = UIImage(named: "custom/" + FilterGame.Settings.customImageName){
                uiimage = customImage
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 300, height: 225), false, 0.0)
        uiimage?.draw(in: CGRect(x: 0, y: 0, width: 300, height: 225))
        let reducedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 300, height: 225), false, 0.0)
        precalcUIImage?.draw(in: CGRect(x: 0, y: 0, width: 300, height: 225))
        let precalcReducedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let protanopeImage = FilterGame.Settings.doPictureCalculation ? processPixels(in: reducedImage!) : precalcReducedImage
        
        let view = self.view!
        let compareView = BeforeAfterView(frame: CGRect(x: 0, y: 0, width: reducedImage!.size.width, height: reducedImage!.size.height))
        
        compareView.image1 = reducedImage!
        compareView.image2 = protanopeImage!
        
        view.addSubview(compareView)
        compareView.translatesAutoresizingMaskIntoConstraints = false
        compareView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(Utils.outerMargin)).isActive = true
        compareView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        let protanopeTitle = SKLabelNode(fontNamed: Utils.titleFont)
        protanopeTitle.text = "Protanopia"
        protanopeTitle.fontSize = 14
        protanopeTitle.fontColor = .black
        protanopeTitle.horizontalAlignmentMode = .left
        protanopeTitle.position = CGPoint(x: CGFloat(Utils.outerMargin), y: 30)
        addChild(protanopeTitle)
        
        let normalTitle = SKLabelNode(fontNamed: Utils.titleFont)
        normalTitle.text = "Normal"
        normalTitle.fontSize = 14
        normalTitle.fontColor = .black
        normalTitle.horizontalAlignmentMode = .left
        normalTitle.position = CGPoint(x: CGFloat(Utils.outerMargin) + compareView.bounds.maxX - normalTitle.frame.width, y: 30)
        addChild(normalTitle)

        var customNoteSteps = ["This is a precalculated version of the picture. To use your own image, ...",
                               " ",
                               "1) Set 'doPictureCalculation' to true",
                               "2) Place an image into Resources/custom/",
                               "3) Change the setting 'customImageName' to the name of your file"]
                    
        if(FilterGame.Settings.doPictureCalculation){
            if UIImage(named: "custom/" + FilterGame.Settings.customImageName) == nil {
                customNoteSteps = ["Ohoh! Error in sight! 😨",
                                   "",
                                   "Could not load your custom image. Check the name and location of your file:",
                                   "Resources/custom/\(FilterGame.Settings.customImageName)"]
            } else {
                customNoteSteps = [""]
            }
           
        }
                
        var lastHeight = 50
        for step in customNoteSteps.reversed() {
            let customNote = SKLabelNode(fontNamed: Utils.commentFont)
            customNote.text = step
            
            customNote.fontSize = 12
            customNote.fontColor = .black
            customNote.numberOfLines = 0
            customNote.lineBreakMode = .byWordWrapping
            customNote.horizontalAlignmentMode = .left
            customNote.preferredMaxLayoutWidth = view.frame.width - CGFloat(Utils.outerMargin) - (CGFloat(Utils.outerMargin) + compareView.bounds.maxX + 30)
            customNote.position = CGPoint(x: CGFloat(Utils.outerMargin) + compareView.bounds.maxX + 30, y: CGFloat(lastHeight))
            
            lastHeight += Int(customNote.frame.height)
            addChild(customNote)
        }

        let footerBanner = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: 10))
        footerBanner.position = CGPoint(x: 0, y: 0)
        footerBanner.lineWidth = 0
        footerBanner.fillColor = colorTheme
        
        addChild(footerBanner)
        
        //Add the navigation to the scene
        setupNavigation(elementColor: .black)
    }
    
    /**
     Recalculates an image into a protanopia simulated image.
     
     - Warning: The pixelbased calculation might cause some performance issues on some devices and in the playground app.
     - Author: Coder ACJHP (2018) and Jannik Schwade (2020)
     
     [Stackoverflow]: https://stackoverflow.com/a/53647476
     Used image manipulation approach from [Stackoverflow], calculation by Jannik Schwade
     */
    func processPixels(in image: UIImage) -> UIImage? {
        guard let inputCGImage = image.cgImage else { print("unable to get cgImage"); return nil }
        
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { print("unable to create context"); return nil }
        
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let buffer = context.data else { print("unable to get context data"); return nil }
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        //Matrices for the calculation
        
        //RGB to LMS
        let matrixRGBtoLMSrow1 = simd_double3(0.31399022, 0.63951294, 0.04649755)
        let matrixRGBtoLMSrow2 = simd_double3(0.15537241, 0.75789446, 0.08670142)
        let matrixRGBtoLMSrow3 = simd_double3(0.01775239, 0.10944209, 0.87256922)
        let matrixRGBtoLMS = simd_double3x3(rows: [matrixRGBtoLMSrow1, matrixRGBtoLMSrow2, matrixRGBtoLMSrow3])
        
        //LMS to RGB
        let matrixLMStoRGB = matrixRGBtoLMS.inverse
        
        //Protanopia Simulation Matrix
        let matrixProtanopiaSimulationRow1 = simd_double3(0, 1.05118294, -0.05116099)
        let matrixProtanopiaSimulationRow2 = simd_double3(0, 1, 0)
        let matrixProtanopiaSimulationRow3 = simd_double3(0, 0, 1)
        let matrixProtanopiaSimulation = simd_double3x3(rows: [matrixProtanopiaSimulationRow1, matrixProtanopiaSimulationRow2, matrixProtanopiaSimulationRow3])
        
        //LMS to LMS with simulation
        let matrixCompleteCalculation = matrixLMStoRGB * matrixProtanopiaSimulation * matrixRGBtoLMS
        
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                
                //original RGB values of the pixel
                let orgRGB = simd_double3(Double(pixelBuffer[offset].redComponent), Double(pixelBuffer[offset].greenComponent), Double(pixelBuffer[offset].blueComponent))
                
                //whole protanope calculation
                let protanopeRGB = matrixCompleteCalculation * orgRGB
                
                //color the pixel in the protanope color
                pixelBuffer[offset] = RGBA32(red: UInt8(protanopeRGB.x), green: UInt8(protanopeRGB.y), blue: UInt8(protanopeRGB.z), alpha: 255)
            }
        }
        
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        return outputImage
    }
    
    /**
     Representitve for a color on a pixel
     */
    struct RGBA32: Equatable {
        private var color: UInt32
        
        var redComponent: UInt8 {
            return UInt8((color >> 24) & 255)
        }
        
        var greenComponent: UInt8 {
            return UInt8((color >> 16) & 255)
        }
        
        var blueComponent: UInt8 {
            return UInt8((color >> 8) & 255)
        }
        
        var alphaComponent: UInt8 {
            return UInt8((color >> 0) & 255)
        }
        
        init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
            let red   = UInt32(red)
            let green = UInt32(green)
            let blue  = UInt32(blue)
            let alpha = UInt32(alpha)
            color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
        }
        
        static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
        static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
        static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
        static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
        static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
        static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
        static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
        static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)
        
        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
    }
}
