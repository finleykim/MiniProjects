//
//  AlertActionConvertible.swift
//  SearchDaumBlog
//
//  Created by Finley on 2022/06/03.
//

import Foundation
import UIKit

protocol AlertActionConvertible{
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
