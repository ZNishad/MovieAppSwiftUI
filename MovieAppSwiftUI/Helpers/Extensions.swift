//
//  Extensions.swift
//  MovieApp
//
//  Created by Nishad Zulfuqarli on 02.02.25.
//

import UIKit

extension UIView {

    @discardableResult
    func top(_ anchor: NSLayoutYAxisAnchor, _ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    @discardableResult
    func bottom(_ anchor: NSLayoutYAxisAnchor, _ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    @discardableResult
    func leading(_ anchor: NSLayoutXAxisAnchor, _ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    @discardableResult
    func trailing(_ anchor: NSLayoutXAxisAnchor, _ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    @discardableResult
    func centerX(_ anchor: NSLayoutXAxisAnchor, _ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    @discardableResult
    func centerY(_ anchor: NSLayoutYAxisAnchor, _ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    @discardableResult
    func width(_ anchor: NSLayoutDimension, multiplier: CGFloat , _ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalTo: anchor, multiplier: multiplier ,constant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    @discardableResult
    func width(_ anchor: NSLayoutDimension, _ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    @discardableResult
    func width(_ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    @discardableResult
    func height(_ anchor: NSLayoutDimension, multiplier: CGFloat , _ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalTo: anchor, multiplier: multiplier ,constant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    @discardableResult
    func height(_ anchor: NSLayoutDimension, _ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    @discardableResult
    func height(_ constant: CGFloat = .zero, isActive: Bool = true)
    -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        return (self, constraint)
    }

    func fillSuperView(padding: UIEdgeInsets = .zero) {
        guard let superview else { return }
        top(superview.topAnchor, padding.top)
        leading(superview.leadingAnchor, padding.left)
        trailing(superview.trailingAnchor, padding.right)
        bottom(superview.bottomAnchor, padding.bottom)
    }

    func fillSuperViewSafeArea(padding: UIEdgeInsets = .zero) {
        guard let superview else { return }
        top(superview.safeAreaLayoutGuide.topAnchor, padding.top)
        leading(superview.safeAreaLayoutGuide.leadingAnchor, padding.left)
        trailing(superview.safeAreaLayoutGuide.trailingAnchor, padding.right)
        bottom(superview.safeAreaLayoutGuide.bottomAnchor, padding.bottom)
    }

    func addSubviews(_ views: UIView...) {
        for i in views {
            addSubview(i)
        }
    }

    func showLoader() {
        let loaderView = UIActivityIndicatorView(style: .large)
        addSubviews(loaderView)
        loaderView.fillSuperViewSafeArea()
        loaderView.startAnimating()
    }

    func hideLoader() {
        for i in subviews {
            if i is UIActivityIndicatorView {
                i.removeFromSuperview()
            }
        }
    }
}

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage? {

        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        self.draw(in: CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

extension UITextField {

    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }

    func addPadding(_ padding: PaddingSide) {

        self.leftViewMode = .always
        self.layer.masksToBounds = true


        switch padding {

        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always

        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always

        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }

    func setImage(urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {
            [weak self] data, _, _ in
            DispatchQueue.main.async {
                guard let self, let data else { return }
                self.image = UIImage(data: data)
            }
        }).resume()
    }
}

extension UIViewController {
    func showMessage(title: String?, message: String, buttonTitle: String = "Ok") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                guard let self else { return }
                self.dismiss(animated: true)
            }
        }))
        present(alert, animated: true)
    }
}
