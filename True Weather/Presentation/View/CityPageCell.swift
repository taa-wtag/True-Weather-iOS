import UIKit

class CityPageCell: UICollectionViewCell {

    @IBOutlet weak var pageBackgroundImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    func configure (with city: CityItem, weather: HourlyWeatherItem, isCelcius: Bool = false) {
        if let date = weather.timeEpoch {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy"
            dateLabel.text = dateFormatter.string(from: date)
        }
        cityLabel.text = city.cityName?.components(separatedBy: ", ").first
        countryLabel.text = city.cityName?.components(separatedBy: ", ").last
        pageBackgroundImageView.image = UIImage(named: "city_page_background_\(city.backgroundColor ?? 0)")
        conditionLabel.text = weather.conditionText
        temperatureLabel.text = "\(weather.tempC ?? 0.00)"
        if let imageData = weather.image {
            iconImageView.image = UIImage(data: imageData)
        }
    }
}
