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

    func configure (
        with city: CityItem,
        weather: HourlyWeatherItem,
        isCelcius: Bool = false
    ) {
        if let date = weather.timeString {
            dateLabel.text = DateUtil.getFullDate(from: date)
        }
        cityLabel.text = city.cityName?.components(separatedBy: ", ").first
        countryLabel.text = city.cityName?.components(separatedBy: ", ").last
        pageBackgroundImageView.image = UIImage(named: "city_page_background_\(city.backgroundColor ?? 0)")
        conditionLabel.text = WeatherUtil.getMediumCondition(from: weather.conditionText ?? "")
        temperatureLabel.text = "\(weather.tempC ?? 0.00)"
        WeatherIconUseCase().loadWeatherIcon(from: weather.imageUrl ?? "") { [weak self] data in
            self?.iconImageView.image = data
        }
    }
}

extension CityPageCell {
    private var cityLabelFontSize: CGFloat {
        return floor(22 * Constants.sizeMagnifier)
    }

    private var countryLabelFontSize: CGFloat {
        return floor(15 * Constants.sizeMagnifier)
    }

    private var tempLabelFontSize: CGFloat {
        return floor(40 * Constants.sizeMagnifier)
    }

    private var conditionLabelFontSize: CGFloat {
        return floor(15 * Constants.sizeMagnifier)
    }

    private var dateLabelFontSize: CGFloat {
        return floor(12 * Constants.sizeMagnifier)
    }
}
