import UIKit

class DailyWeatherCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

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
