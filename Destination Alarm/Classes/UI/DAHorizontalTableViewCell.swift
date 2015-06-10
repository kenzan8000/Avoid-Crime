import UIKit


/// MARK: - DAHorizontalTableViewCellDelegate
protocol DAHorizontalTableViewCellDelegate {

    /**
     * called when check box was on
     * @param horizontalTableViewCell DAHorizontalTableViewCell
     * @param wasOn On or Off (Bool)
     */
    func horizontalTableViewCell(horizontalTableViewCell: DAHorizontalTableViewCell, wasOn: Bool)

}


/// MARK: - DAHorizontalTableViewCell
class DAHorizontalTableViewCell: UIView {

    /// MARK: - property

    var delegate: DAHorizontalTableViewCellDelegate?

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var checkBoxButtonBackgroundView: UIView!


    /// MARK: - life cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        // shadow
        self.checkBoxButtonBackgroundView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.checkBoxButtonBackgroundView.layer.shadowColor = UIColor.blackColor().CGColor
        self.checkBoxButtonBackgroundView.layer.shadowOpacity = 0.2
        self.checkBoxButtonBackgroundView.layer.shadowPath = UIBezierPath(rect: self.checkBoxButtonBackgroundView.bounds).CGPath
    }


    /// MARK: - event listener

    @IBAction func touchedUpInside(#button: UIButton) {
        if button == self.checkBoxButton {
            let isOn = (self.checkBoxButton.imageForState(.Normal) == nil)
            self.setCheckBox(isOn: isOn)

            // delegate
            if self.delegate != nil {
                self.delegate?.horizontalTableViewCell(self, wasOn: isOn)
            }
        }
    }


    /// MARK: - publc api

    /**
     * toggle checkbox on and off
     * @param isOn Bool
     **/
    func setCheckBox(#isOn: Bool) {
        let icon = (isOn) ? IonIcons.imageWithIcon(ion_ios_checkmark_empty, size: self.frame.size.width, color: UIColor.grayColor()) : nil
        self.checkBoxButton.setImage(icon, forState: .Normal)
    }

}
