using Avalonia;
using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Markup.Xaml;
using Avalonia.Platform.Storage;  // ДОБАВЬТЕ ЭТОТ using
using System;
using System.IO;
using System.Linq;  // ДОБАВЬТЕ ЭТОТ using

namespace HtmlReportViewer;

public partial class MainWindow : Window
{
    private string _htmlPath = "index.html";

    public MainWindow()
    {
        InitializeComponent();
    }

    public MainWindow(string htmlPath) : this()
    {
        _htmlPath = htmlPath;
    }

    private void InitializeComponent()
    {
        AvaloniaXamlLoader.Load(this);
    }

    private void OnWebViewLoaded(object? sender, RoutedEventArgs e)
    {
        var webView = this.FindControl<WebViewControl.WebView>("webView");

        if (webView != null && !string.IsNullOrEmpty(_htmlPath))
        {
            string fullPath = Path.GetFullPath(_htmlPath);

            if (File.Exists(fullPath))
            {
                webView.Address = new Uri(fullPath).AbsoluteUri;
            }
            else
            {
                webView.LoadHtml($@"
                    <html>
                        <body style='font-family: Arial; padding: 20px;'>
                            <h2 style='color: red;'>Error: File not found</h2>
                            <p>Could not find: {fullPath}</p>
                        </body>
                    </html>");
            }
        }
    }

    // ДОБАВЬТЕ ЭТОТ МЕТОД:
    private async void OnOpenClick(object? sender, RoutedEventArgs e)
    {
        var webView = this.FindControl<WebViewControl.WebView>("webView");
        if (webView == null) return;

        var options = new FilePickerOpenOptions
        {
            Title = "Open HTML File",
            AllowMultiple = false,
            FileTypeFilter = new[]
            {
                new FilePickerFileType("HTML Files")
                {
                    Patterns = new[] { "*.html", "*.htm" }
                },
                new FilePickerFileType("All Files")
                {
                    Patterns = new[] { "*" }
                }
            }
        };

        var files = await StorageProvider.OpenFilePickerAsync(options);

        if (files.Count > 0)
        {
            var path = files[0].Path.LocalPath;
            _htmlPath = path;
            webView.Address = new Uri(path).AbsoluteUri;
        }
    }

    private void OnPrintClick(object? sender, RoutedEventArgs e)
    {
        var webView = this.FindControl<WebViewControl.WebView>("webView");
        webView?.ExecuteScript("window.print();");
    }

    private void OnReloadClick(object? sender, RoutedEventArgs e)
    {
        var webView = this.FindControl<WebViewControl.WebView>("webView");
        webView?.Reload();
    }

    private void OnExitClick(object? sender, RoutedEventArgs e)
    {
        Close();
    }
}