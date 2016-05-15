import UIKit
import SwiftyJSON
import BFPaperButton
import TYMActivityIndicatorView

/// MARK: - DASearchBoxViewDelegate
protocol DASearchBoxViewDelegate {

    /**
     * called when search box was active
     * @param searchBoxView DASearchBoxView
     */
    func searchBoxWasActive(searchBoxView searchBoxView: DASearchBoxView)

    /**
     * called when search box was inactive
     * @param searchBoxView DASearchBoxView
     */
    func searchBoxWasInactive(searchBoxView searchBoxView: DASearchBoxView)

    /**
     * called when destination search finishes
     * @param searchBoxView DASearchBoxView
     * @param destinations prediction of destinations
     */
    func searchDidFinish(searchBoxView searchBoxView: DASearchBoxView, destinations: [DADestination])

    /**
     * called when clear button is touched up inside
     * @param searchBoxView DASearchBoxView
     */
    func clearButtonTouchedUpInside(searchBoxView searchBoxView: DASearchBoxView)

    /**
     * called when mode button is touched up inside
     * @param searchBoxView DASearchBoxView
     */
    func modeDidChanged(searchBoxView searchBoxView: DASearchBoxView)

    /**
     * called when cancel routing button is touched up inside
     * @param searchBoxView DASearchBoxView
     */
    func didCancelRequestRouting(searchBoxView searchBoxView: DASearchBoxView)

}


/// MARK: - DASearchBoxView
class DASearchBoxView: UIView {

    /// MARK: - property
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTextFieldBackgroundView: UIView!
    @IBOutlet var activeButton: BFPaperButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var modeButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    @IBOutlet weak var cancelRequestRoutingButton: UIButton!
    @IBOutlet weak var requestOverlayView: UIView!
    @IBOutlet  var indicatorView: TYMActivityIndicatorView!

    var delegate: DASearchBoxViewDelegate?
    var isActive: Bool {
        return self.activeButton.hidden
    }


    /// MARK: - life cycle

    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.searchTextField.addTarget(self, action: Selector("didChangeTextField:"), forControlEvents: .EditingChanged)
        self.activeButton.isRaised = false
        self.clearButton.hidden = true

        let backImage = IonIcons.imageWithIcon(
            ion_arrow_left_c,
            size: 20.0,
            color: UIColor.grayColor()
        )
        self.backButton.setImage(backImage, forState: .Normal)

        self.modeButton.setTitle(ion_android_bicycle, forState: .Normal)
        self.switchMode()

        let closeImage = IonIcons.imageWithIcon(
            ion_ios_close_empty,
            size: 36.0,
            color: UIColor.grayColor()
        )
        self.clearButton.setImage(closeImage, forState: .Normal)

        let cancelImage = IonIcons.imageWithIcon(
            ion_ios_close_empty,
            size: 36.0,
            color: UIColor(red: CGFloat(35.0/255.0), green: CGFloat(150.0/255.0), blue: CGFloat(232.0/255.0), alpha: 1.0)
        )
        self.cancelRequestRoutingButton.setImage(cancelImage, forState: .Normal)

