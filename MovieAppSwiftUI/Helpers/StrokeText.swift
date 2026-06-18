//
//  StrokeText.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 13.05.26.
//

import SwiftUI

struct StrokeText: UIViewRepresentable {
    let text: String
    let fontSize: CGFloat
    let fillColor: UIColor
    let strokeColor: UIColor
    let strokeWidth: CGFloat

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: fillColor,
            .strokeColor: strokeColor,
            .strokeWidth: strokeWidth,
            .font: UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        ]
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: fillColor,
            .strokeColor: strokeColor,
            .strokeWidth: strokeWidth,
            .font: UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        ]
        uiView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
