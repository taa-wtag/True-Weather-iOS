import UIKit

class CityPageCell: UICollectionViewCell {

    @IBOutlet weak var pageBackgroundImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cityLabel.font = cityLabel.font.withSize(cityLabelFontSize)
        countryLabel.font = countryLabel.font.withSize(countryLabelFontSize)
        temperatureLabel.font = temperatureLabel.font.withSize(tempLabelFontSize)
        degreeLabel.font = degreeLabel.font.withSize(tempLabelFontSize)
        dateLabel.font = dateLabel.font.withSize(dateLabelFontSize)
        conditionLabel.font = conditionLabel.font.withSize(conditionLabelFontSize)
    }

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

extension CityPageCell {
    private var cityLabelFontSize: CGFloat {
        return 22 * Constants.sizeMagnifier
    }

    private var countryLabelFontSize: CGFloat {
        return 15 * Constants.sizeMagnifier
    }

    private var tempLabelFontSize: CGFloat {
        return 40 * Constants.sizeMagnifier
    }

    private var conditionLabelFontSize: CGFloat {
        return 15 * Constants.sizeMagnifier
    }

    private var dateLabelFontSize: CGFloat {
        return 12 * Constants.sizeMagnifier
    }
}
