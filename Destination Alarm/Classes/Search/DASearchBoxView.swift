import UIKit


/// MARK: - DASearchBoxViewDelegate
protocol DASearchBoxViewDelegate {

    /**
     * called when search box was active
     * @param searchBoxView DASearchBoxView
     */
    func searchBoxWasActive(#searchBoxView: DASearchBoxView)

    /**
     * called when search box was inactive
     * @param searchBoxView DASearchBoxView
     */
    func searchBoxWasInactive(#searchBoxView: DASearchBoxView)

    /**
     * called when destination search finishes
     * @param searchBoxView DASearchBoxView
     * @param destinations prediction of destinations
     */
    func searchDidFinish(#searchBoxView: DASearchBoxView, destinations: [DADestination])

}


/// MARK: - DASearchBoxView
class DASearchBoxView: UIView {

    /// MARK: - property
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTextFieldBackgroundView: UIView!
    @IBOutlet weak var activeButton: BFPaperButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    var delegate: DASearchBoxViewDelegate?


    /// MARK: - life cycle

    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.searchTextField.addTarget(self, action: Selector("didChangeTextField:"), forControlEvents: .EditingChanged)
        self.activeButton.isRaised = false
        self.clearButton.hidden = true
    }


    /// MARK: - event listener

    @IBAction func touchedUpInside(#button: UIButton) {
        if button == self.activeButton {
            self.startSearch()
        }
        else if button == self.backButton {
            self.endSearch()
        }
        else if button == self.clearButton {
            self.searchTextField.text = ""
            self.clearButton.hidden = true
            if self.delegate != nil {
                self.delegate?.searchDidFinish(searchBoxView: self, destinations: [] as [DADestination])
            }
        }
    }

    func didChangeTextField(textField: UITextField) {
//        ISHTTPOperationQueue.cancelOperationsWithPath()

        let destination = textField.text
        if destination == nil || destination == "" {
            self.clearButton.hidden = true
            return
        }
        self.clearButton.hidden = false

        let location = DAGMSMapView.sharedInstance.myLocation
        if location == nil { return }

        // place autocomplete API
        DAGoogleMapClient.sharedInstance.getPlaceAutoComplete(
            input: destination,
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
    func design(#parentView: UIView) {
        self.frame = CGRectMake(0, 20, parentView.bounds.width, self.frame.size.height)

        self.searchTextFieldBackgroundView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.searchTextFieldBackgroundView.layer.shadowColor = UIColor.blackColor().CGColor
        self.searchTextFieldBackgroundView.layer.shadowOpacity = 0.2
        var rect = self.searchTextFieldBackgroundView.bounds
        self.searchTextFieldBackgroundView.layer.shadowPath = UIBezierPath(rect: rect).CGPath
    }

    /**
     * set searchText to textField
     * @param searchText searchText
     **/
    func setSearchText(searchText: String) {
        self.searchTextField.text =  searchText
    }

    /**
     * start searching
     **/
    func startSearch() {
        self.searchTextField.becomeFirstResponder()
        self.activeButton.hidden = true
        self.backButton.hidden = false
        if self.delegate != nil { self.delegate?.searchBoxWasActive(searchBoxView: self) }
    }

    /**
     * end searching
     **/
    func endSearch() {
        self.searchTextField.resignFirstResponder()
        self.activeButton.hidden = false
        self.backButton.hidden = true
        if self.delegate != nil { self.delegate?.searchBoxWasInactive(searchBoxView: self) }
    }

}


/// MARK: - UITextFieldDelegate
extension DASearchBoxView: UITextFieldDelegate {
}
