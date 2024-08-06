import UIKit

class DailyWeatherCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        let iconHeight = iconImageView.heightAnchor.constraint(equalToConstant: iconSize)
        iconHeight.isActive = true
        let dayLabelWidth = dayLabel.widthAnchor.constraint(equalToConstant: labelWidth)
        dayLabelWidth.isActive = true
        dayLabel.font = dayLabel.font.withSize(labelFontSize)
        maxTempLabel.font = maxTempLabel.font.withSize(labelFontSize)
        minTempLabel.font = minTempLabel.font.withSize(labelFontSize)
    }

    func configure (weather: DailyWeatherItem, isCelsius: Bool = true) {
        if let date = weather.dateEpoch {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            dayLabel.text = dateFormatter.string(from: date)
        }
        maxTempLabel.text = "\(weather.maxTempC ?? 0.00)° / "
        minTempLabel.text = "\(weather.minTempC ?? 0.00)°"
        if let imageData = weather.image {
            iconImageView.image = UIImage(data: imageData)
        }
    }
}

extension DailyWeatherCell {
    private var labelFontSize: CGFloat {
        return 18 * Constants.sizeMagnifier
    }

    private var iconSize: CGFloat {
        return 40 * Constants.sizeMagnifier
    }

    private var labelWidth: CGFloat {
        return 100 * Constants.sizeMagnifier
    }
}
