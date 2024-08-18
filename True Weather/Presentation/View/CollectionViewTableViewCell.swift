import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    @IBOutlet weak var hourCollectionView: UICollectionView!
    private let cellIdentifier = Constants.CellIdentifiers.HourlyWeather

    var hourlyWeatherList: [HourlyWeatherItem]?

    override func awakeFromNib() {
        super.awakeFromNib()
        hourCollectionView.register(
            UINib(nibName: cellIdentifier, bundle: nil),
            forCellWithReuseIdentifier: cellIdentifier
        )
        hourCollectionView.dataSource = self
        hourCollectionView.delegate = self
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate {}

extension CollectionViewTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyWeatherList?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: cellIdentifier,
                for: indexPath
            )
        cell.layer.cornerRadius = cornerRadius
        (cell as? HourlyWeatherCell)?
            .configure(
                weather: hourlyWeatherList?[indexPath.row] ?? HourlyWeatherItem(),
                isFirst: indexPath.row == 0,
                NetworkRequestService.sharedInstance
            )
        return cell
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: topInsets, left: sideInsets, bottom: topInsets, right: sideInsets)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        sideInsets
    }
}

extension CollectionViewTableViewCell {
    private var cellHeight: CGFloat {
        return floor(110 * Constants.sizeMagnifier)
    }

    private var cellWidth: CGFloat {
        return floor(60 * Constants.sizeMagnifier)
    }

    private var topInsets: CGFloat {
        return floor(10 * Constants.sizeMagnifier)
    }

    private var sideInsets: CGFloat {
        return floor(20 * Constants.sizeMagnifier)
    }

    private var cornerRadius: CGFloat {
        return floor(10 * Constants.sizeMagnifier)
    }
}
