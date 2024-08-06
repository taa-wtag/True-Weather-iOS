import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    @IBOutlet weak var hourCollectionView: UICollectionView!
    private let cellIdentifier = Constants.CellIdentifiers.HourlyWeather

    override func awakeFromNib() {
        super.awakeFromNib()
        hourCollectionView.register(
            UINib(nibName: cellIdentifier, bundle: nil),
            forCellWithReuseIdentifier: cellIdentifier
        )
        hourCollectionView.delegate = self
        hourCollectionView.dataSource = self
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate {

}

extension CollectionViewTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
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
        cell.layer.cornerRadius = 10
        let dummyHourWeather = HourlyWeatherItem()
        dummyHourWeather.timeString = " 02:00"
        dummyHourWeather.conditionText = "Blizzard"
        (cell as? HourlyWeatherCell)?
            .configure(
                weather: dummyHourWeather,
                isFirst: indexPath.row == 0
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
        return CGSize(width: 60, height: 110)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
}
