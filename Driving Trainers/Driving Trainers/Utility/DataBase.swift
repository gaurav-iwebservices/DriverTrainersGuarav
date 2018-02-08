//
//  DataBase.swift
//  Driving Trainers
//
//  Created by iws on 1/13/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import Foundation
import SQLite3

class DataBase: NSObject {
   
    
    class func seletDB() -> ([String], [String]) {
        let queryStatementString = "SELECT * FROM StateList"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(DataManger._gDataManager.database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            var subrub:[String] = []
            var state:[String] = []
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let queryResultCol0 = sqlite3_column_text(queryStatement, 1)
                     state.append(String(cString: queryResultCol0!))
                    let queryResultCol1 = sqlite3_column_text(queryStatement, 3)
                    subrub.append(String(cString: queryResultCol1!))
                }
                return (state,subrub)
            } else {
                print("Query returned no results")
                return ([],[])
            }
        } else {
            print("SELECT statement could not be prepared")
           
        }
        sqlite3_finalize(queryStatement)
        return ([],[])
    }
}


