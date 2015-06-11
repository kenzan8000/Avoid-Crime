import UIKit


/// MARK: - DAHorizontalTableViewDelegate
protocol DAHorizontalTableViewDelegate {

    /**
     * called when check box was on
     * @param tableView DAHorizontalTableView
     * @param indexPath NSIndexPath
     * @param wasOn On or Off (Bool)
     */
    func tableView(tableView: DAHorizontalTableView, indexPath: NSIndexPath, wasOn: Bool)

}


/// MARK: - DAHorizontalTableView
class DAHorizontalTableView: UIView {

    /// MARK: - property

    var dataSource: [DAHorizontalTableViewData]! = []
    var cells: [DAHorizontalTableViewCell]! = []
    var delegate: DAHorizontalTableViewDelegate?
    @IBOutlet weak var scrollView: UIScrollView!


    /// MARK: - life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }


    /// MARK: - public api

    /**
     * do settings
     **/
    func doSettings() {
        // cells
        var offset: CGFloat = 0.0
        let markerTypes = [
            DAVisualization.CrimePoint,
            DAVisualization.CrimeHeatmap,
        ]

        for var i = 0; i < markerTypes.count; i++ {
            var data = DAHorizontalTableViewData()
            data.isOn = false
            data.markerType = markerTypes[i]

            self.dataSource.append(data)
            let nib = UINib(nibName: DANSStringFromClass(DAHorizontalTableViewCell), bundle:nil)
            let views = nib.instantiateWithOwner(nil, options: nil)
            var cell = views[0] as! DAHorizontalTableViewCell
            cell.frame = CGRectMake(offset, 0, cell.frame.size.width, self.scrollView.frame.size.height)
            cell.delegate = self
            self.scrollView.addSubview(cell)
            offset += cell.frame.size.width
            self.cells.append(cell)
        }

        self.scrollView.contentSize = CGSizeMake(offset, self.scrollView.frame.size.height)
    }

}


/// MARK: - UIScrollViewDelegate
extension DAHorizontalTableView: UIScrollViewDelegate {
}


/// MARK: - DAHorizontalTableViewCellDelegate
extension DAHorizontalTableView: DAHorizontalTableViewCellDelegate {

    func horizontalTableViewCell(horizontalTableViewCell: DAHorizontalTableViewCell, wasOn: Bool) {
        var index = -1
        for var i = 0; i < self.cells.count; i++ {
            let cell = self.cells[i]
            if cell == horizontalTableViewCell {
                index = i
            }
            else {
                cell.setCheckBox(isOn: false)
            }
        }
        if index < 0 { return }

        if self.delegate != nil {
            self.delegate?.tableView(self, indexPath: NSIndexPath(forRow: index, inSection: 0), wasOn: wasOn)
        }
    }

}
