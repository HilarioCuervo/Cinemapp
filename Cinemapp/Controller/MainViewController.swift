//
//  ViewController.swift
//  Cinemapp
//
//  Created by Hilario Cuervo on 15/01/2022.
//

import UIKit


class MainViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var tabBar: UITabBar!
    
    private let viewModel = MainViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setUpUI()
        loadMovies()
    }
    
}


// MARK: - @IBActions

extension MainViewController {
    
    @IBAction func logOutPressed(_ sender: Any) {
        if let error = viewModel.logOut() {
            reportError(error: "Ocurrio un error al intentar cerrar la sesion.", message: error.localizedDescription)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}


// MARK: - SetUp

extension MainViewController {
    
    private func setUp() {
        tabBar.delegate = self
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.register(UINib(nibName: "OneMovieCell", bundle: nil), forCellWithReuseIdentifier: "OneMovie")
    }
    
    
    private func setUpUI() {
        titleView.customizeView()
        tabBar.selectedItem = tabBar.items![0]
        logOutButton.layer.cornerRadius = logOutButton.frame.size.height / 6
        moviesCollectionView.backgroundColor = .none
    }
    
}


// MARK: - Fetching data

extension MainViewController {
    
    private func loadMovies() {
        viewModel.fetchMovies { error in
            
            if let e = error {
                self.reportError(error: "Ocurrio un error al intentar cargar las peliculas.", message: e.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.moviesCollectionView.reloadData()
                }
            }
            
        }
    }
    
}


// MARK: - UITabBarDelegate

extension MainViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title! == "Favoritos" {
            let vc = FavoritesMoviesViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
            tabBar.selectedItem = tabBar.items![0]
        }
    }
    
}


// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMovies()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "OneMovie", for: indexPath) as? OneMovieCell
        
        cell?.movieTitle.text = viewModel.getMovieTitle(at: indexPath.row)
        if let url = viewModel.getMovieImageUrl(at: indexPath.row) {
            cell?.moviePosterImage.load(url: url)
        } else {
            cell?.moviePosterImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
            cell?.moviePosterImage.tintColor = .systemRed
            reportError(error: "Error", message: "Ocurrio un error al intentar cargar las imagenes de las peliculas.")
        }
        
        return cell!
    }
    
}


// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieVC = CurrentMovieViewController(movieId: viewModel.getMovieId(at: indexPath.row))
        present(movieVC, animated: true, completion: nil)        
    }
    
}


// MARK: - Error report
 
extension MainViewController {
    
    private func reportError(error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

}
