//
//  RootFourtyEightForecastNavigationController.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 13/7/2021.
//

import UIKit

class RootFourtyEightForecastNavigationController: UINavigationController {

    var router: RootRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = RootRouter(self)
        router?.show48Hours(animated: false)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
