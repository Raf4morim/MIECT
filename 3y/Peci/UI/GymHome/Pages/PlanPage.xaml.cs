// Copyright (c) Microsoft Corporation and Contributors.
// Licensed under the MIT License.

using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Controls.Primitives;
using Microsoft.UI.Xaml.Data;
using Microsoft.UI.Xaml.Input;
using Microsoft.UI.Xaml.Media;
using Microsoft.UI.Xaml.Navigation;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;

// To learn more about WinUI, the WinUI project structure,
// and more about our project templates, see: http://aka.ms/winui-project-info.

namespace GymHome
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class PlanPage : Page
    {
        public PlanPage()
        {
            this.InitializeComponent();
            DataContext = new PlanViewModel();
        }

        private async void Page_Loaded(object sender, RoutedEventArgs e)
        {
            await ((PlanViewModel)DataContext).PageLoaded();
        }

        private void Expander_Expanding(Expander sender, ExpanderExpandingEventArgs args)
        {
            ((PlanViewModel)DataContext).Expander_Expanding(sender);
        }
    }
}
