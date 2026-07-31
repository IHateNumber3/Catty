/**
 *  Copyright (C) 2010-2024 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

import Foundation

// The Catroweb API (share.catrobat.org, formerly share.catrob.at) wraps list
// responses in an object instead of returning a bare JSON array:
// {"data": [...], "has_more": false}
// This wrapper lets us decode that shape directly instead of decoding [T].
struct PaginatedProjectsResponse<T: Decodable>: Decodable {
    let data: [T]
    let hasMore: Bool

    enum CodingKeys: String, CodingKey {
        case data
        case hasMore = "has_more"
    }
}

// Same wrapper shape but for a single-object response, e.g. {"data": {...}}
// instead of {"data": [...], "has_more": ...}. Used defensively where we're not
// certain whether a given endpoint wraps its single-object responses too.
struct SingleProjectResponse<T: Decodable>: Decodable {
    let data: T
}
