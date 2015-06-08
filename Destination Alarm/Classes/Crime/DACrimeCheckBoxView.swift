import UIKit


/// MARK: - DACrimeCheckBoxViewDelegate
protocol DACrimeCheckBoxViewDelegate {

    /**
     * called when crime check box was on
     * @param crimeCheckBoxView DACrimeCheckBoxView
     * @param wasOn On or Off (Bool)
     */
    func crimeCheckBoxView(crimeCheckBoxView: DACrimeCheckBoxView, wasOn: Bool)

}


/// MARK: - DACrimeCheckBoxView
class DACrimeCheckBoxView: UIView {

    /// MARK: - property

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var checkBoxButtonBackgroundView: UIView!
    var delegate: DACrimeCheckBoxViewDelegate?


    /// MARK: - life cycle

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }


    /// MARK: - event listener

    @IBAction func touchedUpInside(#button: UIButton) {
        if button == self.checkBoxButton {
            let isOn = (self.checkBoxButton.imageForState(.Normal) == nil)
            self.setCheckBox(isOn: isOn)
        }
    }


    /// MARK: - public api

    /**
     * design
     * @param parentView parentView
     **/
    func design(#parentView: UIView) {
        let offset: CGFloat = 20.0
        self.frame = CGRectMake(
            offset,
            parentView.frame.size.height - self.frame.size.height - offset,
            self.frame.size.width,
            self.frame.size.height
        )

        self.checkBoxButtonBackgroundView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.checkBoxButtonBackgroundView.layer.shadowColor = UIColor.blackColor().CGColor
        self.checkBoxButtonBackgroundView.layer.shadowOpacity = 0.2
        self.checkBoxButtonBackgroundView.layer.shadowPath = UIBezierPath(rect: self.checkBoxButtonBackgroundView.bounds).CGPath
    }


    /// MARK: - private api

    /**
     * toggle checkbox on and off
     * @param isOn Bool
     **/
    private func setCheckBox(#isOn: Bool) {
        let icon = (isOn) ? IonIcons.imageWithIcon(ion_ios_checkmark_empty, size: self.frame.size.width, color: UIColor.grayColor()) : nil
        self.checkBoxButton.setImage(icon, forState: .Normal)

        // delegate
        if self.delegate != nil {
            self.delegate?.crimeCheckBoxView(self, wasOn: isOn)
        }
    }

}
