// Copyright (c) 2018-2025 Jason Morley
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SwiftUI

import Licensable

#if compiler(>=5.7) && os(macOS)

@available(macOS 13, *)
struct MacLicenseWindowGroup: Scene {

    struct LayoutMetrics {
        static let width = 500.0
        static let height = 600.0
    }

    static let windowID = "diligence-license-window"

    let licenses: [License.ID: Licensable]

    init(licenses: [Licensable]) {
        self.licenses = licenses
            .includingDiligenceLicense()
            .flatten()
            .reduce(into: [License.ID: Licensable]()) { partialResult, licensable in
                partialResult[licensable.id] = licensable
            }
    }

    var body: some Scene {
        WindowGroup(id: Self.windowID, for: License.ID.self) { $licenseId in
            if let licenseId, let license = licenses[licenseId] {
                MacLicenseView(license: license)
            }
        }
        .defaultSize(CGSize(width: LayoutMetrics.width, height: LayoutMetrics.height))
        .windowResizability(.contentSize)
    }

}

#endif
