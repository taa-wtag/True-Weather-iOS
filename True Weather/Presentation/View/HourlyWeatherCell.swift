import UIKit

class HourlyWeatherCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    func configure (weather: HourlyWeatherItem, isFirst: Bool = false) {
        timeLabel.text = weather.timeString?.components(separatedBy: " ").last
        conditionLabel.text = weather.conditionText
        if let imageData = weather.image {
            iconImageView.image = UIImage(data: imageData)
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
