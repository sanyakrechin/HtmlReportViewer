using Avalonia;
using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Markup.Xaml;
using Avalonia.Platform.Storage;
using System;
using System.IO;
using System.Linq;

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
        // AVALONIA v12: Встроенный WebView из Avalonia.Controls
        var webView = this.FindControl<WebView>("webView");

        if (webView != null && !string.IsNullOrEmpty(_htmlPath))
        {
            string fullPath = Path.GetFullPath(_htmlPath);

            if (File.Exists(fullPath))
            {
                // v12: используем Source вместо Address
                webView.Source = new Uri(fullPath);
            }
            else
            {
                // v12: LoadHtml может иметь другую сигнатуру
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

    private async void OnOpenClick(object? sender, RoutedEventArgs e)
    {
        var webView = this.FindControl<WebView>("webView");
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
            // v12: Source вместо Address
            webView.Source = new Uri(path);
        }
    }

    private void OnPrintClick(object? sender, RoutedEventArgs e)
    {
        var webView = this.FindControl<WebView>("webView");
        // v12: ExecuteScript вместо ExecuteScriptAsync (или async версия если есть)
        webView?.ExecuteScript("window.print();");
    }

    private void OnReloadClick(object? sender, RoutedEventArgs e)
    {
        var webView = this.FindControl<WebView>("webView");
        webView?.Reload();
    }

    private void OnExitClick(object? sender, RoutedEventArgs e)
    {
        Close();
    }
}
