import UIKit

class HourlyWeatherCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        timeLabel.font = conditionLabel.font.withSize(labelFontSize)
        conditionLabel.font = conditionLabel.font.withSize(labelFontSize)
    }

    func configure (weather: HourlyWeatherItem, isFirst: Bool = false) {
        timeLabel.text = weather.timeString?.components(separatedBy: " ").last
        conditionLabel.text = WeatherUtil.getShortCondition(from: weather.conditionText ?? "")
        WeatherIconUseCase().loadWeatherIcon(from: weather.imageUrl ?? "") { [weak self] data in
            self?.iconImageView.image = data
        }
        if isFirst {
            timeLabel.textColor = UIColor(named: Constants.Colors.DeepGolden)
            conditionLabel.textColor = UIColor(named: Constants.Colors.DeepGolden)
            self.backgroundColor = UIColor(named: Constants.Colors.LightGolden)
        } else {
            timeLabel.textColor = UIColor(named: Constants.Colors.LightGrey)
            conditionLabel.textColor = UIColor(named: Constants.Colors.LightGrey)
            self.backgroundColor = UIColor(named: Constants.Colors.White)
        }
    }
}

extension HourlyWeatherCell {
    private var labelFontSize: CGFloat {
        return floor(12 * Constants.sizeMagnifier)
    }
}
