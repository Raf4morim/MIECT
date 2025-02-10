package com.example.forn2;

import androidx.appcompat.app.AppCompatActivity;
import android.webkit.WebView;
import android.os.Bundle;

public class MainActivity extends AppCompatActivity {

    private WebView view;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        WebView view = (WebView) findViewById(R.id.WebView);
        view.getSettings().setJavaScriptEnabled(true);
        view.loadUrl("file:///android_asset/index.html");
    }
}