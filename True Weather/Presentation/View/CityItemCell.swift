import UIKit

protocol CityItemCellDelegate: AnyObject {
    func onDeleteButtonPressed()
    func onLongPress()
}

class CityItemCell: UICollectionViewCell {

    @IBOutlet weak var itemBackgroundImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

    weak var delegate: CityItemCellDelegate?
    var isDeleteButtonHidden = true
    var deleteThisCell: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        cityLabel.font = cityLabel.font.withSize(cityLabelFontSize)
        countryLabel.font = countryLabel.font.withSize(countryLabelFontSize)
        temperatureLabel.font = temperatureLabel.font.withSize(temperatureLabelFontSize)
        conditionLabel.font = conditionLabel.font.withSize(conditionLabelFontSize)
        itemBackgroundImageView.layer.cornerRadius = cellCornerRadius
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: deleteButtonSize)
        let buttonImage = UIImage(systemName: "xmark.circle.fill", withConfiguration: buttonConfig)
        deleteButton.setImage(buttonImage, for: .normal)
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPress)))
    }

    override func layoutSubviews() {
        deleteButton.isHidden = isDeleteButtonHidden
    }

    func configure (with city: CityItem, weather: HourlyWeatherItem) {
        cityLabel.text = city.cityName?.components(separatedBy: ", ").first
        countryLabel.text = city.cityName?.components(separatedBy: ", ").last
        itemBackgroundImageView.image = UIImage(named: "city_item_background_\(city.backgroundColor ?? 0)")
        conditionLabel.text = weather.conditionText
        temperatureLabel.text = "\(weather.tempC ?? 0.00)°"
        if let imageData = weather.image {
            iconImageView.image = UIImage(data: imageData)
        }
    }

    @objc func onLongPress(gesture: UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        delegate?.onLongPress()
    }

    @IBAction func deleteButtonAction(_ sender: UIButton) {
        deleteThisCell?()
        delegate?.onDeleteButtonPressed()
    }
}

extension CityItemCell {
    private var cityLabelFontSize: CGFloat {
        return 16 * Constants.sizeMagnifier
    }

    private var countryLabelFontSize: CGFloat {
        return 12 * Constants.sizeMagnifier
    }

    private var temperatureLabelFontSize: CGFloat {
        return 34 * Constants.sizeMagnifier
    }

    private var conditionLabelFontSize: CGFloat {
        return 16 * Constants.sizeMagnifier
    }

    private var cellCornerRadius: CGFloat {
        return 15 * Constants.sizeMagnifier
    }

    private var deleteButtonSize: CGFloat {
        return 20 * Constants.sizeMagnifier
    }
}