        self.indicatorView.hidesWhenStopped = true
        self.indicatorView.stopAnimating()
    }


    /// MARK: - event listener

    @IBAction func touchedUpInside(button button: UIButton) {
        if button == self.activeButton {
            self.startSearch()
        }
        else if button == self.backButton {
            self.endSearch()
        }
        else if button == self.modeButton {
            self.switchMode()
            if self.delegate != nil {
                self.delegate?.modeDidChanged(searchBoxView: self)
            }
        }
        else if button == self.clearButton {
            self.searchTextField.text = ""
            self.clearButton.hidden = true
            if self.delegate != nil {
                self.delegate?.clearButtonTouchedUpInside(searchBoxView: self)
                self.delegate?.searchDidFinish(searchBoxView: self, destinations: [] as [DADestination])
            }
        }
        else if button == self.cancelRequestRoutingButton {
            if self.delegate != nil {
                self.delegate?.didCancelRequestRouting(searchBoxView: self)
            }
        }
    }

    func didChangeTextField(textField: UITextField) {
        let destination = textField.text
        if destination == nil || destination == "" {
            self.clearButton.hidden = true
            if self.delegate != nil {
                self.delegate?.searchDidFinish(searchBoxView: self, destinations: [] as [DADestination])
            }
            return
        }
        self.clearButton.hidden = false

        let location = DAGMSMapView.sharedInstance.myLocation
        if location == nil { return }

        DAGoogleMapClient.sharedInstance.cancelGetPlaceAutoComplete()

        // place autocomplete API
        DAGoogleMapClient.sharedInstance.getPlaceAutoComplete(
            input: destination!,
            radius: 5,
            location: location.coordinate,
            completionHandler: { [unowned self] (json) in
                let destinations = DADestination.destinations(json: json)
                if self.delegate != nil {
                    self.delegate?.searchDidFinish(searchBoxView: self, destinations: destinations)
                }
            }
        )
    }


    /// MARK: - public api

    /**
     * design
     * @param parentView parent view
     */
    func design(parentView parentView: UIView) {
        self.frame = CGRectMake(0, 20, parentView.bounds.width, self.frame.size.height)

        self.searchTextFieldBackgroundView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.searchTextFieldBackgroundView.layer.shadowColor = UIColor.blackColor().CGColor
        self.searchTextFieldBackgroundView.layer.shadowOpacity = 0.2
        let rect = self.searchTextFieldBackgroundView.bounds
        self.searchTextFieldBackgroundView.layer.shadowPath = UIBezierPath(rect: rect).CGPath
    }

    /**
     * set searchText to textField
     * @param searchText searchText
     **/
    func setSearchText(searchText: String) {
        self.searchTextField.text = searchText
        self.clearButton.hidden = (self.searchTextField.text == nil || self.searchTextField.text == "")
    }

    /**
     * start searching
     **/
    func startSearch() {
        self.searchTextField.becomeFirstResponder()
        self.activeButton.hidden = true
        self.backButton.hidden = false
        self.modeButton.hidden = true
        if self.delegate != nil { self.delegate?.searchBoxWasActive(searchBoxView: self) }
        self.clearButton.hidden = (self.searchTextField.text == nil || self.searchTextField.text == "")
    }

    /**
     * end searching
     **/
    func endSearch() {
        self.searchTextField.resignFirstResponder()
        self.activeButton.hidden = false
        self.backButton.hidden = true
        self.modeButton.hidden = false
        if self.delegate != nil { self.delegate?.searchBoxWasInactive(searchBoxView: self) }
        self.clearButton.hidden = (self.searchTextField.text == nil || self.searchTextField.text == "")
    }

    /**
     * start request routing
     **/
    func startRequestRouting() {
        self.requestOverlayView.hidden = false
        self.indicatorView.activityIndicatorViewStyle = TYMActivityIndicatorViewStyle.Small
        self.indicatorView.setBackgroundImage(
            UIImage(named: "clear.png"),
            forActivityIndicatorStyle:TYMActivityIndicatorViewStyle.Small
        )
        self.indicatorView.startAnimating()

        self.modeButton.hidden = true
        self.clearButton.hidden = true
    }

    /**
     * end request routing
     **/
    func endRequestRouting() {
        self.requestOverlayView.hidden = true
        self.indicatorView.stopAnimating()

        self.modeButton.hidden = false
        self.clearButton.hidden = (self.searchTextField.text == nil || self.searchTextField.text == "")
    }

    /**
     * get mode
     **/
    func getMode() -> String {
        if self.modeButton.titleForState(.Normal) == ion_android_bicycle {
            return "bicycling"
        }
        else if self.modeButton.titleForState(.Normal) == ion_android_walk {
            return "walking"
        }
        return ""
    }


    /// MARK: - private api

    /**
     * switch mode walk or bicycle
     **/
    func switchMode() {
        let title = (self.modeButton.titleForState(.Normal) == ion_android_walk) ? ion_android_bicycle : ion_android_walk
        self.modeButton.setTitle(title, forState: .Normal)

        let modeImage = IonIcons.imageWithIcon(
            title,
            size: 20.0,
            color: UIColor.grayColor()
        )
        self.modeButton.setImage(modeImage, forState: .Normal)
    }

}


/// MARK: - UITextFieldDelegate
extension DASearchBoxView: UITextFieldDelegate {
}
