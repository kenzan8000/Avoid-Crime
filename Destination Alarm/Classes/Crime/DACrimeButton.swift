import UIKit


/// MARK: - DACrimeButtonDelegate
protocol DACrimeButtonDelegate {

    /**
     * called when check box was on
     * @param crimeButton DACrimeButton
     * @param wasOn On or Off (Bool)
     */
    func crimeButton(crimeButton: DACrimeButton, wasOn: Bool)

}


/// MARK: - DACrimeButton
class DACrimeButton: UIView {

    /// MARK: - property

    var delegate: DACrimeButtonDelegate?

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonBackgroundView: UIView!


    /// MARK: - life cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        // shadow
        self.buttonBackgroundView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.buttonBackgroundView.layer.shadowColor = UIColor.blackColor().CGColor
        self.buttonBackgroundView.layer.shadowOpacity = 0.2
        self.buttonBackgroundView.layer.shadowPath = UIBezierPath(rect: self.buttonBackgroundView.bounds).CGPath
        // rounded corner
        self.buttonBackgroundView.layer.cornerRadius = self.buttonBackgroundView.frame.size.width / 2.0
        self.buttonBackgroundView.layer.masksToBounds = true
        // rounded corner
        self.button.layer.cornerRadius = self.buttonBackgroundView.frame.size.width / 2.0
        self.button.layer.masksToBounds = true

        self.setCheckBox(isOn: false)
    }


    /// MARK: - event listener

    @IBAction func touchedUpInside(#button: UIButton) {
        if button == self.button {
            let isOn = (self.button.alpha < 0.8)
            self.setCheckBox(isOn: isOn)

            // delegate
            if self.delegate != nil { self.delegate?.crimeButton(self, wasOn: isOn) }
        }
    }


    /// MARK: - publc api

    /**
     * set button image
     * @param image image
     **/
    func setImage(image: UIImage) {
        self.button.setImage(image, forState: .Normal)
    }

    /**
     * toggle checkbox on and off
     * @param isOn Bool
     **/
    func setCheckBox(#isOn: Bool) {
        self.button.alpha = (isOn) ? 1.0 : 0.5
    }

}
