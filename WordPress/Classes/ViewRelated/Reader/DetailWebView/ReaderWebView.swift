import UIKit

/// A WKWebView that renders post content with styles applied
///
class ReaderWebView: WKWebView {

    /// HTML elements that will load only after the text has appeared
    /// From: https://www.w3schools.com/tags/att_src.asp
    private let elements = ["audio", "embed", "iframe", "img", "input", "script", "source", "track", "video"]

    /// Make the webview transparent
    ///
    override func awakeFromNib() {
        isOpaque = false
        backgroundColor = .clear
    }

    /// Loads a HTML content into the webview and apply styles
    ///
    @discardableResult
    override func loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation? {
        let content = """
        <!DOCTYPE html><html><head><meta charset='UTF-8' />
        <title>Reader Post</title>
        <meta name='viewport' content='initial-scale=1, maximum-scale=1.0, user-scalable=no'>
        <link rel="stylesheet" type="text/css" href="https://wordpress.com/calypso/reader-mobile.css">
        <style>
        \(cssColors())
        \(cssStyles())
        </style>
        </head><body class="reader-full-post reader-full-post__story-content">
        \(addPlaceholder(string))
        </body>
        <script>
            document.addEventListener('DOMContentLoaded', function(event) {
                // Remove autoplay to avoid media autoplaying
                document.querySelectorAll('video-placeholder, audio-placeholder').forEach((el) => {el.removeAttribute('autoplay')})
            })
        </script>
        </html>
        """

        return super.loadHTMLString(content, baseURL: Bundle.wordPressSharedBundle.bundleURL)
    }

    /// Tell the webview to load all media
    /// You want to use this method only after the webview has appearead (after a didFinish, for example)
    func loadMedia() {
        evaluateJavaScript("""
            var elements = ["\(elements.joined(separator: "\",\""))"]

            elements.forEach((element) => {
                document.querySelectorAll(`${element}-placeholder`).forEach((el) => {
                    var regex = new RegExp(`${element}-placeholder`, "g")
                    el.outerHTML = el.outerHTML.replace(regex, element)
                })
            })

            // Make all images tappable
            document.querySelectorAll('img').forEach((el) => { el.outerHTML = `<a href="${el.src}">${el.outerHTML}</a>` })
        """, completionHandler: nil)
    }

    /// Change all occurences of elements to change it's HTML tag to "element-placeholder"
    /// Ie.: img -> img-placeholder
    /// This will make the text to appear fast, so the user can start reading
    ///
    private func addPlaceholder(_ htmlContent: String) -> String {
        var content = htmlContent

        elements.forEach { content = content.replacingMatches(of: "<\($0)", with: "<\($0)-placeholder") }

        return content
    }

    /// Returns the content of reader.css
    ///
    private func cssStyles() -> String {
        guard let cssURL = Bundle.main.url(forResource: "reader", withExtension: "css") else {
            return ""
        }

        let cssContent = try? String(contentsOf: cssURL)
        return cssContent ?? ""
    }

    /// Maps app colors to CSS colors to be applied in the webview
    ///
    private func cssColors() -> String {
        if #available(iOS 13, *) {
            return """
                @media (prefers-color-scheme: dark) {
                    \(mappedCSSColors(.dark))
                }

                @media (prefers-color-scheme: light) {
                    \(mappedCSSColors(.light))
                }
            """
        }

        return lightCSSColors()
    }

    /// If iOS 13, returns light and dark colors
    ///
    @available(iOS 13, *)
    private func mappedCSSColors(_ style: UIUserInterfaceStyle) -> String {
        let trait = UITraitCollection(userInterfaceStyle: style)
        return """
            :root {
              --color-text: #\(UIColor.text.color(for: trait).hexString() ?? "");
              --color-neutral-70: #\(UIColor.text.color(for: trait).hexString() ?? "");
              --color-neutral-0: #\(UIColor.listForegroundUnread.color(for: trait).hexString() ?? "");
              --color-neutral-50: #\(UIColor.textSubtle.color(for: trait).hexString() ?? "");
              --main-link-color: #\(UIColor.primary.color(for: trait).hexString() ?? "");
              --main-link-active-color: #\(UIColor.primaryDark.color(for: trait).hexString() ?? "");
            }
        """
    }

    /// If iOS 12 or below, returns only light colors
    ///
    private func lightCSSColors() -> String {
        return """
            :root {
              --color-text: #\(UIColor.text.hexString() ?? "");
              --color-neutral-70: #\(UIColor.text.hexString() ?? "");
              --color-neutral-0: #\(UIColor.listForegroundUnread.hexString() ?? "");
              --color-neutral-50: #\(UIColor.textSubtle.hexString() ?? "");
              --main-link-color: #\(UIColor.primary.hexString() ?? "");
              --main-link-active-color: #\(UIColor.primaryDark.hexString() ?? "");
            }
        """
    }
}
