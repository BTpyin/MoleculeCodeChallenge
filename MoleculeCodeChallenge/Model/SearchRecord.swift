//
//  SearchRecord.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 21/4/2021.
//

import Foundation
import RealmSwift
import ObjectMapper

class SearchRecord: Object{
    
    @objc dynamic var searchString: String?
    
    
    override static func primaryKey() -> String? {
      return "searchString"
    }
    
    convenience init(record: String){
        self.init()
        searchString = record
    }
}
