import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!

    func configure (text: String) {
        headerLabel.text = text
    }
}
