//
//  RecentSearchTableViewCell.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 19/4/2021.
//

import UIKit

class RecentSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
    var rowNum = 0
    
    func removeRealmSearchRecord(record:String, completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().removeRecordToRealm(name: record, completed: completed)
    }
    
    @IBAction func CancelButtonClicked(_ sender: Any) {
        removeRealmSearchRecord(record: (self.locationLabel.text ?? "")){[weak self] (failReason) in
            print(failReason)
        }
    }
}
