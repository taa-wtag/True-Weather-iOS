import UIKit

class CityItemCell: UICollectionViewCell {

    @IBOutlet weak var itemBackgroundImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    func configure (with city: CityItem, weather: HourlyWeatherItem) {
        cityLabel.text = city.cityName?.components(separatedBy: ", ").first
        countryLabel.text = city.cityName?.components(separatedBy: ", ").last
        itemBackgroundImageView.image = UIImage(named: "city_item_background_\(city.backgroundColor ?? 0)")
        conditionLabel.text = weather.conditionText
        temperatureLabel.text = "\(weather.tempC ?? 0.00)"
        if let imageData = weather.image {
            iconImageView.image = UIImage(data: imageData)
        }
    }
}
