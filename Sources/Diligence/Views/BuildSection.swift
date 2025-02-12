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

public struct BuildSection<Header: View>: View {

    @Environment(\.openURL) private var openURL

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    var project: String?
    var header: Header?

    private var date: String? {
        guard let date = Bundle.main.utcBuildDate else {
            return nil
        }
        return dateFormatter.string(from: date)
    }

    public init(_ project: String? = nil, @ViewBuilder header: () -> Header?) {
        self.project = project
        self.header = header()
    }

    public var body: some View {
        Section(header: header) {
            LabeledContent("Version") {
                Text(Bundle.main.extendedVersion ?? "")
                    .textSelection(.enabled)
            }
            if let date = date {
                LabeledContent("Date") {
                    Text(date)
                        .textSelection(.enabled)
                }
            }
            if let commit = Bundle.main.commit {
                if let project = project {
                   let url = Bundle.main.commitUrl(for: project)
                    Button {
                        if let url {
                            openURL(url)
                        }
                    } label: {
                        HStack {
                            Text("Commit")
                                .foregroundColor(.primary)
                            Spacer()
                            if url != nil {
                                Text(commit)
                                    .prefersMonospaced()
                                    .prefersLinkForegroundStyle()
                                    .foregroundColor(.secondary)
                                    .textSelection(.enabled)
                            } else {
                                Text(commit)
                                    .prefersMonospaced()
                            }
                        }
                    }
                } else {
                    LabeledContent("Commit") {
                        Text(commit)
                            .textSelection(.enabled)
                    }
                }
            }
        }
    }

}

extension BuildSection where Header == EmptyView {

    public init(_ project: String? = nil, commitUrl: URL? = nil) {
        self.init(project, header: { return nil })
    }

}
