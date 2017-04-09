//
//  CustomRowViewBuilderDelegate.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 3/23/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

public protocol CustomRowViewBuilderDelegate: NSObjectProtocol {
    
    func getOrBuildCell(tableView: BaseRowUITableView, model: BaseRowModel) -> BaseRowTVCell?
    
}
