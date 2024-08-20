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
        if let date = weather.dateString {
            dayLabel.text = DateUtil.getWeekDay(from: date)
        }
        maxTempLabel.text = "\(weather.maxTempC ?? 0.00)° / "
        minTempLabel.text = "\(weather.minTempC ?? 0.00)°"
        WeatherIconUseCase().loadWeatherIcon(from: weather.imageUrl ?? "") { [weak self] data in
            self?.iconImageView.image = UIImage(data: data)
        }
    }
}

extension DailyWeatherCell {
    private var labelFontSize: CGFloat {
        return floor(18 * Constants.sizeMagnifier)
    }

    private var iconSize: CGFloat {
        return floor(40 * Constants.sizeMagnifier)
    }

    private var labelWidth: CGFloat {
        return floor(100 * Constants.sizeMagnifier)
    }
}
