import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var cityCollectionView: UICollectionView!
    @IBOutlet weak var weatherTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cityCollectionView.delegate = self
        cityCollectionView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        cityCollectionView
            .register(
                UINib(nibName: Constants.CellIdentifiers.CityPage, bundle: nil),
                forCellWithReuseIdentifier: Constants.CellIdentifiers.CityPage
            )
        weatherTableView
            .register(
                UINib(nibName: Constants.CellIdentifiers.HeaderTableView, bundle: nil),
                forCellReuseIdentifier: Constants.CellIdentifiers.HeaderTableView
            )
        weatherTableView
            .register(
                UINib(nibName: Constants.CellIdentifiers.CollectionViewInTableView, bundle: nil),
                forCellReuseIdentifier: Constants.CellIdentifiers.CollectionViewInTableView
            )
        weatherTableView
            .register(
                UINib(nibName: Constants.CellIdentifiers.DailyWeather, bundle: nil),
                forCellReuseIdentifier: Constants.CellIdentifiers.DailyWeather
            )
        let maxHeight = cityCollectionView.heightAnchor.constraint(equalToConstant: cityPageHeight + 20.0)
        maxHeight.isActive = true
    }
    @IBAction func getLocationButtonAction(_ sender: UIBarButtonItem) {
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        cityCollectionView.scrollToNearestVisibleCollectionViewCell()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            cityCollectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: Constants.CellIdentifiers.CityPage,
                for: indexPath
            )
        cell.layer.cornerRadius = cityPageCornerRadius
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: cityPageWidth, height: cityPageHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 10.0, left: cityPageInsetSide, bottom: 10.0, right: cityPageInsetSide)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return cityPageInterimSpacing
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return hourlyCollectionHeight
        default:
            return UITableView.automaticDimension
        }
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 2:
            let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: Constants.CellIdentifiers.HeaderTableView,
                    for: indexPath
                )
            (cell as? HeaderTableViewCell)?
                .configure(text: indexPath.row == 0 ? "Today" : "Next \(Constants.Weather.ForecastMaxDays - 1) Days")
            return cell
        case 1:
            let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: Constants.CellIdentifiers.CollectionViewInTableView,
                    for: indexPath
                )
            cell.layoutIfNeeded()
            return cell
        default:
            let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: Constants.CellIdentifiers.DailyWeather,
                    for: indexPath
                )
            return cell
        }
    }
}

extension UICollectionView {
   func scrollToNearestVisibleCollectionViewCell() {
       self.decelerationRate = UIScrollView.DecelerationRate.fast
       let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
       var closestCellIndex = -1
       var closestDistance: Float = .greatestFiniteMagnitude
       for index in 0..<self.visibleCells.count {
           let cell = self.visibleCells[index]
           let cellWidth = cell.bounds.size.width
           let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

           // Now calculate closest cell
           let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
           if distance < closestDistance {
               closestDistance = distance
               closestCellIndex = self.indexPath(for: cell)!.row
           }
       }
       if closestCellIndex != -1 {
           self.scrollToItem(
            at: IndexPath(row: closestCellIndex, section: 0),
            at: .centeredHorizontally, animated: true
           )
       }
   }
}

extension WeatherViewController {

    private var cityPageCornerRadius: CGFloat {
        return 18 * Constants.sizeMagnifier
    }

    private var cityPageWidth: CGFloat {
        return 330 * Constants.sizeMagnifier
    }

    private var cityPageHeight: CGFloat {
        return 200 * Constants.sizeMagnifier
    }

    private var cityPageInsetSide: CGFloat {
        return 22.5 * Constants.sizeMagnifier
    }

    private var cityPageInterimSpacing: CGFloat {
        return cityPageInsetSide * 2
    }

    private var hourlyCollectionHeight: CGFloat {
        return 120 * Constants.sizeMagnifier
    }
}
