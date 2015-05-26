import UIKit


/// MARK: - DASearchResultViewDelegate
protocol DASearchResultViewDelegate {

    /**
     * called when cell is selected
     * @param searchResultView DASearchResultView
     * @param selectedDestination selected destination
     */
    func didSelectRow(#searchResultView: DASearchResultView, selectedDestination: DADestination)

}


/// MARK: - DASearchResultView
class DASearchResultView: UIView {

    /// MARK: - property
    @IBOutlet weak var resultTableView: UITableView!
    var delegate: DASearchResultViewDelegate?
    var destinations: [DADestination] = []


    /// MARK: - life cycle

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }


    /// MARK: - public api

    /**
     * update destinations
     * @param destinations destinations
     **/
    func updateDestinations(destinations: [DADestination]) {
        self.destinations = destinations
        self.resultTableView.reloadData()
    }

}


/// MARK: - UITableViewDelegate, UITableViewDataSource
extension DASearchResultView: UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.destinations.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let destination = self.destinations[indexPath.row]

        var cell = UITableViewCell(
            style: UITableViewCellStyle.Default,
            reuseIdentifier: DANSStringFromClass(DASearchResultView)
        )
        cell.textLabel!.text = destination.desc

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let destination = self.destinations[indexPath.row]
        if self.delegate != nil {
            self.delegate?.didSelectRow(searchResultView: self, selectedDestination: destination)
        }
    }

}
