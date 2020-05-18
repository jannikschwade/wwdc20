import Foundation
import UIKit

/**
 Utils class to reference some often used constants of fonts and margins
 */
public struct Utils {
    /// Font used for titles and headings
    static let titleFont = "Arial Rounded MT Bold"
    
    /// Font used for blocks of text
    static let textFont = "Arial Rounded MT Bold"
    
    /// Font used in navigation elements
    static let navigationFont = "Courier"
    
    /// Font used in comments, notes and hints
    static let commentFont = "Courier"
    
    /// Margin for blank space that should be on the left and right side of a scene
    static let outerMargin = 60
    
    /// Margin elements with different context meanings should have
    static let verticalMargin = 30
}

extension UIColor{
    
    /// Custom colors for the specific use in this playground
    struct CustomColor{
        static let primaryBlue: UIColor = UIColor.init(red: 41/255, green: 105/255, blue: 176/255, alpha: 1)
        static let primaryGreen: UIColor = UIColor.init(red: 65/255, green: 168/255, blue: 95/255, alpha: 1)
        static let primaryRed: UIColor = UIColor.init(red: 235/255, green: 107/255, blue: 86/255, alpha: 1)
        static let primaryYellow: UIColor = UIColor.init(red: 243/255, green: 121/255, blue: 52/255, alpha: 1)
    }
}
