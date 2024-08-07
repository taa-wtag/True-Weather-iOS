import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        headerLabel.font = headerLabel.font.withSize(labelFontSize)
    }

    func configure (text: String) {
        headerLabel.text = text
    }
}

extension HeaderTableViewCell {
    private var labelFontSize: CGFloat {
        return 23 * Constants.sizeMagnifier
    }
}
