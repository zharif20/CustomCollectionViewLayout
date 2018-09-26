//
//  ViewController.swift
//  CustomCollectionViewLayout
//
//  Created by Local on 23/09/2018.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource{

    let cellId = "cellId"
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView.backgroundColor = .red
        self.collectionView.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell
        cell.backgroundColor = .green
        cell.layer.cornerRadius = 5
        cell.transform = self.collectionView.transform
        return cell
    }
    
    
}

