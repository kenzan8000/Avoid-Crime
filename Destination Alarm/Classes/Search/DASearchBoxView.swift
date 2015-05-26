import UIKit


/// MARK: - DASearchBoxViewDelegate
protocol DASearchBoxViewDelegate {

    /**
     * called when endButton is touched up inside
     * @param searchBoxView DASearchBoxView
     */
    func touchedUpInside(#searchBoxView: DASearchBoxView)

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
    @IBOutlet weak var endButton: UIButton!
    var delegate: DASearchBoxViewDelegate?


    /// MARK: - life cycle

    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.searchTextField.addTarget(self, action:Selector("didChangeTextField:"), forControlEvents: .EditingChanged)
    }


    /// MARK: - event listener

    @IBAction func touchedUpInside(#button: UIButton) {
        if button == self.endButton {
        }
    }

    func didChangeTextField(textField: UITextField) {
//        ISHTTPOperationQueue.cancelOperationsWithPath()

        let location = DAGMSMapView.sharedInstance.myLocation
        if location == nil { return }

        // place autocomplete API
        let destination = textField.text
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
     * set searchText to textField
     * @param searchText searchText
     **/
    func setSearchText(searchText: String) {
        self.searchTextField.text =  searchText
    }


    /// MARK: - private api

    /**
     * end searching
     **/
    private func endSearch() {
        if self.delegate != nil {
            self.delegate?.touchedUpInside(searchBoxView: self)
        }
    }

}


/// MARK: - UITextFieldDelegate
extension DASearchBoxView: UITextFieldDelegate {
}
