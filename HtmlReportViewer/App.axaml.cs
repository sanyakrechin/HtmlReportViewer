using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Markup.Xaml;
using System;

namespace HtmlReportViewer;

public partial class App : Application
{
    public override void Initialize()
    {
        AvaloniaXamlLoader.Load(this);
    }

    public override void OnFrameworkInitializationCompleted()
    {
        string[] args = Environment.GetCommandLineArgs();
        string htmlPath = args.Length > 1 ? args[1] : "index.html";

        if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
        {
            desktop.MainWindow = new MainWindow(htmlPath);
        }

        base.OnFrameworkInitializationCompleted();
    }
}